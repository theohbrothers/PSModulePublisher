##############################################################################################################################################
# This script is designed for development environments for executing the same build, test, and publish steps that run on CI/CD environments. #
# You can use the provided switches to test the publishing process in your development environment.                                          #
##############################################################################################################################################

$private:myArgs = @{
    # PublishRepository = 'PSRepository'
    # DryRun = $true
}
$VerbosePreference = 'Continue'

################################################

function Run-PSModulePublisher {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$PublishRepository
        ,
        [Parameter(Mandatory=$false)]
        [switch]$DryRun
    )

    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    try {
        Push-Location $PSScriptRoot

        # Run the build entrypoint script
        $manifestPath = & "$PSScriptRoot\build.ps1"

        # Run the test entrypoint script
        & "$PSScriptRoot\test.ps1" -ModuleManifestPath $manifestPath

        # Run the publish entrypoint script
        & "$PSScriptRoot\publish.ps1" -ModuleManifestPath $manifestPath -PublishRepository $PSBoundParameters['PublishRepository'] -DryRun:$PSBoundParameters['DryRun']

    }catch {
        throw
    }finally {
        Pop-Location
    }
}

Run-PSModulePublisher @myArgs
