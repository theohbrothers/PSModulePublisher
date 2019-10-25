[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

try {
    # Test the module manifest
    "Testing the module manifest" | Write-Host
    $manifest = Test-ModuleManifest -Path $PSBoundParameters['Path']

    # Display the manifest
    $manifest | Format-List -Property * | Out-String | Write-Verbose

}catch {
    throw
}
