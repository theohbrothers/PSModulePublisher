# This function acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI environments.
function Invoke-Publish {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
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
        # Get project variables
        . Get-ProjectVariables

        "Check publish dependencies" | Write-Host
        if (!(Get-Command -Name dotnet -CommandType Application -ErrorAction SilentlyContinue)) {
            @"
dotnet is required for Publish-Module, but is not installed. To install:
dotnet: https://dotnet.microsoft.com/en-us/download/dotnet
Alpine: https://learn.microsoft.com/en-us/dotnet/core/install/linux-alpine
Ubuntu: https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
Windows: https://learn.microsoft.com/en-us/dotnet/core/install/windows
"@ | Write-Warning
        }

        "Publish the module" | Write-Host
        if (!$ModuleManifestPath) {
            $ModuleManifestPath = $script:PROJECT['MODULE_MANIFEST_PATH']
            "Using default module manifest path '$ModuleManifestPath'" | Write-Host
        }else {
            "Using specified module manifest path '$ModuleManifestPath'" | Write-Host
        }
        Publish-MyModule -Path $ModuleManifestPath -Repository $Repository -DryRun:$DryRun
    }catch {
        throw
    }
}
