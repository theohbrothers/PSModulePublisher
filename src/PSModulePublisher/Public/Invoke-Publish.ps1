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
Alpine: apk add icu-data-full --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main && apk add lttng-ust --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main && apk add dotnet6-runtime --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/community
Ubuntu: sudo apt-get update && sudo apt-get install -y dotnet-runtime-6.0
Windows: https://aka.ms/dotnet-install-script. See script usage: https://github.com/dotnet/docs/blob/main/docs/core/tools/dotnet-install-script.md
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
