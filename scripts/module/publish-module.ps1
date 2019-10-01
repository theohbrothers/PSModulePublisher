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

try {
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

    "Module manifest directory: $modulesDir" | Write-Verbose
    "Module version: $env:MODULE_VERSION" | Write-Verbose

    # Publish the module
    "Publishing module" | Write-Host
    $publishModuleArgs = @{
        Path = $modulesDir
        Repository = $Repository
    }
    if ($env:NUGET_API_KEY) {
        $publishModuleArgs['NuGetApiKey'] = $env:NUGET_API_KEY
    }
    Publish-Module @publishModuleArgs

}catch {
    throw
}