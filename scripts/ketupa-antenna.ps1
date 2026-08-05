[CmdletBinding()]
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$binary = Join-Path $root 'bin\windows\ketupa-antenna.exe'
if (-not (Test-Path -LiteralPath $binary)) {
    throw "Ketupa Antenna Designer binary is missing: $binary"
}
& $binary @Arguments
exit $LASTEXITCODE

