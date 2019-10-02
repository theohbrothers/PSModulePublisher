# This script acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI/CD environments.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleManifestPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    # Get project variables
    . "$PSScriptRoot\module\common\get-projectvariables.ps1"

    "Test the module manifest" | Write-Host
    & "$PSScriptRoot\module\test-modulemanifest.ps1" -Path $ModuleManifestPath

    "Test the module via the generated module manifest" | Write-Host
    & "$PSScriptRoot\module\test-module.ps1" -Path $ModuleManifestPath

}catch {
    throw
}
