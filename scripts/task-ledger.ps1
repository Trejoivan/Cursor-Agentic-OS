<#
.SYNOPSIS
Repo-wide ad-hoc task tracking with summarize+reset.

.DESCRIPTION
Stores a local-first task ledger under .task-ledger/ (gitignored by default).

Core goals:
- Track one-off tasks in this repo with minimal friction (log or run via wrapper).
- Auto-group by "project" based on your current working directory (override with -Project).
- Summarize everything since the last reset, then archive and reset the ledger.

.EXAMPLES
.\scripts\task-ledger.ps1 log -What "Reviewed PRD draft" -Project "work-os"

.\scripts\task-ledger.ps1 run -What "Update junctions" -Cmd ".\scripts\bmad-project.ps1 open my-project -NoLaunch"

.\scripts\task-ledger.ps1 summarize
#>

[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet('log', 'run', 'summarize', 'status')]
  [string]$Command = 'status',

  [string]$What,

  [string]$Project,

  [string[]]$Tags,

  [string]$Cmd
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

function Read-Json {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  $raw = Get-Content -LiteralPath $Path -Raw
  if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
  return ($raw | ConvertFrom-Json)
}

function Write-Json {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)]$Object
  )
  $json = $Object | ConvertTo-Json -Depth 50
  Set-Content -LiteralPath $Path -Value $json -Encoding utf8
}

function New-Id {
  return ([guid]::NewGuid().ToString('n'))
}

function Try-GetGitInfo {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)

  $git = Get-Command 'git' -ErrorAction SilentlyContinue
  if (-not $git) { return $null }

  $branch = $null
  $commit = $null

  try {
    $b = & git -C $RepoRoot rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($b)) { $branch = ($b | Select-Object -First 1).Trim() }
  } catch { }

  try {
    $c = & git -C $RepoRoot rev-parse HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($c)) { $commit = ($c | Select-Object -First 1).Trim() }
  } catch { }

  if (-not $branch -and -not $commit) { return $null }

  return [ordered]@{
    branch = $branch
    commit = $commit
  }
}

function Get-DefaultProject {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Cwd
  )

  try {
    $rel = Resolve-Path -LiteralPath $Cwd | ForEach-Object { $_.Path }
  } catch {
    $rel = $Cwd
  }

  if ($rel.StartsWith($RepoRoot, [StringComparison]::OrdinalIgnoreCase)) {
    $rel = $rel.Substring($RepoRoot.Length).TrimStart('\', '/')
  }

  if ([string]::IsNullOrWhiteSpace($rel)) { return 'repo-root' }

  $parts = $rel -split '[\\/]' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
  if ($parts.Length -eq 0) { return 'repo-root' }

  # bmad-projects/<slug>/...
  if ($parts[0] -eq 'bmad-projects' -and $parts.Length -ge 2) {
    return ('bmad:' + $parts[1])
  }

  # _mini_bmad/runs/<yyyy-mm>/<run-id>/...
  if ($parts[0] -eq '_mini_bmad' -and $parts.Length -ge 4 -and $parts[1] -eq 'runs') {
    return ('mini:' + $parts[3])
  }

  # Core OS folders
  if ($parts[0] -in @('work-os', 'career-os', 'personal-os', 'meeting-os')) {
    return ('os:' + $parts[0])
  }

  return $parts[0]
}

function Get-LedgerRoot {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path $RepoRoot '.task-ledger')
}

function Get-LedgerPath {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path (Get-LedgerRoot -RepoRoot $RepoRoot) 'ledger.jsonl')
}

function Get-StatePath {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path (Get-LedgerRoot -RepoRoot $RepoRoot) 'state.json')
}

function Append-LedgerEntry {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)]$Entry
  )

  $root = Get-LedgerRoot -RepoRoot $RepoRoot
  Ensure-Dir -Path $root

  $ledgerPath = Get-LedgerPath -RepoRoot $RepoRoot

  $line = $Entry | ConvertTo-Json -Depth 50 -Compress
  Add-Content -LiteralPath $ledgerPath -Encoding utf8 -Value $line
}

function Read-LedgerEntries {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)

  $ledgerPath = Get-LedgerPath -RepoRoot $RepoRoot
  if (-not (Test-Path -LiteralPath $ledgerPath)) { return @() }

  $lines = Get-Content -LiteralPath $ledgerPath
  $entries = @()
  foreach ($l in $lines) {
    if ([string]::IsNullOrWhiteSpace($l)) { continue }
    try { $entries += @($l | ConvertFrom-Json) } catch { }
  }
  return $entries
}

function Write-SummaryAndReset {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot
  )

  $ledgerRoot = Get-LedgerRoot -RepoRoot $RepoRoot
  Ensure-Dir -Path $ledgerRoot
  $archiveDir = Join-Path $ledgerRoot 'archive'
  $summaryDir = Join-Path $ledgerRoot 'summary'
  Ensure-Dir -Path $archiveDir
  Ensure-Dir -Path $summaryDir

  $entries = @(Read-LedgerEntries -RepoRoot $RepoRoot)
  $now = (Get-Date).ToString('o')
  $stamp = (Get-Date).ToString('yyyyMMdd-HHmmss')

  $summaryPath = Join-Path $summaryDir ("SUMMARY-" + $stamp + '.md')
  $lastSummaryPath = Join-Path $summaryDir 'LAST-SUMMARY.md'

  $lines = @(
    '---',
    'task_ledger_summary:',
    '  schemaVersion: 1',
    ('  generatedAt: ' + $now),
    ('  entryCount: ' + $entries.Count),
    '---',
    '',
    '# Task ledger summary',
    '',
    'This is a repo-wide summary of ad-hoc tasks recorded via `scripts/task-ledger.ps1`.',
    ''
  )

  if ($entries.Count -eq 0) {
    $lines += @('- (no tracked tasks since last reset)')
  } else {
    $grouped = $entries | Group-Object -Property project | Sort-Object -Property Name
    foreach ($g in $grouped) {
      $proj = $g.Name
      if ([string]::IsNullOrWhiteSpace($proj)) { $proj = '(unassigned)' }
      $lines += @('', ('## ' + $proj), '')

      $items = @($g.Group | Sort-Object -Property ts)
      foreach ($e in $items) {
        $ts = $e.ts
        $what = $e.what
        if ([string]::IsNullOrWhiteSpace($what)) { $what = '(' + $e.type + ')' }

        if ($e.type -eq 'run') {
          $cmd = $e.cmd
          $exit = $e.exitCode
          $dur = $e.durationMs
          $lines += @("- [$ts] $what  (`$cmd`, exit=$exit, ${dur}ms)")
        } else {
          $lines += @("- [$ts] $what")
        }
      }
    }
  }

  Set-Content -LiteralPath $summaryPath -Encoding utf8 -Value ($lines -join [Environment]::NewLine)
  Copy-Item -LiteralPath $summaryPath -Destination $lastSummaryPath -Force

  # Archive and reset the ledger.
  $ledgerPath = Get-LedgerPath -RepoRoot $RepoRoot
  if (Test-Path -LiteralPath $ledgerPath) {
    $archivePath = Join-Path $archiveDir ("ledger-" + $stamp + '.jsonl')
    Copy-Item -LiteralPath $ledgerPath -Destination $archivePath -Force
    Clear-Content -LiteralPath $ledgerPath
  }

  $statePath = Get-StatePath -RepoRoot $RepoRoot
  $state = Read-Json -Path $statePath
  if ($null -eq $state) {
    $state = [ordered]@{ schemaVersion = 1 }
  }
  $state.lastSummarizedAt = $now
  $state.lastSummaryPath = $summaryPath.Substring($RepoRoot.Length).TrimStart('\', '/')
  Write-Json -Path $statePath -Object $state

  return [ordered]@{
    summary = $summaryPath
    reset = $true
    entryCount = $entries.Count
  }
}

$repoRoot = Get-RepoRoot
$cwd = (Get-Location).Path
$projectAuto = Get-DefaultProject -RepoRoot $repoRoot -Cwd $cwd
$projectFinal = $Project
if ([string]::IsNullOrWhiteSpace($projectFinal)) { $projectFinal = $projectAuto }

$git = Try-GetGitInfo -RepoRoot $repoRoot
$ts = (Get-Date).ToString('o')

function Get-CwdRelativeToRepo {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Cwd
  )
  if ($Cwd.StartsWith($RepoRoot, [StringComparison]::OrdinalIgnoreCase)) {
    return $Cwd.Substring($RepoRoot.Length).TrimStart('\', '/')
  }
  return $Cwd
}

switch ($Command) {
  'status' {
    $entries = @(Read-LedgerEntries -RepoRoot $repoRoot)
    $state = Read-Json -Path (Get-StatePath -RepoRoot $repoRoot)
    [ordered]@{
      repoRoot = $repoRoot
      ledgerPath = (Get-LedgerPath -RepoRoot $repoRoot)
      entryCount = $entries.Count
      defaultProject = $projectAuto
      lastSummarizedAt = $(if ($state -and $state.lastSummarizedAt) { $state.lastSummarizedAt } else { $null })
      lastSummaryPath = $(if ($state -and $state.lastSummaryPath) { $state.lastSummaryPath } else { $null })
    }
  }

  'log' {
    if ([string]::IsNullOrWhiteSpace($What)) { throw "What is required for 'log' (use -What)." }

    $entry = [ordered]@{
      schemaVersion = 1
      id = New-Id
      ts = $ts
      type = 'log'
      what = $What
      project = $projectFinal
      tags = @($Tags | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
      cwd = (Get-CwdRelativeToRepo -RepoRoot $repoRoot -Cwd $cwd)
      git = $git
    }

    Append-LedgerEntry -RepoRoot $repoRoot -Entry $entry
    $entry
  }

  'run' {
    if ([string]::IsNullOrWhiteSpace($Cmd)) { throw "Cmd is required for 'run' (use -Cmd)." }
    if ([string]::IsNullOrWhiteSpace($What)) { $What = $Cmd }

    $shell = (Get-Command 'pwsh' -ErrorAction SilentlyContinue)
    if (-not $shell) { $shell = (Get-Command 'powershell' -ErrorAction SilentlyContinue) }
    if (-not $shell) { throw "Could not find PowerShell executable (pwsh or powershell) on PATH." }

    $start = Get-Date
    & $shell.Source -NoProfile -ExecutionPolicy Bypass -Command $Cmd
    $exitCode = $LASTEXITCODE
    $durationMs = [int]((Get-Date) - $start).TotalMilliseconds

    $entry = [ordered]@{
      schemaVersion = 1
      id = New-Id
      ts = $ts
      type = 'run'
      what = $What
      project = $projectFinal
      tags = @($Tags | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
      cwd = (Get-CwdRelativeToRepo -RepoRoot $repoRoot -Cwd $cwd)
      git = $git
      cmd = $Cmd
      exitCode = $exitCode
      durationMs = $durationMs
    }

    Append-LedgerEntry -RepoRoot $repoRoot -Entry $entry

    if ($exitCode -ne 0) { exit $exitCode }
    $entry
  }

  'summarize' {
    Write-SummaryAndReset -RepoRoot $repoRoot
  }
}

