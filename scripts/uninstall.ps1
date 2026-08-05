[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [ValidateSet('CodexUser', 'CodexProject', 'ClaudeUser', 'ClaudeProject', 'AllUser')]
    [string]$Target = 'CodexUser',
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'
$skillName = 'ketupa-antenna-designer'

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
    if (-not (Test-Path -LiteralPath $destination)) {
        Write-Host "Not installed: $destination"
        continue
    }
    if ($PSCmdlet.ShouldProcess($destination, 'Remove Ketupa Antenna Designer Skill')) {
        Remove-Item -LiteralPath $destination -Recurse -Force
        Write-Host "Removed: $destination"
    }
}

