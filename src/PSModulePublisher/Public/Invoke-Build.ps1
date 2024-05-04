# This function acts as an entrypoint for executing all relevant scripts. It is designed for use in both development and CI environments.
function Invoke-Build {
    [CmdletBinding()]
    param()

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    try {
        # Get project variables
        Get-ProjectVariables

        "Install build dependencies" | Write-Host
        Install-BuildDependencies

        "Install required modules" | Write-Host
        $manifest = & $script:PROJECT['MODULE_MANIFEST_DEFINITION_FILE']
        foreach ($m in $manifest['RequiredModules']) {
            if ($m -is [hashtable]) {
                $m = $m.Clone()
                $m['Name'] = $m['ModuleName']
                $m.Remove('ModuleName')
            }elseif ($m -is [string]) {
                $m = @{
                    Name = $m
                }
            }
            if (!(Get-InstalledModule @m -ErrorAction SilentlyContinue)) {
                "Installing required module: $( $m['Name'] )" | Write-Host
                Install-Module @m -Force -Scope CurrentUser -ErrorAction Stop
            }
        }

        "Generate the module manifest" | Write-Host
        $script:manifest = Generate-ModuleManifest -DefinitionFile $script:PROJECT['MODULE_MANIFEST_DEFINITION_FILE'] -Path $script:PROJECT['MODULE_MANIFEST_PATH']

        # Return the manifest path
        $script:manifest.Fullname
    }catch {
        throw
    }
}
