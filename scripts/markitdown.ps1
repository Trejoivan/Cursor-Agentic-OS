<#
.SYNOPSIS
Convert files/folders into Markdown using MarkItDown (Microsoft).

.DESCRIPTION
Creates a local, repo-scoped MarkItDown environment under `.cache/markitdown/` and
exposes a small wrapper to convert single files or whole folders into Markdown.

This is designed for "AI prep" workflows where you want a normalized Markdown view
of mixed inputs (pdf/docx/pptx/xlsx/images/html/json/zip/etc).

.EXAMPLES
# Install MarkItDown into a repo-local venv
.\scripts\markitdown.ps1 install

# Convert one file into a Markdown file
.\scripts\markitdown.ps1 convert -Path ".\docs\report.pdf" -Out ".\out\report.md"

# Convert a whole folder (recursive) into an output directory
.\scripts\markitdown.ps1 convert -Path ".\meeting-os" -OutDir ".\.cache\md-out" -Recurse

# Bundle multiple conversions into a single Markdown file
.\scripts\markitdown.ps1 bundle -Path ".\meeting-os" -Out ".\out\meeting-os.bundle.md" -Recurse
#>

[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet('status', 'install', 'convert', 'bundle', 'docker-build')]
  [string]$Command = 'status',

  [Parameter()]
  [string]$Path,

  [Parameter()]
  [string]$Out,

  [Parameter()]
  [string]$OutDir,

  [Parameter()]
  [switch]$Recurse,

  [Parameter()]
  [switch]$UsePlugins,

  [Parameter()]
  [switch]$UseDocker
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
  $root = Resolve-Path (Join-Path $PSScriptRoot '..')
  return $root.Path
}

function Ensure-Dir {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Get-CacheRoot {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path $RepoRoot '.cache\markitdown')
}

function Get-VenvRoot {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path (Get-CacheRoot -RepoRoot $RepoRoot) '.venv')
}

function Get-VenvPython {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path (Get-VenvRoot -RepoRoot $RepoRoot) 'Scripts\python.exe')
}

function Get-VenvMarkItDownExe {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path (Get-VenvRoot -RepoRoot $RepoRoot) 'Scripts\markitdown.exe')
}

function Get-RelativeToRepo {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$FullPath
  )

  $rp = (Resolve-Path -LiteralPath $RepoRoot).Path.TrimEnd('\', '/')
  # Use an unresolved absolute path so this works for output paths that don't exist yet.
  $fp = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FullPath)

  if ($fp.StartsWith($rp, [StringComparison]::OrdinalIgnoreCase)) {
    return $fp.Substring($rp.Length).TrimStart('\', '/')
  }

  return $fp
}

function Ensure-Venv {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)

  $cacheRoot = Get-CacheRoot -RepoRoot $RepoRoot
  Ensure-Dir -Path $cacheRoot

  $venvRoot = Get-VenvRoot -RepoRoot $RepoRoot
  $py = Get-VenvPython -RepoRoot $RepoRoot

  if (Test-Path -LiteralPath $py) { return }

  $python = Get-Command 'python' -ErrorAction SilentlyContinue
  if (-not $python) {
    throw "Python was not found on PATH. Install Python 3.10+ or rerun with -UseDocker."
  }

  & $python.Source -m venv $venvRoot
  if ($LASTEXITCODE -ne 0) { throw "Failed to create venv at '$venvRoot'." }
}

function Ensure-MarkItDown {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)

  Ensure-Venv -RepoRoot $RepoRoot

  $py = Get-VenvPython -RepoRoot $RepoRoot
  $exe = Get-VenvMarkItDownExe -RepoRoot $RepoRoot
  if (Test-Path -LiteralPath $exe) { return }

  & $py -m pip install --upgrade pip | Out-Null
  & $py -m pip install "markitdown[all]"
  if ($LASTEXITCODE -ne 0) { throw "Failed to install MarkItDown into repo-local venv." }
}

function Ensure-DockerImage {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)

  $docker = Get-Command 'docker' -ErrorAction SilentlyContinue
  if (-not $docker) {
    throw "Docker was not found on PATH."
  }

  $toolDir = Join-Path $RepoRoot 'tools\markitdown'
  $dockerfile = Join-Path $toolDir 'Dockerfile'
  if (-not (Test-Path -LiteralPath $dockerfile)) {
    throw "Missing tools/markitdown/Dockerfile. Recreate it or reinstall integration."
  }

  & $docker.Source build -t agentic-os-markitdown:latest $toolDir
  if ($LASTEXITCODE -ne 0) { throw "Docker build failed." }
}

function Convert-OneLocal {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$InFile,
    [Parameter(Mandatory = $true)][string]$OutFile,
    [Parameter(Mandatory = $true)][bool]$EnablePlugins
  )

  Ensure-MarkItDown -RepoRoot $RepoRoot
  $exe = Get-VenvMarkItDownExe -RepoRoot $RepoRoot
  Ensure-Dir -Path (Split-Path -Parent $OutFile)

  $args = @()
  if ($EnablePlugins) { $args += @('--use-plugins') }
  $args += @($InFile, '-o', $OutFile)

  & $exe @args
  if ($LASTEXITCODE -ne 0) { throw "MarkItDown failed for '$InFile'." }
}

function Convert-OneDocker {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$InFile,
    [Parameter(Mandatory = $true)][string]$OutFile,
    [Parameter(Mandatory = $true)][bool]$EnablePlugins
  )

  $docker = Get-Command 'docker' -ErrorAction SilentlyContinue
  if (-not $docker) { throw "Docker was not found on PATH." }

  $inRel = Get-RelativeToRepo -RepoRoot $RepoRoot -FullPath $InFile
  $outRel = Get-RelativeToRepo -RepoRoot $RepoRoot -FullPath $OutFile
  Ensure-Dir -Path (Split-Path -Parent $OutFile)

  $containerIn = ('/repo/' + ($inRel -replace '\\', '/'))
  $containerOut = ('/repo/' + ($outRel -replace '\\', '/'))

  $args = @('run', '--rm',
    '--mount', ('type=bind,source=' + $RepoRoot + ',target=/repo'),
    'agentic-os-markitdown:latest'
  )

  if ($EnablePlugins) {
    $args += @('--use-plugins', $containerIn, '-o', $containerOut)
  } else {
    $args += @($containerIn, '-o', $containerOut)
  }

  & $docker.Source @args
  if ($LASTEXITCODE -ne 0) { throw "MarkItDown (Docker) failed for '$InFile'." }
}

function Convert-One {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$InFile,
    [Parameter(Mandatory = $true)][string]$OutFile,
    [Parameter(Mandatory = $true)][bool]$EnablePlugins,
    [Parameter(Mandatory = $true)][bool]$DockerMode
  )

  if ($DockerMode) {
    Convert-OneDocker -RepoRoot $RepoRoot -InFile $InFile -OutFile $OutFile -EnablePlugins $EnablePlugins
  } else {
    Convert-OneLocal -RepoRoot $RepoRoot -InFile $InFile -OutFile $OutFile -EnablePlugins $EnablePlugins
  }
}

function Get-InputFiles {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][bool]$RecurseFiles
  )

  if (Test-Path -LiteralPath $Path -PathType Leaf) {
    return @((Resolve-Path -LiteralPath $Path).Path)
  }

  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    throw "Input path not found: '$Path'"
  }

  $root = (Resolve-Path -LiteralPath $Path).Path
  $opts = @{}
  if ($RecurseFiles) { $opts['Recurse'] = $true }

  $files =
    Get-ChildItem -LiteralPath $root -File @opts |
    Where-Object {
      # Skip obvious noisy/huge folders even when recursing
      $_.FullName -notmatch '[\\/]node_modules[\\/]' -and
      $_.FullName -notmatch '[\\/]\\.git[\\/]' -and
      $_.FullName -notmatch '[\\/]\\.cache[\\/]' -and
      $_.FullName -notmatch '[\\/]\\.venv[\\/]'
    } |
    Select-Object -ExpandProperty FullName

  return @($files)
}

function New-OutPathForFile {
  param(
    [Parameter(Mandatory = $true)][string]$BaseOutDir,
    [Parameter(Mandatory = $true)][string]$InputRoot,
    [Parameter(Mandatory = $true)][string]$FilePath
  )

  $inRoot = (Resolve-Path -LiteralPath $InputRoot).Path.TrimEnd('\', '/')
  $fp = (Resolve-Path -LiteralPath $FilePath).Path

  $rel = $fp
  if ($fp.StartsWith($inRoot, [StringComparison]::OrdinalIgnoreCase)) {
    $rel = $fp.Substring($inRoot.Length).TrimStart('\', '/')
  }

  $safe = ($rel -replace '[\\/]+', '\')
  return (Join-Path $BaseOutDir ($safe + '.md'))
}

$repoRoot = Get-RepoRoot

switch ($Command) {
  'status' {
    $cache = Get-CacheRoot -RepoRoot $repoRoot
    $venv = Get-VenvRoot -RepoRoot $repoRoot
    [ordered]@{
      repoRoot = $repoRoot
      cacheRoot = $cache
      venvRoot = $venv
      python = $(if (Test-Path -LiteralPath (Get-VenvPython -RepoRoot $repoRoot)) { Get-VenvPython -RepoRoot $repoRoot } else { $null })
      markitdown = $(if (Test-Path -LiteralPath (Get-VenvMarkItDownExe -RepoRoot $repoRoot)) { Get-VenvMarkItDownExe -RepoRoot $repoRoot } else { $null })
    }
  }

  'install' {
    if ($UseDocker) {
      Ensure-DockerImage -RepoRoot $repoRoot
      [ordered]@{ installed = 'docker'; image = 'agentic-os-markitdown:latest' }
    } else {
      Ensure-MarkItDown -RepoRoot $repoRoot
      [ordered]@{ installed = 'venv'; markitdown = (Get-VenvMarkItDownExe -RepoRoot $repoRoot) }
    }
  }

  'docker-build' {
    Ensure-DockerImage -RepoRoot $repoRoot
    [ordered]@{ built = $true; image = 'agentic-os-markitdown:latest' }
  }

  'convert' {
    if ([string]::IsNullOrWhiteSpace($Path)) { throw "Path is required for 'convert' (use -Path)." }
    if ([string]::IsNullOrWhiteSpace($Out) -and [string]::IsNullOrWhiteSpace($OutDir)) {
      throw "Provide -Out (single file) or -OutDir (folder output)."
    }

    $files = @(Get-InputFiles -Path $Path -RecurseFiles ([bool]$Recurse))
    if ($files.Count -eq 0) { throw "No files found under '$Path'." }

    $inputRoot = $Path
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
      $inputRoot = (Split-Path -Parent (Resolve-Path -LiteralPath $Path).Path)
    }

    if ($Out) {
      if ($files.Count -ne 1) { throw "-Out is only valid when converting exactly one file. Use -OutDir instead." }
      Convert-One -RepoRoot $repoRoot -InFile $files[0] -OutFile $Out -EnablePlugins ([bool]$UsePlugins) -DockerMode ([bool]$UseDocker)
      return
    }

    Ensure-Dir -Path $OutDir
    foreach ($f in $files) {
      $outPath = New-OutPathForFile -BaseOutDir $OutDir -InputRoot $inputRoot -FilePath $f
      Convert-One -RepoRoot $repoRoot -InFile $f -OutFile $outPath -EnablePlugins ([bool]$UsePlugins) -DockerMode ([bool]$UseDocker)
    }
  }

  'bundle' {
    if ([string]::IsNullOrWhiteSpace($Path)) { throw "Path is required for 'bundle' (use -Path)." }
    if ([string]::IsNullOrWhiteSpace($Out)) { throw "Out is required for 'bundle' (use -Out)." }

    $tempDir = Join-Path (Get-CacheRoot -RepoRoot $repoRoot) ('bundle-tmp-' + ([guid]::NewGuid().ToString('n')))
    Ensure-Dir -Path $tempDir

    $files = @(Get-InputFiles -Path $Path -RecurseFiles ([bool]$Recurse))
    if ($files.Count -eq 0) { throw "No files found under '$Path'." }

    $inputRoot = $Path
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
      $inputRoot = (Split-Path -Parent (Resolve-Path -LiteralPath $Path).Path)
    }

    $bundleLines = New-Object System.Collections.Generic.List[string]
    $bundleLines.Add('# MarkItDown bundle')
    $bundleLines.Add('')
    $bundleLines.Add(('- Generated at: ' + (Get-Date).ToString('o')))
    $bundleLines.Add(('- Source: ' + (Resolve-Path -LiteralPath $Path).Path))
    $bundleLines.Add('')

    foreach ($f in $files) {
      $tmpOut = New-OutPathForFile -BaseOutDir $tempDir -InputRoot $inputRoot -FilePath $f
      Convert-One -RepoRoot $repoRoot -InFile $f -OutFile $tmpOut -EnablePlugins ([bool]$UsePlugins) -DockerMode ([bool]$UseDocker)

      $rel = $f
      try { $rel = Get-RelativeToRepo -RepoRoot $repoRoot -FullPath $f } catch { }

      $bundleLines.Add('---')
      $bundleLines.Add('')
      $bundleLines.Add(('## ' + $rel))
      $bundleLines.Add('')

      if (Test-Path -LiteralPath $tmpOut) {
        $bundleLines.Add((Get-Content -LiteralPath $tmpOut -Raw))
      } else {
        $bundleLines.Add('(conversion produced no output)')
      }
      $bundleLines.Add('')
    }

    Ensure-Dir -Path (Split-Path -Parent $Out)
    Set-Content -LiteralPath $Out -Encoding utf8 -Value ($bundleLines -join [Environment]::NewLine)
  }
}

