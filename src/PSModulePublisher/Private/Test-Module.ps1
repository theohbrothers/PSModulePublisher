function Test-Module {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    try {
        # Import the module via the module manifest file
        "Importing the module via the module manifest file" | Write-Host
        $manifest = Test-ModuleManifest -Path $Path
        Import-Module -Name $Path -Force

        # Display the imported module's properties
        "Displaying the imported module's properties" | Write-Host
        Get-Module -Name $manifest.Name | Format-List -Property * | Out-String | Write-Verbose

        # Run tests
        if (Test-Path -Path "$($script:PROJECT['TEST_DIR'])\test.ps1" -PathType Leaf) {
            Set-StrictMode -Off
            "Running tests" | Write-Host
            & "$($script:PROJECT['TEST_DIR'])\test.ps1"
            Set-StrictMode -Version Latest
        }
    }catch {
        throw
    }
}
