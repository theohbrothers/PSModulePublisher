function Get-ProjectVariables {
    [CmdletBinding()]
    param()

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    try {
        # Global constants
        $script:PROJECT = @{}
        if ($env:PROJECT_BASE_DIR) {
            $script:PROJECT['BASE_DIR'] = Convert-Path -Path $env:PROJECT_BASE_DIR
        }else {
            $script:PROJECT['SUPERPROJECT_BASE_DIR'] = if (git rev-parse --show-superproject-working-tree) { Convert-Path -Path (git rev-parse --show-superproject-working-tree) }
            $script:PROJECT['BASE_DIR'] = if ($script:PROJECT['SUPERPROJECT_BASE_DIR']) { $script:PROJECT['SUPERPROJECT_BASE_DIR'] } else { Convert-Path -Path (git rev-parse --show-toplevel) }
        }
        $script:PROJECT['BUILD_DIR'] = Join-Path $script:PROJECT['BASE_DIR'] 'build'
        $script:PROJECT['SOURCE_DIR'] = Join-Path $script:PROJECT['BASE_DIR'] 'src'
        $script:PROJECT['TEST_DIR'] = Join-Path $script:PROJECT['BASE_DIR'] 'test'
        $script:PROJECT['MODULE_MANIFEST_DEFINITION_FILE'] = if (Test-Path -Path "$($script:PROJECT['BUILD_DIR'])\definitions\modulemanifest.ps1" -PathType Leaf) {
                                                                "$($script:PROJECT['BUILD_DIR'])\definitions\modulemanifest.ps1"
                                                            }else {
                                                                "$($script:PROJECT['BUILD_DIR'])\definitions\modulemanifest\definition.ps1"
                                                            }
        $script:PROJECT['NAME'] = Split-Path $script:PROJECT['BASE_DIR'] -Leaf
        $private:definition = . $script:PROJECT['MODULE_MANIFEST_DEFINITION_FILE']
        $script:PROJECT['MODULE_NAME'] = [System.IO.Path]::GetFileNameWithoutExtension($private:definition['RootModule'])
        $script:PROJECT['MODULE_MANIFEST_PATH'] = "$($script:PROJECT['SOURCE_DIR'])\$($script:PROJECT['MODULE_NAME'])\$($script:PROJECT['MODULE_NAME']).psd1"
    }catch {
        throw
    }
}
