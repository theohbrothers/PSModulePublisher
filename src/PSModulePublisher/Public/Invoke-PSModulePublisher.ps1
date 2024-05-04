function Invoke-PSModulePublisher {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false,HelpMessage="Path to the repository")]
        [ValidateNotNullOrEmpty()]
        [string]$Repository
        ,
        [Parameter(Mandatory=$false,HelpMessage="Whether to do a dry run")]
        [switch]$DryRun
    )

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'
    $VerbosePreference = 'Continue'
    $ErrorView = 'NormalView'
    $env:MODULE_VERSION = '0.0.0'

    try {
        # Run the build entrypoint script
        $manifestPath = Invoke-Build

        # Run the test entrypoint script
        Invoke-Test -ModuleManifestPath $manifestPath

        # Run the publish entrypoint script
        if ($Repository) {
            Invoke-Publish -ModuleManifestPath $manifestPath -Repository $Repository -DryRun:$DryRun
        }else {
            "Unspecified PS Repository. The module will not be published." | Write-Warning
        }
    }catch {
        if ($ErrorActionPreference -eq 'Stop') {
            throw
        }else {
            $_ | Write-Error
        }
    }
}
