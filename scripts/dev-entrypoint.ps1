# This script is designed for development environments for executing the same build, test, and publish steps that run on CI/CD environments.
# For safety reasons, publishing of the module is designed to fail unless a repository is specified.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$PublishRepository
    ,
    [Parameter(Mandatory=$false)]
    [switch]$SkipVersionChecks
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# $VerbosePreference = 'Continue'

try {
    Push-Location $PSScriptRoot

    # Run the build entrypoint script
    $manifestPath = & "$PSScriptRoot\build.ps1"

    # Run the test entrypoint script
    & "$PSScriptRoot\test.ps1" -ModuleManifestPath $manifestPath

    # Run the publish entrypoint script
    $PublishRepository = 'PSRepository'
    & "$PSScriptRoot\publish.ps1" -ModuleManifestPath $manifestPath -PublishRepository $PublishRepository -SkipVersionChecks:$SkipVersionChecks

}catch {
    throw
}finally {
    Pop-Location
}
