Describe "PSModulePublisher" -Tag 'Integration' {
    BeforeAll {
        $ErrorView = 'NormalView'
        $mockModuleRepoDir = (Resolve-Path "$PSScriptRoot/../../test/Mock-Module").Path
        $mockModuleManifest = (Resolve-Path "$mockModuleRepoDir/src/Mock-Module/Mock-Module.psd1").Path
    }
    BeforeEach {
        Push-Location $mockModuleRepoDir
        $env:PROJECT_DIRECTORY = $mockModuleRepoDir  # Override the project base
        $env:MODULE_VERSION = $null
        $env:NUGET_API_KEY = $null
    }
    AfterEach {
        Pop-Location
    }
    It "Runs Invoke-Build" {
        $moduleManifest = Invoke-Build
        $moduleManifest | Should -Be $mockModuleManifest
    }
    It "Runs Invoke-Test" {
        Invoke-Test
    }
    It "Runs Invoke-Publish -Repository -DryRun `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        Invoke-Publish -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Publish -Repository `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        { Invoke-Publish -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-Test -ModuleManifestPath" {
        Invoke-Test -ModuleManifestPath $mockModuleManifest
    }
    It "Runs Invoke-Publish -ModuleManifestPath -Repository -DryRun `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Publish -ModuleManifestPath -Repository `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        { Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-PSModulePublisher -Repository -DryRun `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        Invoke-PSModulePublisher -Repository PSGallery -DryRun
    }
    It "Runs Invoke-PSModulePublisher -Repository `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        { Invoke-PSModulePublisher -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-Build `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        $moduleManifest = Invoke-Build
        $moduleManifest | Should -Be $mockModuleManifest
    }
    It "Runs Invoke-Publish -Repository -DryRun `$env:NUGET_API_KEY `$env:MODULE_VERSION='0.1.0'" {
        $env:NUGET_API_KEY = 'xxx'
        $env:MODULE_VERSION = '0.1.0'
        Invoke-Publish -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Publish -ModuleManifestPath -Repository -DryRun `$env:NUGET_API_KEY `$env:MODULE_VERSION='0.1.0'" {
        $env:NUGET_API_KEY = 'xxx'
        $env:MODULE_VERSION = '0.1.0'
        Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery -DryRun
    }
    It "Runs Invoke-PSModulePublisher -Repository -DryRun `$env:NUGET_API_KEY `$env:MODULE_VERSION='0.1.0'" {
        $env:NUGET_API_KEY = 'xxx'
        $env:MODULE_VERSION = '0.1.0'
        Invoke-PSModulePublisher -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Publish -Repository `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        { Invoke-Publish -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-Publish -ModuleManifestPath -Repository `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        { Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-PSModulePublisher -Repository `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        { Invoke-PSModulePublisher -Repository PSGallery } | Should -Throw
    }
}
