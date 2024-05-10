function Publish-MyModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository
        ,
        [Parameter(Mandatory=$false)]
        [switch]$DryRun
    )

    try {
        "Path: $($Path)" | Write-Verbose

        # Test the path of the specified module manifest path
        Get-Item -Path $Path -ErrorAction Stop > $null

        # Determine the module manifest directory for Publish-Module -Path which only accepts the directory containing the .psd1 file
        if (Test-Path -Path $Path -PathType Leaf) {
            $modulesDir = Split-Path -Path $Path -Parent
            "Module directory determined to be '$modulesDir'" | Write-Verbose
        }

        # Get the specified module manifest
        $manifest = Test-ModuleManifest -Path $Path
        "Module version: $($manifest.Version.ToString())" | Write-Verbose

        # Verify the module version prior to publishing unless skipped
        if (!$DryRun) {
            "Checking module version" | Write-Host
            # Fail if the dummy version '0.0.0' is found (for development or regular CI build environments)
            if ($manifest.Version.ToString() -eq '0.0.0') {
                throw "Module version is found to have the dummy value of '$($manifest.Version.ToString())'. Not publishing module."
            }
            # Fail if the environment variable is not set (for CI release environments)
            if (!$env:MODULE_VERSION) {
                throw "The environment variable '`$env:MODULE_VERSION' is null. Not publishing module."
            }
        }else {
            "Skipping checks for module version" | Write-Warning
        }

        # Publish the module
        "Publishing the module" | Write-Host
        $publishModuleArgs = @{
            Path = $modulesDir
            Repository = $Repository
        }
        if ($env:NUGET_API_KEY) {
            $publishModuleArgs['NuGetApiKey'] = $env:NUGET_API_KEY
        }
        if ($DryRun) {
            $publishModuleArgs['WhatIf'] = $DryRun
        }
        if ($VerbosePreference -ne 'SilentlyContinue') {
            $publishModuleArgsMasked = $publishModuleArgs.Clone()
            if ($publishModuleArgs['NuGetApiKey']) { $publishModuleArgsMasked['NuGetApiKey'] = "token *******" }
            $publishModuleArgsMasked | Out-String -Stream | % { $_.Trim() } | ? { $_ } | Write-Verbose
        }
        $env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'  # See: https://github.com/dotnet/docs/blob/main/docs/core/tools/telemetry.md
        Publish-Module @publishModuleArgs
    }catch {
        throw
    }
}
