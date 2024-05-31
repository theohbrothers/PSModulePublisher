#########################################################################################################################################################
# This function is designed for use in development environments for executing the same build, test, and publish steps that will run in CI environments. #
# You can use the provided switches to test the publishing process in your development environment.                                                     #
#########################################################################################################################################################

function Invoke-PSModulePublisher {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false,HelpMessage="Name of the PowerShell repository")]
        [ValidateNotNullOrEmpty()]
        [string]$Repository
        ,
        [Parameter(Mandatory=$false,HelpMessage="Perform a dry run when publishing the module")]
        [switch]$DryRun
    )

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

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
        throw
    }
}
