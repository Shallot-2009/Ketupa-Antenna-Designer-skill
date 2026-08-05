[CmdletBinding()]
param(
    [ValidateSet('CodexUser', 'CodexProject', 'ClaudeUser', 'ClaudeProject', 'AllUser')]
    [string]$Target = 'CodexUser',
    [string]$ProjectRoot,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$skillName = 'ketupa-antenna-designer'
$skillRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path

function Get-Destinations {
    param([string]$SelectedTarget)

    switch ($SelectedTarget) {
        'CodexUser'    { return ,(Join-Path $HOME ".agents\skills\$skillName") }
        'ClaudeUser'   { return ,(Join-Path $HOME ".claude\skills\$skillName") }
        'AllUser'      {
            return @(
                (Join-Path $HOME ".agents\skills\$skillName"),
                (Join-Path $HOME ".claude\skills\$skillName")
            )
        }
        'CodexProject' {
            if (-not $ProjectRoot) { throw '-ProjectRoot is required for CodexProject.' }
            return ,(Join-Path ([IO.Path]::GetFullPath($ProjectRoot)) ".agents\skills\$skillName")
        }
        'ClaudeProject' {
            if (-not $ProjectRoot) { throw '-ProjectRoot is required for ClaudeProject.' }
            return ,(Join-Path ([IO.Path]::GetFullPath($ProjectRoot)) ".claude\skills\$skillName")
        }
    }
}

foreach ($destination in (Get-Destinations $Target)) {
    $destination = [IO.Path]::GetFullPath($destination)
    if ([string]::Equals($skillRoot, $destination, [StringComparison]::OrdinalIgnoreCase)) {
        Write-Host "Already running from the requested installation: $destination"
        continue
    }

    $parent = Split-Path -Parent $destination
    New-Item -ItemType Directory -Path $parent -Force | Out-Null

    if (Test-Path -LiteralPath $destination) {
        if (-not $Force) {
            throw "Destination already exists: $destination`nUse -Force to preserve it as a timestamped backup and install 1.0.0."
        }
        $backup = "$destination.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Move-Item -LiteralPath $destination -Destination $backup
        Write-Host "Existing installation preserved at: $backup"
    }

    Copy-Item -LiteralPath $skillRoot -Destination $destination -Recurse
    if (-not (Test-Path -LiteralPath (Join-Path $destination 'SKILL.md'))) {
        throw "Installation verification failed: SKILL.md is missing in $destination"
    }
    if ($IsWindows -or $env:OS -eq 'Windows_NT') {
        $binary = Join-Path $destination 'bin\windows\ketupa-antenna.exe'
        if (-not (Test-Path -LiteralPath $binary)) {
            throw "Installation verification failed: $binary is missing"
        }
        $reportedVersion = & $binary --version
        if ($reportedVersion -notmatch '1\.0\.0') {
            throw "Installation verification failed: unexpected version '$reportedVersion'"
        }
    }
    Write-Host "Installed Ketupa Antenna Designer 1.0.0 to: $destination"
}

Write-Host 'Open a new Codex task or Claude Code session so the Skill index is refreshed.'

