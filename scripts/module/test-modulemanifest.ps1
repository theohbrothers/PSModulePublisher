[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Test the module manifest
$manifest = Test-ModuleManifest -Path $Path

# Display the manifest
$manifest | Format-List -Property * | Out-String | Write-Verbose
