#######################################################################################################################################################
# This script is designed for use in development environments for executing the same build, test, and publish steps that will run in CI environments. #
# You can use the provided switches to test the publishing process in your development environment.                                                   #
#######################################################################################################################################################

$env:MODULE_VERSION = '0.0.0'
$private:myArgs = @{
    # Repository = 'MyPSRepository'
    # DryRun = $true
}
$VerbosePreference = 'Continue'

################################################

function Invoke-PSModulePublisher {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository
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
        if ($Repository) {
            & "$PSScriptRoot\Invoke-Publish.ps1" -ModuleManifestPath $manifestPath -Repository $Repository -DryRun:$DryRun
        }else {
            "Unspecified PS Repository. The module will not be published." | Write-Warning
        }

    }catch {
        throw
    }finally {
        Pop-Location
    }
}

Invoke-PSModulePublisher @myArgs
