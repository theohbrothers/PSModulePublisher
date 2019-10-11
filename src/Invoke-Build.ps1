# This script acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI environments.

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    # Get project variables
    . "$PSScriptRoot\module\common\Get-ProjectVariables.ps1"

    "Install build dependencies" | Write-Host
    & "$PSScriptRoot\module\Install-BuildDependencies.ps1"

    "Generate the module manifest" | Write-Host
    $script:manifest = & "$PSScriptRoot\module\Generate-ModuleManifest.ps1" -DefinitionFile $global:PROJECT['MODULE_MANIFEST_DEFINITION_FILE'] -Path $global:PROJECT['MODULE_MANIFEST_PATH']

    # Return the manifest path
    $script:manifest.Fullname

}catch {
    throw
}
