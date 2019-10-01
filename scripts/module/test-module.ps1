[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Import the module using the manifest file
$manifest = Test-ModuleManifest -Path $Path
Import-Module -Name $Path -Force

# Display the module's properties
Get-Module -Name $manifest.Name | Format-List -Property * | Out-String | Write-Verbose

# Run tests
$superProjectDirRaw = git rev-parse --show-superproject-working-tree
if ($superProjectDirRaw) {
    $projectDir = Convert-Path -Path $superProjectDirRaw
}else {
    $projectDir = Convert-Path -Path (git rev-parse --show-toplevel)
}
$testsDir = Join-Path $projectDir 'tests'

if (Test-Path -Path "$testsDir\test.ps1" -PathType Leaf) {
    "Running tests" | Write-Host
    & "$testsDir\test.ps1"
}
