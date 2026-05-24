<# 
.SYNOPSIS
Create/open BMAD project workspaces under bmad-projects/.

.DESCRIPTION
Each BMAD project lives in bmad-projects/<slug>/ and reuses the central BMAD install by
creating junctions:
  - bmad-projects/<slug>/_bmad   -> <repo>/_Bmad/_bmad
  - bmad-projects/<slug>/.agents -> <repo>/_Bmad/.agents

This keeps BMAD outputs scoped to the project folder (via {project-root}) while
avoiding duplicate BMAD installs.
#>

[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet('new', 'open', 'list', 'status', 'checkpoint')]
  [string]$Command = 'list',

  [Parameter(Position = 1)]
  [string]$Name,

  [string]$Step,

  [switch]$NoLaunch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
  $root = Resolve-Path (Join-Path $PSScriptRoot '..')
  return $root.Path
}

function ConvertTo-Slug {
  param([Parameter(Mandatory = $true)][string]$Text)
  $t = $Text.Trim().ToLowerInvariant()
  $t = $t -replace '[^a-z0-9]+', '-'
  $t = $t -replace '(^-+)|(-+$)', ''
  if ([string]::IsNullOrWhiteSpace($t)) {
    throw "Could not derive a slug from Name='$Text'."
  }
  return $t
}

function Ensure-Dir {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Ensure-Junction {
  param(
    [Parameter(Mandatory = $true)][string]$LinkPath,
    [Parameter(Mandatory = $true)][string]$TargetPath
  )

  if (Test-Path -LiteralPath $LinkPath) {
    return
  }

  $parent = Split-Path -Parent $LinkPath
  Ensure-Dir -Path $parent

  New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
}

function Read-State {
  param([Parameter(Mandatory = $true)][string]$StatePath)
  if (-not (Test-Path -LiteralPath $StatePath)) {
    return $null
  }
  return (Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json)
}

function Write-State {
  param(
    [Parameter(Mandatory = $true)][string]$StatePath,
    [Parameter(Mandatory = $true)]$StateObject
  )
  $json = $StateObject | ConvertTo-Json -Depth 20
  Set-Content -LiteralPath $StatePath -Value $json -Encoding utf8
}

function Ensure-StartHere {
  param(
    [Parameter(Mandatory = $true)][string]$ProjectRoot,
    [Parameter(Mandatory = $true)][string]$DisplayName,
    [Parameter(Mandatory = $true)][string]$Slug
  )

  $path = Join-Path $ProjectRoot 'START-HERE.md'
  if (Test-Path -LiteralPath $path) { return }

  $content = @"
# $DisplayName

This is the consolidated BMAD workspace for **$DisplayName** (`$Slug`).

## Where things go

- BMAD outputs (generated): `_bmad-output/`
- Resume state / checkpoints: `.bmad/state.json`
- Shared BMAD engine (junction): `_bmad/`
- Shared BMAD skills (junction): `.agents/`

## Resume quickly

From the repo root:

```powershell
.\scripts\bmad-project.ps1 status "$Slug"
.\scripts\bmad-project.ps1 checkpoint "$Slug" -Step "<what you just completed / next step>"
```

## Suggested workflow

- Keep your project notes, drafts, and artifacts in this folder (alongside this file).
- Run BMAD skills from within this workspace so `{project-root}` resolves here and outputs stay consolidated.
"@

  Set-Content -LiteralPath $path -Value $content -Encoding utf8
}

function Ensure-Project {
  param(
    [Parameter(Mandatory = $true)][string]$ProjectsRoot,
    [Parameter(Mandatory = $true)][string]$BmadInstallRoot,
    [Parameter(Mandatory = $true)][string]$Slug,
    [Parameter(Mandatory = $true)][string]$DisplayName
  )

  $projRoot = Join-Path $ProjectsRoot $Slug
  Ensure-Dir -Path $projRoot

  Ensure-Junction -LinkPath (Join-Path $projRoot '_bmad') -TargetPath (Join-Path $BmadInstallRoot '_bmad')
  Ensure-Junction -LinkPath (Join-Path $projRoot '.agents') -TargetPath (Join-Path $BmadInstallRoot '.agents')

  $metaDir = Join-Path $projRoot '.bmad'
  Ensure-Dir -Path $metaDir

  $statePath = Join-Path $metaDir 'state.json'
  if (-not (Test-Path -LiteralPath $statePath)) {
    $now = (Get-Date).ToString('o')
    $state = [ordered]@{
      schemaVersion = 1
      name = $DisplayName
      slug = $Slug
      createdAt = $now
      updatedAt = $now
      lastCheckpoint = $null
    }
    Write-State -StatePath $statePath -StateObject $state
  }

  Ensure-StartHere -ProjectRoot $projRoot -DisplayName $DisplayName -Slug $Slug

  return $projRoot
}

function Try-LaunchEditor {
  param([Parameter(Mandatory = $true)][string]$FolderPath)

  $cursor = Get-Command 'cursor' -ErrorAction SilentlyContinue
  if ($cursor) {
    Start-Process -FilePath $cursor.Source -ArgumentList @($FolderPath) | Out-Null
    return $true
  }

  $code = Get-Command 'code' -ErrorAction SilentlyContinue
  if ($code) {
    Start-Process -FilePath $code.Source -ArgumentList @($FolderPath) | Out-Null
    return $true
  }

  return $false
}

$repoRoot = Get-RepoRoot
$projectsRoot = Join-Path $repoRoot 'bmad-projects'
$bmadInstallRoot = Join-Path $repoRoot '_Bmad'

if (-not (Test-Path -LiteralPath (Join-Path $bmadInstallRoot '_bmad'))) {
  throw "BMAD install not found at $(Join-Path $bmadInstallRoot '_bmad'). Expected repo to contain _Bmad/_bmad."
}
if (-not (Test-Path -LiteralPath (Join-Path $bmadInstallRoot '.agents'))) {
  throw "BMAD skills not found at $(Join-Path $bmadInstallRoot '.agents'). Expected repo to contain _Bmad/.agents."
}

Ensure-Dir -Path $projectsRoot

switch ($Command) {
  'list' {
    if (-not (Test-Path -LiteralPath $projectsRoot)) { return }
    Get-ChildItem -LiteralPath $projectsRoot -Directory | Select-Object -ExpandProperty Name
  }

  'new' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name is required for 'new'." }
    $slug = ConvertTo-Slug -Text $Name
    $projRoot = Ensure-Project -ProjectsRoot $projectsRoot -BmadInstallRoot $bmadInstallRoot -Slug $slug -DisplayName $Name
    if (-not $NoLaunch) { [void](Try-LaunchEditor -FolderPath $projRoot) }
    $projRoot
  }

  'open' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'open'." }
    $slug = ConvertTo-Slug -Text $Name
    $projRoot = Ensure-Project -ProjectsRoot $projectsRoot -BmadInstallRoot $bmadInstallRoot -Slug $slug -DisplayName $Name
    if (-not $NoLaunch) { [void](Try-LaunchEditor -FolderPath $projRoot) }
    $projRoot
  }

  'status' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'status'." }
    $slug = ConvertTo-Slug -Text $Name
    $projRoot = Ensure-Project -ProjectsRoot $projectsRoot -BmadInstallRoot $bmadInstallRoot -Slug $slug -DisplayName $Name
    $statePath = Join-Path (Join-Path $projRoot '.bmad') 'state.json'
    $state = Read-State -StatePath $statePath
    if ($null -eq $state) { throw "State missing at $statePath" }
    $state
  }

  'checkpoint' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'checkpoint'." }
    if ([string]::IsNullOrWhiteSpace($Step)) { throw "Step is required for 'checkpoint' (use -Step)." }
    $slug = ConvertTo-Slug -Text $Name
    $projRoot = Ensure-Project -ProjectsRoot $projectsRoot -BmadInstallRoot $bmadInstallRoot -Slug $slug -DisplayName $Name
    $statePath = Join-Path (Join-Path $projRoot '.bmad') 'state.json'
    $state = Read-State -StatePath $statePath
    $now = (Get-Date).ToString('o')
    $state.updatedAt = $now
    $state.lastCheckpoint = [ordered]@{
      at = $now
      step = $Step
    }
    Write-State -StatePath $statePath -StateObject $state
    $state
  }
}

