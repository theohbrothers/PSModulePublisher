#######################################################################################################################################################
# This script is designed for use in development environments for executing the same build, test, and publish steps that will run in CI environments. #
# You can use the provided switches to test the publishing process in your development environment.                                                   #
#######################################################################################################################################################

$private:myArgs = @{
    # PublishRepository = 'MyPSRepository'
    # DryRun = $true
}
$VerbosePreference = 'Continue'

################################################

function Invoke-PSModulePublisher {
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
        $manifestPath = & "$PSScriptRoot\Invoke-Build.ps1"

        # Run the test entrypoint script
        & "$PSScriptRoot\Invoke-Test.ps1" -ModuleManifestPath $manifestPath

        # Run the publish entrypoint script
        & "$PSScriptRoot\Invoke-Publish.ps1" -ModuleManifestPath $manifestPath -PublishRepository $PSBoundParameters['PublishRepository'] -DryRun:$PSBoundParameters['DryRun']

    }catch {
        throw
    }finally {
        Pop-Location
    }
}

Invoke-PSModulePublisher @myArgs
