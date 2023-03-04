[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    # Global constants
    $global:PROJECT = @{}
    $global:PROJECT['SUPERPROJECT_BASE_DIR'] = if (git rev-parse --show-superproject-working-tree) { Convert-Path -Path (git rev-parse --show-superproject-working-tree) }
    $global:PROJECT['BASE_DIR'] = if ($global:PROJECT['SUPERPROJECT_BASE_DIR']) { $global:PROJECT['SUPERPROJECT_BASE_DIR'] } else { Convert-Path -Path (git rev-parse --show-toplevel) }
    $global:PROJECT['BUILD_DIR'] = Join-Path $global:PROJECT['BASE_DIR'] 'build'
    $global:PROJECT['SOURCE_DIR'] = Join-Path $global:PROJECT['BASE_DIR'] 'src'
    $global:PROJECT['TEST_DIR'] = Join-Path $global:PROJECT['BASE_DIR'] 'test'
    $global:PROJECT['MODULE_MANIFEST_DEFINITION_FILE'] = if (Test-Path -Path "$($global:PROJECT['BUILD_DIR'])\definitions\modulemanifest.ps1" -PathType Leaf) {
                                                             "$($global:PROJECT['BUILD_DIR'])\definitions\modulemanifest.ps1"
                                                         }else {
                                                             "$($global:PROJECT['BUILD_DIR'])\definitions\modulemanifest\definition.ps1"
                                                         }
    $global:PROJECT['NAME'] = Split-Path $global:PROJECT['BASE_DIR'] -Leaf
    $private:definition = . $global:PROJECT['MODULE_MANIFEST_DEFINITION_FILE']
    $global:PROJECT['MODULE_NAME'] = [System.IO.Path]::GetFileNameWithoutExtension($private:definition['RootModule'])
    $global:PROJECT['MODULE_MANIFEST_PATH'] = "$($global:PROJECT['SOURCE_DIR'])\$($global:PROJECT['MODULE_NAME'])\$($global:PROJECT['MODULE_NAME']).psd1"

}catch {
    throw
}
