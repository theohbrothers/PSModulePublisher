# This script acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI/CD environments.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleManifestPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Script constants
. "$PSScriptRoot\module\common\get-projectvariables.ps1"

try {
    "Test the module manifest" | Write-Host
    & "$PSScriptRoot\module\test-modulemanifest.ps1" -Path $ModuleManifestPath | Out-Host

    "Test the module" | Write-Host
    & "$PSScriptRoot\module\test-module.ps1" -Path $ModuleManifestPath | Out-Host

}catch {
    throw
}
