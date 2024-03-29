# This script acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI environments.

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
    . "$PSScriptRoot\..\Private\Get-ProjectVariables.ps1"

    "Test the module manifest" | Write-Host
    & "$PSScriptRoot\..\Private\Test-ModuleManifest.ps1" -Path $ModuleManifestPath

    "Test the module via the generated module manifest" | Write-Host
    & "$PSScriptRoot\..\Private\Test-Module.ps1" -Path $ModuleManifestPath

}catch {
    throw
}
