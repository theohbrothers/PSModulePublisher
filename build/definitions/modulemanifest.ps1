# - Initial setup: Fill in the GUID value. Generate one by running the command 'New-GUID'. Then fill in all relevant details.
# - Ensure all relevant details are updated prior to publishing each version of the module.
# - To simulate generation of the manifest based on this definition, run the included development entrypoint script Invoke-PSModulePublisher.ps1.
# - To publish the module, tag the associated commit and push the tag.

@{
    RootModule = 'PSModulePublisher.psm1'
    # ModuleVersion = ''                            # Value will be set for each publication based on the tag ref. Defaults to '0.0.0' in development environments and regular CI builds
    GUID = '08b321cc-7daa-44e7-bf41-9eb1ddedfc3a'
    Author = 'The Oh Brothers'
    CompanyName = 'The Oh Brothers'
    Copyright = '(c) 2024 The Oh Brothers'
    Description = 'A project containing the necessary tools to ease publishing of PowerShell modules.'
    PowerShellVersion = '3.0'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport = @(
        'Invoke-Build'
        'Invoke-PSModulePublisher'
        'Invoke-Publish'
        'Invoke-Test'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData = @{
        # PSData = @{           # Properties within PSData will be correctly added to the manifest via Update-ModuleManifest without the PSData key. Leave the key commented out.
            Tags = @(
                'pwsh'
                'powershell'
                'modules'
                'powershell-modules'
                'script-module'
                'module-manifest'
                'module-testing'
                'module-testing-framework'
                'module-publishing'
                'module-publishing-framework'
                'powershell-project-convention'
                'powershell-modules-convention'
                'ci'
                'continuous-integration'
                'build-test-publish'
                'new-modulemanifest'
                'update-modulemanifest'
                'test-modulemanifest'
                'publish-module'
            )
            LicenseUri = 'https://raw.githubusercontent.com/theohbrothers/PSModulePublisher/master/LICENSE'
            ProjectUri = 'https://github.com/theohbrothers/PSModulePublisher'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            # ExternalModuleDependencies = @()
        # }
        # HelpInfoURI = ''
        # DefaultCommandPrefix = ''
    }
}
