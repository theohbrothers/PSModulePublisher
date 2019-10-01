[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
    ,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Repository
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

"Path: $Path" | Write-Verbose
Get-Item -Path $Path > $null

if (Test-Path -Path $Path -PathType Leaf) {
    $modulesDir = Split-Path -Path $Path -Parent
    "Module directory determined to be '$modulesDir'" | Write-Verbose
}
if (!$env:MODULE_VERSION) {
    "Module version is null. Not publishing module." | Write-Warning
    return
}

"Module manifest path: $modulesDir" | Write-Verbose
"Version: $env:MODULE_VERSION" | Write-Verbose

# Publish the module
"Publishing module" | Write-Host
Publish-Module -Path $modulesDir -Repository $Repository -NuGetApiKey $env:NUGET_API_KEY
