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
    $global:PROJECT['MODULES_DIR'] = Join-Path $global:PROJECT['BASE_DIR'] 'Modules'
    $global:PROJECT['TESTS_DIR'] = Join-Path $global:PROJECT['BASE_DIR'] 'tests'
    $global:PROJECT['MODULE_MANIFEST_DEFINITION_PATH'] = "$($global:PROJECT['BUILD_DIR'])\definitions\modulemanifest\definition.ps1"
    $global:PROJECT['NAME'] = Split-Path $global:PROJECT['BASE_DIR'] -Leaf
    $global:PROJECT['MODULE_MANIFEST_PATH'] = "$($global:PROJECT['MODULES_DIR'])\$($global:PROJECT['NAME'])\$($global:PROJECT['NAME']).psd1"

}catch {
    throw
}