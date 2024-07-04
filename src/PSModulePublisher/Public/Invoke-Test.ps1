# This function acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI environments.
function Invoke-Test {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$ModuleManifestPath
    )

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    try {
        # Get project variables
        . Get-ProjectVariables

        "Test the module manifest" | Write-Host
        if (!$ModuleManifestPath) {
            $ModuleManifestPath = $script:PROJECT['MODULE_MANIFEST_PATH']
            "Using default module manifest path '$ModuleManifestPath'" | Write-Host
        }else {
            "Using specified module manifest path '$ModuleManifestPath'" | Write-Host
        }
        Test-ModuleManifest -Path $ModuleManifestPath

        "Test the module via the generated module manifest" | Write-Host
        Test-Module -Path $ModuleManifestPath
    }catch {
        throw
    }
}
