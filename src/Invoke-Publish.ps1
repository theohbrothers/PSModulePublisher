# This script acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI environments.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleManifestPath
    ,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Repository
    ,
    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    "Publish the module" | Write-Host
    & "$PSScriptRoot\module\Publish-Module.ps1" -Path $ModuleManifestPath -Repository $Repository -DryRun:$DryRun

}catch {
    throw
}
