# This script acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI/CD environments.

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Script constants
. "$PSScriptRoot\module\common\get-projectvariables.ps1"

try {
    "Install Dependencies" | Write-Host
    & "$PSScriptRoot\module\install-dependencies.ps1" | Out-Host

    "Generate the module manifest" | Write-Host
    $script:manifest = & "$PSScriptRoot\module\generate-modulemanifest.ps1" -DefinitionPath $global:PROJECT['MODULE_MANIFEST_DEFINITION_PATH'] -Path $global:PROJECT['MODULE_MANIFEST_PATH']

    # Return the manifest path
    $script:manifest.Fullname

}catch {
    throw
}
