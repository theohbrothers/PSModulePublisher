function Get-ProjectVariables {
    [CmdletBinding()]
    param()

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    try {
        # Global constants
        $script:PROJECT = @{}
        if ($env:PROJECT_DIRECTORY) {
            $script:PROJECT['BASE_DIR'] = $env:PROJECT_DIRECTORY | Convert-Path
        }else {
            $script:PROJECT['SUPERPROJECT_BASE_DIR'] = if (git rev-parse --show-superproject-working-tree) { Convert-Path (git rev-parse --show-superproject-working-tree) }
            $script:PROJECT['BASE_DIR'] = if ($script:PROJECT['SUPERPROJECT_BASE_DIR']) { $script:PROJECT['SUPERPROJECT_BASE_DIR'] } else { Convert-Path (git rev-parse --show-toplevel) }
        }
        $script:PROJECT['BUILD_DIR'] = Join-Path $script:PROJECT['BASE_DIR'] 'build'
        $script:PROJECT['SOURCE_DIR'] = Join-Path $script:PROJECT['BASE_DIR'] 'src'
        $script:PROJECT['TEST_DIR'] = Join-Path $script:PROJECT['BASE_DIR'] 'test'
        $script:PROJECT['MODULE_MANIFEST_DEFINITION_FILE'] = if (Test-Path -Path "$($script:PROJECT['BUILD_DIR'])\definitions\modulemanifest.ps1" -PathType Leaf) {
                                                                "$($script:PROJECT['BUILD_DIR'])\definitions\modulemanifest.ps1" | Convert-Path
                                                            }else {
                                                                "$($script:PROJECT['BUILD_DIR'])\definitions\modulemanifest\definition.ps1" | Convert-Path
                                                            }
        $script:PROJECT['NAME'] = $script:PROJECT['BASE_DIR'] | Split-Path -Leaf
        $private:definition = . $script:PROJECT['MODULE_MANIFEST_DEFINITION_FILE']
        $script:PROJECT['MODULE_NAME'] = [System.IO.Path]::GetFileNameWithoutExtension($private:definition['RootModule'])
        $script:PROJECT['MODULE_MANIFEST_PATH'] = "$($script:PROJECT['SOURCE_DIR'])\$($script:PROJECT['MODULE_NAME'])\$($script:PROJECT['MODULE_NAME']).psd1"
    }catch {
        throw
    }
}
