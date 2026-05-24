<#
.SYNOPSIS
Create/open mini-bmad ad-hoc runs under _mini_bmad/runs/.

.DESCRIPTION
Mini-bmad is for ad-hoc work (research, meeting planning, presentation brainstorming).
Each run lives in _mini_bmad/runs/<yyyy-mm>/<yyyy-mm-dd>-<slug>/ with:
  - START-HERE.md
  - NOTES.md
  - .mini-bmad/state.json (resume/checkpoints + linked BMAD projects)

Summarize consolidates run artifacts into _mini-summary/SUMMARY-PACK.md and can sync
updates into bmad-projects/<slug>/_mini-bmad-updates/.
#>

[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet('new', 'open', 'list', 'status', 'checkpoint', 'link', 'unlink', 'log', 'delta', 'summarize')]
  [string]$Command = 'list',

  [Parameter(Position = 1)]
  [string]$Name,

  [string]$Step,

  [string]$Project,

  [string]$Item,

  [switch]$Sync,

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
    throw ("Could not derive a slug from Name='" + $Text + "'.")
  }
  return $t
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
  return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json)
}

function Write-Json {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)]$Object
  )
  $json = $Object | ConvertTo-Json -Depth 50
  Set-Content -LiteralPath $Path -Value $json -Encoding utf8
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

function Get-RunsRoot {
  param([Parameter(Mandatory = $true)][string]$RepoRoot)
  return (Join-Path (Join-Path $RepoRoot '_mini_bmad') 'runs')
}

function Find-RunBySlug {
  param(
    [Parameter(Mandatory = $true)][string]$RunsRoot,
    [Parameter(Mandatory = $true)][string]$Slug
  )

  if (-not (Test-Path -LiteralPath $RunsRoot)) { return $null }

  $pattern = ('^\d{4}-\d{2}-\d{2}-' + [regex]::Escape($Slug) + '$')
  $matches =
    Get-ChildItem -LiteralPath $RunsRoot -Directory -Recurse |
    Where-Object { $_.Name -match $pattern } |
    Sort-Object -Property FullName -Descending

  return ($matches | Select-Object -First 1)
}

function Get-StatePath {
  param([Parameter(Mandatory = $true)][string]$RunRoot)
  return (Join-Path (Join-Path $RunRoot '.mini-bmad') 'state.json')
}

function Get-ChangesPath {
  param([Parameter(Mandatory = $true)][string]$RunRoot)
  return (Join-Path (Join-Path $RunRoot '.mini-bmad') 'CHANGES.md')
}

function Ensure-ChangesFile {
  param(
    [Parameter(Mandatory = $true)][string]$RunRoot,
    [Parameter(Mandatory = $true)]$State
  )

  $changesPath = Get-ChangesPath -RunRoot $RunRoot
  if (Test-Path -LiteralPath $changesPath) { return $changesPath }

  $lines = @(
    ('# Pending changes - ' + $State.name),
    '',
    'One bullet per meaningful event / item changed. This list is cleared only by `mini-bmad.ps1 delta`.',
    '',
    '- '
  )
  Set-Content -LiteralPath $changesPath -Encoding utf8 -Value ($lines -join [Environment]::NewLine)
  return $changesPath
}

function Ensure-RunFiles {
  param(
    [Parameter(Mandatory = $true)][string]$RunRoot,
    [Parameter(Mandatory = $true)][string]$Slug,
    [Parameter(Mandatory = $true)][string]$DisplayName
  )

  $notesPath = Join-Path $RunRoot 'NOTES.md'
  if (-not (Test-Path -LiteralPath $notesPath)) {
    $notesLines = @(
      '# Notes',
      '',
      '## Goal',
      '',
      '- ',
      '',
      '## Context / background',
      '',
      '- ',
      '',
      '## Findings / ideas',
      '',
      '- ',
      '',
      '## Decisions',
      '',
      '- ',
      '',
      '## Next steps',
      '',
      '- '
    )
    Set-Content -LiteralPath $notesPath -Encoding utf8 -Value ($notesLines -join [Environment]::NewLine)
  }

  $startPath = Join-Path $RunRoot 'START-HERE.md'
  if (-not (Test-Path -LiteralPath $startPath)) {
    $startLines = @(
      ('# ' + $DisplayName),
      '',
      ('This is a mini-bmad ad-hoc run (slug: ' + $Slug + ').'),
      '',
      '## Where to work',
      '',
      '- NOTES.md for ongoing notes',
      '- Add extra artifacts next to it (or create artifacts/)',
      '',
      '## Resume / status',
      '',
      'From the repo root:',
      '',
      '```powershell',
      '.\\scripts\\mini-bmad.ps1 status [run-slug]',
      '.\\scripts\\mini-bmad.ps1 checkpoint [run-slug] -Step [what you just completed / next step]',
      '```',
      '',
      '## Link to a major BMAD project (optional)',
      '',
      'If this ad-hoc work should update a major project:',
      '',
      '```powershell',
      '.\\scripts\\mini-bmad.ps1 link [run-slug] -Project [bmad-project-slug]',
      '.\\scripts\\mini-bmad.ps1 summarize [run-slug] -Sync',
      '```',
      ''
    )
    Set-Content -LiteralPath $startPath -Encoding utf8 -Value ($startLines -join [Environment]::NewLine)
  }
}

function Ensure-Run {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Slug,
    [Parameter(Mandatory = $true)][string]$DisplayName,
    [switch]$AllowExisting
  )

  $runsRoot = Get-RunsRoot -RepoRoot $RepoRoot
  Ensure-Dir -Path $runsRoot

  $existing = Find-RunBySlug -RunsRoot $runsRoot -Slug $Slug
  if ($existing -and (-not $AllowExisting)) {
    throw ("Run '" + $Slug + "' already exists at '" + $existing.FullName + "'. Use 'open' or pass a different name.")
  }

  if ($existing) {
    $runRoot = $existing.FullName
  } else {
    $ym = (Get-Date).ToString('yyyy-MM')
    $datePrefix = (Get-Date).ToString('yyyy-MM-dd')
    $bucket = Join-Path $runsRoot $ym
    Ensure-Dir -Path $bucket
    $runRoot = Join-Path $bucket ($datePrefix + '-' + $Slug)
    Ensure-Dir -Path $runRoot
  }

  $metaDir = Join-Path $runRoot '.mini-bmad'
  Ensure-Dir -Path $metaDir
  $statePath = Get-StatePath -RunRoot $runRoot

  if (-not (Test-Path -LiteralPath $statePath)) {
    $now = (Get-Date).ToString('o')
    $state = [ordered]@{
      schemaVersion = 1
      name = $DisplayName
      slug = $Slug
      createdAt = $now
      updatedAt = $now
      lastCheckpoint = $null
      linkedProjects = @()
      lastDeltaAt = $null
    }
    Write-Json -Path $statePath -Object $state
  }

  Ensure-RunFiles -RunRoot $runRoot -Slug $Slug -DisplayName $DisplayName
  $stateNow = Read-Json -Path $statePath
  [void](Ensure-ChangesFile -RunRoot $runRoot -State $stateNow)
  return $runRoot
}

function Append-Change {
  param(
    [Parameter(Mandatory = $true)][string]$RunRoot,
    [Parameter(Mandatory = $true)]$State,
    [Parameter(Mandatory = $true)][string]$Message
  )

  $changesPath = Ensure-ChangesFile -RunRoot $RunRoot -State $State
  $now = (Get-Date).ToString('o')
  Add-Content -LiteralPath $changesPath -Encoding utf8 -Value ('- ' + $now + ' - ' + $Message)
}

function Read-PendingChanges {
  param([Parameter(Mandatory = $true)][string]$ChangesPath)

  if (-not (Test-Path -LiteralPath $ChangesPath)) { return @() }
  $raw = Get-Content -LiteralPath $ChangesPath
  $items = @()
  foreach ($l in $raw) {
    if ($l -match '^\-\s+\d{4}\-\d{2}\-\d{2}T') { $items += @($l) }
  }
  return $items
}

function Clear-PendingChanges {
  param(
    [Parameter(Mandatory = $true)][string]$ChangesPath,
    [Parameter(Mandatory = $true)]$State
  )

  $lines = @(
    ('# Pending changes - ' + $State.name),
    '',
    'One bullet per meaningful event / item changed. This list is cleared only by `mini-bmad.ps1 delta`.',
    '',
    '- '
  )
  Set-Content -LiteralPath $ChangesPath -Encoding utf8 -Value ($lines -join [Environment]::NewLine)
}

function Delta-Summary {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$RunRoot
  )

  $statePath = Get-StatePath -RunRoot $RunRoot
  $state = Read-Json -Path $statePath
  if ($null -eq $state) { throw ("State missing at " + $statePath) }

  $changesPath = Ensure-ChangesFile -RunRoot $RunRoot -State $state
  $pending = @(Read-PendingChanges -ChangesPath $changesPath)

  $summaryDir = Join-Path $RunRoot '_mini-summary'
  Ensure-Dir -Path $summaryDir

  $now = (Get-Date).ToString('o')
  $deltaPath = Join-Path $summaryDir 'DELTA-SINCE-LAST.md'
  $archivePath = Join-Path $summaryDir ('CHANGES-' + (Get-Date).ToString('yyyyMMdd-HHmmss') + '.md')

  $lines = @(
    '---',
    'mini_bmad_delta:',
    '  schemaVersion: 1',
    ('  runSlug: ' + $state.slug),
    ('  runName: ' + $state.name),
    ('  generatedAt: ' + $now),
    '---',
    '',
    ('# Delta summary - ' + $state.name),
    '',
    '## Since last delta',
    ''
  )

  if ($state.lastDeltaAt) {
    $lines += @('- lastDeltaAt: ' + $state.lastDeltaAt)
  } else {
    $lines += @('- lastDeltaAt: (none)')
  }

  $lines += @('', '## Very short changes', '')

  if ($pending.Length -eq 0) {
    $lines += @('- (no pending changes)')
  } else {
    # Keep it very short: at most 20 bullets.
    $take = $pending
    if ($take.Length -gt 20) { $take = $take[($take.Length - 20)..($take.Length - 1)] }
    foreach ($p in $take) { $lines += @($p) }
    if ($pending.Length -gt 20) { $lines += @('- (truncated: only last 20 shown)') }
  }

  Set-Content -LiteralPath $deltaPath -Encoding utf8 -Value ($lines -join [Environment]::NewLine)

  # Archive and clear pending changes.
  Copy-Item -LiteralPath $changesPath -Destination $archivePath -Force
  Clear-PendingChanges -ChangesPath $changesPath -State $state

  $state.lastDeltaAt = $now
  $state.updatedAt = $now
  Write-Json -Path $statePath -Object $state

  return [ordered]@{
    runRoot = $RunRoot
    deltaSummary = $deltaPath
    archivedChanges = $archivePath
    linkedProjects = @($state.linkedProjects | ForEach-Object { "$_" })
  }
}

function Promote-Templates {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$RunRoot,
    [Parameter(Mandatory = $true)]$State
  )

  $promoted = @()
  $promoteDir = Join-Path $RunRoot '_promote-templates'
  if (-not (Test-Path -LiteralPath $promoteDir)) { return $promoted }

  $templatesRoot = Join-Path (Join-Path $RepoRoot '_mini_bmad') 'templates'
  Ensure-Dir -Path $templatesRoot

  $candidates =
    Get-ChildItem -LiteralPath $promoteDir -File -Recurse |
    Where-Object { $_.Extension -in @('.md', '.txt') } |
    Sort-Object -Property FullName

  foreach ($c in $candidates) {
    $base = $c.BaseName
    $ext = $c.Extension
    $destName = ($State.slug + '-' + $base + $ext)
    $dest = Join-Path $templatesRoot $destName

    $i = 2
    while (Test-Path -LiteralPath $dest) {
      $destName = ($State.slug + '-' + $base + '-' + $i + $ext)
      $dest = Join-Path $templatesRoot $destName
      $i++
    }

    Copy-Item -LiteralPath $c.FullName -Destination $dest
    $promoted += @($dest)
  }

  return $promoted
}

function Summarize-Run {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$RunRoot
  )

  $statePath = Get-StatePath -RunRoot $RunRoot
  $state = Read-Json -Path $statePath
  if ($null -eq $state) { throw ("State missing at " + $statePath) }

  $summaryDir = Join-Path $RunRoot '_mini-summary'
  Ensure-Dir -Path $summaryDir
  $packPath = Join-Path $summaryDir 'SUMMARY-PACK.md'

  $generatedAt = (Get-Date).ToString('o')
  $linked = @()
  if ($state.PSObject.Properties.Name -contains 'linkedProjects') {
    $linked = @($state.linkedProjects | ForEach-Object { "$_" } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  }
  $linkedStr = ($linked | ForEach-Object { "'" + $_ + "'" }) -join ', '

  if ($state.lastCheckpoint -and $state.lastCheckpoint.step) {
    $checkpointLine = ('- lastCheckpoint: ' + $state.lastCheckpoint.at + ' - ' + $state.lastCheckpoint.step)
  } else {
    $checkpointLine = '- lastCheckpoint: (none)'
  }

  $headerLines = @(
    '---',
    'mini_bmad:',
    '  schemaVersion: 1',
    ('  runSlug: ' + $state.slug),
    ('  runName: ' + $state.name),
    ('  generatedAt: ' + $generatedAt),
    ('  linkedProjects: [' + $linkedStr + ']'),
    '---',
    '',
    ('# Summary Pack - ' + $state.name),
    '',
    '## Current state',
    '',
    $checkpointLine,
    '',
    '## What changed (fill in)',
    '',
    '- ',
    '',
    '## Decisions (fill in)',
    '',
    '- ',
    '',
    '## Open questions (fill in)',
    '',
    '- ',
    '',
    '## Next actions (fill in)',
    '',
    '- ',
    '',
    '## Consolidated artifacts (auto-collated)'
  )

  Set-Content -LiteralPath $packPath -Encoding utf8 -Value ($headerLines -join [Environment]::NewLine)

  $promoted = @(Promote-Templates -RepoRoot $RepoRoot -RunRoot $RunRoot -State $state)
  if ($promoted.Length -gt 0) {
    Add-Content -LiteralPath $packPath -Encoding utf8 -Value ([Environment]::NewLine + '---' + [Environment]::NewLine + [Environment]::NewLine + '## Promoted templates (auto-saved)')
    foreach ($p in $promoted) {
      $rel = $p.Substring($RepoRoot.Length).TrimStart('\')
      Add-Content -LiteralPath $packPath -Encoding utf8 -Value ('- ' + $rel)
    }
  }

  $artifactFiles =
    Get-ChildItem -LiteralPath $RunRoot -File -Recurse |
    Where-Object {
      ($_.Extension -in @('.md', '.txt')) -and
      ($_.FullName -notmatch [regex]::Escape((Join-Path $RunRoot '.mini-bmad'))) -and
      ($_.FullName -notmatch [regex]::Escape((Join-Path $RunRoot '_mini-summary')))
    } |
    Sort-Object -Property FullName

  foreach ($f in $artifactFiles) {
    $rel = $f.FullName.Substring($RunRoot.Length).TrimStart('\')
    Add-Content -LiteralPath $packPath -Encoding utf8 -Value ([Environment]::NewLine + '---' + [Environment]::NewLine + [Environment]::NewLine + '### ' + $rel)
    Add-Content -LiteralPath $packPath -Encoding utf8 -Value '```text'
    $raw = (Get-Content -LiteralPath $f.FullName -Raw).TrimEnd()
    if (-not [string]::IsNullOrWhiteSpace($raw)) {
      Add-Content -LiteralPath $packPath -Encoding utf8 -Value $raw
    }
    Add-Content -LiteralPath $packPath -Encoding utf8 -Value '```'
  }

  $now = (Get-Date).ToString('o')
  $state.updatedAt = $now
  Write-Json -Path $statePath -Object $state

  return [ordered]@{
    runRoot = $RunRoot
    summaryPack = $packPath
    linkedProjects = $linked
    promotedTemplates = $promoted
  }
}

function Sync-ToBmadProjects {
  param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$RunRoot,
    [Parameter(Mandatory = $true)][string]$SummaryPackPath,
    [Parameter(Mandatory = $true)][string[]]$LinkedProjects
  )

  if ($LinkedProjects.Count -eq 0) { return }

  $statePath = Get-StatePath -RunRoot $RunRoot
  $state = Read-Json -Path $statePath
  $runId = Split-Path -Leaf $RunRoot
  $payload = Get-Content -LiteralPath $SummaryPackPath -Raw

  foreach ($p in $LinkedProjects) {
    $projSlug = ConvertTo-Slug -Text $p
    $projRoot = Join-Path (Join-Path $RepoRoot 'bmad-projects') $projSlug

    if (-not (Test-Path -LiteralPath $projRoot)) {
      & (Join-Path $RepoRoot 'scripts\bmad-project.ps1') open $projSlug -NoLaunch | Out-Null
    }

    $updatesDir = Join-Path $projRoot '_mini-bmad-updates'
    Ensure-Dir -Path $updatesDir

    $dest = Join-Path $updatesDir ($runId + '.md')

    $lines = @(
      ('# mini-bmad update: ' + $state.name),
      '',
      ('Source run: `' + $runId + '`'),
      '',
      'This file is an **import payload** generated from `_mini_bmad/` so a major BMAD project can incorporate ad-hoc research/meeting/presentation work.',
      '',
      '## How to use this in a major BMAD project',
      '',
      '- Read the **Summary Pack** content below.',
      '- Update any relevant major-project artifacts (PRFAQ, product brief, plans, specs) based on:',
      '  - new decisions',
      '  - new constraints',
      '  - new research findings',
      '  - new messaging / presentation angles',
      '- If you track progress, checkpoint the major project after incorporating the changes.',
      '',
      '---',
      '',
      $payload
    )

    Set-Content -LiteralPath $dest -Encoding utf8 -Value ($lines -join [Environment]::NewLine)
  }
}

$repoRoot = Get-RepoRoot
Ensure-Dir -Path (Join-Path $repoRoot '_mini_bmad')

switch ($Command) {
  'list' {
    $runsRoot = Get-RunsRoot -RepoRoot $repoRoot
    if (-not (Test-Path -LiteralPath $runsRoot)) { return }
    Get-ChildItem -LiteralPath $runsRoot -Directory -Recurse |
      Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}-' } |
      Sort-Object -Property FullName -Descending |
      ForEach-Object { $_.Name }
  }

  'new' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name is required for 'new'." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name
    if (-not $NoLaunch) { [void](Try-LaunchEditor -FolderPath $runRoot) }
    $runRoot
  }

  'open' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'open'." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    if (-not $NoLaunch) { [void](Try-LaunchEditor -FolderPath $runRoot) }
    $runRoot
  }

  'status' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'status'." }
    $slug = ConvertTo-Slug -Text $Name
    $runsRoot = Get-RunsRoot -RepoRoot $repoRoot
    $run = Find-RunBySlug -RunsRoot $runsRoot -Slug $slug
    if (-not $run) { throw ("Run '" + $slug + "' not found under " + $runsRoot + ".") }
    $statePath = Get-StatePath -RunRoot $run.FullName
    $state = Read-Json -Path $statePath
    if ($null -eq $state) { throw ("State missing at " + $statePath) }
    $state
  }

  'checkpoint' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'checkpoint'." }
    if ([string]::IsNullOrWhiteSpace($Step)) { throw "Step is required for 'checkpoint' (use -Step)." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    $statePath = Get-StatePath -RunRoot $runRoot
    $state = Read-Json -Path $statePath
    $now = (Get-Date).ToString('o')
    $state.updatedAt = $now
    $state.lastCheckpoint = [ordered]@{ at = $now; step = $Step }
    Write-Json -Path $statePath -Object $state
    $state
  }

  'link' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'link'." }
    if ([string]::IsNullOrWhiteSpace($Project)) { throw "Project is required for 'link' (use -Project)." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    $statePath = Get-StatePath -RunRoot $runRoot
    $state = Read-Json -Path $statePath
    $pSlug = ConvertTo-Slug -Text $Project
    $existing = @($state.linkedProjects | ForEach-Object { "$_" })
    if ($existing -notcontains $pSlug) {
      $state.linkedProjects = @($existing + @($pSlug))
    }
    $state.updatedAt = (Get-Date).ToString('o')
    Write-Json -Path $statePath -Object $state
    $state
  }

  'unlink' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'unlink'." }
    if ([string]::IsNullOrWhiteSpace($Project)) { throw "Project is required for 'unlink' (use -Project)." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    $statePath = Get-StatePath -RunRoot $runRoot
    $state = Read-Json -Path $statePath
    $pSlug = ConvertTo-Slug -Text $Project
    $state.linkedProjects = @($state.linkedProjects | ForEach-Object { "$_" } | Where-Object { $_ -ne $pSlug })
    $state.updatedAt = (Get-Date).ToString('o')
    Write-Json -Path $statePath -Object $state
    $state
  }

  'summarize' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'summarize'." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    $result = Summarize-Run -RepoRoot $repoRoot -RunRoot $runRoot
    if ($Sync -and $result.linkedProjects.Count -gt 0) {
      Sync-ToBmadProjects -RepoRoot $repoRoot -RunRoot $runRoot -SummaryPackPath $result.summaryPack -LinkedProjects $result.linkedProjects
    }
    $result
  }

  'log' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'log'." }
    if ([string]::IsNullOrWhiteSpace($Item)) { throw "Item is required for 'log' (use -Item)." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    $statePath = Get-StatePath -RunRoot $runRoot
    $state = Read-Json -Path $statePath
    Append-Change -RunRoot $runRoot -State $state -Message $Item
    $state.updatedAt = (Get-Date).ToString('o')
    Write-Json -Path $statePath -Object $state
    [ordered]@{ runRoot = $runRoot; changesFile = (Get-ChangesPath -RunRoot $runRoot) }
  }

  'delta' {
    if ([string]::IsNullOrWhiteSpace($Name)) { throw "Name (slug or display name) is required for 'delta'." }
    $slug = ConvertTo-Slug -Text $Name
    $runRoot = Ensure-Run -RepoRoot $repoRoot -Slug $slug -DisplayName $Name -AllowExisting
    $result = Delta-Summary -RepoRoot $repoRoot -RunRoot $runRoot
    if ($Sync -and $result.linkedProjects.Count -gt 0) {
      # Sync the delta summary as the payload (not the full pack).
      Sync-ToBmadProjects -RepoRoot $repoRoot -RunRoot $runRoot -SummaryPackPath $result.deltaSummary -LinkedProjects $result.linkedProjects
    }
    $result
  }
}

