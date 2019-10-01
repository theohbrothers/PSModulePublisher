[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    # Import the module using the manifest file
    $manifest = Test-ModuleManifest -Path $Path
    Import-Module -Name $Path -Force

    # Display the module's properties
    Get-Module -Name $manifest.Name | Format-List -Property * | Out-String | Write-Verbose

    # Run tests
    if (Test-Path -Path "$($global:PROJECT['TESTS_DIR'])\test.ps1" -PathType Leaf) {
        "Running tests" | Write-Host
        & "$($global:PROJECT['TESTS_DIR'])\test.ps1"
    }

}catch {
    throw
}