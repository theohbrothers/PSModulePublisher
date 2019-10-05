# This script acts as an entrypoint for executing all relevant scripts. It is designed for use by CI environments.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleManifestPath
    ,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$PublishRepository
    ,
    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    "Publish the module" | Write-Host
    & "$PSScriptRoot\module\publish-module.ps1" -Path $ModuleManifestPath -Repository $PublishRepository -DryRun:$DryRun

}catch {
    throw
}
