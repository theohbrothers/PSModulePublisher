# - Initial setup: Fill in the GUID value. Generate one by running the command 'New-GUID'. Then fill in all relevant details.
# - Ensure all relevant details are updated prior to publishing each version of the module.
# - To simulate generation of the manifest based on this definition, run the included development entrypoint script Invoke-PSModulePublisher.ps1.
# - To publish the module, tag the associated commit and push the tag.
@{
    RootModule = 'Mock-Module.psm1'
    # ModuleVersion = ''                            # Value will be set for each publication based on the tag ref. Defaults to '0.0.0' in development environments and regular CI builds
    GUID = 'e3df9fcc-9f83-4c93-9d06-4d2523376af7'
    Author = 'The Oh Brothers'
    CompanyName = 'The Oh Brothers'
    Copyright = '(c) 2023 The Oh Brothers'
    Description = 'Some description'
    PowerShellVersion = '3.0'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    # RequiredModules = @(
    #     @{
    #         ModuleName = "PSMockModule"
    #         RequiredVersion = '0.0.2'
    #     }
    # )
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport = @(
        Get-ChildItem $PSScriptRoot/../../src/Mock-Module/Public -Exclude *.Tests.ps1 | % { $_.BaseName }
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @(
    #     & {
    #         Set-Location $PSScriptRoot/../../../src/Generate-DockerImageVariants/
    #         Get-ChildItem  -File -Recurse -Force | Resolve-Path -Relative
    #         Set-Location -
    #     }
    # )
    PrivateData = @{
        # PSData = @{           # Properties within PSData will be correctly added to the manifest via Update-ModuleManifest without the PSData key. Leave the key commented out.
            Tags = @(
                'mock'
                'module'
            )
            LicenseUri = 'https://raw.githubusercontent.com/theohbrothers/Mock-Module/master/LICENSE'
            ProjectUri = 'https://github.com/theohbrothers/Mock-Module'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            ExternalModuleDependencies = @()
        # }
        # HelpInfoURI = ''
        # DefaultCommandPrefix = ''
    }
}
