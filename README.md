# PSModulePublisher

[![github-workflows](https://img.shields.io/github/actions/workflow/status/theohbrothers/PSModulePublisher/ci-master-pr.yml?label=ci-master-pr&logo=github&style=flat-square)](https://github.com/theohbrothers/PSModulePublisher/actions/workflows/ci-master-pr.yml)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/PSModulePublisher?style=flat-square)](https://github.com/theohbrothers/PSModulePublisher/releases)
[![powershellgallery-version](https://img.shields.io/powershellgallery/v/PSModulePublisher?logo=powershell&logoColor=white&label=PSGallery&style=flat-square)](https://www.powershellgallery.com/packages/PSModulePublisher)

A project containing the necessary tools to ease publishing of PowerShell modules.

## Introduction

This project provides PowerShell cmdlets and CI remote templates that other projects can utilize for building, testing, and publishing PowerShell modules.

## Installation

`PSModulePublisher` can either be installed as a [PowerShell module](#powershell-module), or used as a [submodule](#submodule) for building, testing, and publishing PowerShell modules.

### PowerShell module

To use `PSModulePublisher` as a PowerShell module, simply perform an installation of the module in development or CI environment(s) prior to executing provided [cmdlets](#usage) to perform their respective functions.

```powershell
# Latest version
Install-Module -Name PSModulePublisher -Repository PSGallery -Scope CurrentUser -Verbose

# Specific version
Install-Module -Name PSModulePublisher -Repository PSGallery -RequiredVersion x.x.x -Scope CurrentUser -Verbose
```

If prompted to trust the repository, type `Y` and `enter`.
v
### Submodule

`PSModulePublisher` can be used as submodule together with provided [CI remote template(s)](#ci-remote-templates).

#### Main project structure

To use `PSModulePublisher` as a submodule, main projects are to adopt the following directory structure:

```shell
/build/                                             # Directory containing build files
/build/PSModulePublisher/                           # The root directory of PSModulePublisher as a submodule
/build/definitions/modulemanifest.ps1               # The module manifest definition file

/src/MyPowershellModule/                            # The module's root directory
/src/MyPowershellModule/MyPowershellModule.psm1     # The module .psm1 file
/src/MyPowershellModule/MyPowershellModule.psd1     # The module .psd1 file (optional)

/test/                                              # Directory containing test files (optional)
/test/test.ps1                                      # The test entrypoint script (optional)
```

#### Adding the submodule

Add `PSModulePublisher` as a submodule under the directory `build` in your main project:

```shell
# Add the submodule
git submodule add https://github.com/theohbrothers/PSModulePublisher.git build/PSModulePublisher

# Checkout ref to use
git --git-dir build/PSModulePublisher/.git checkout vx.x.x

# Commit the submodule
git commit -am 'Add submodule PSModulePublisher vx.x.x'
```

## Configuration

### Script module file

Ensure the main project contains the script module file at the location `src/MyPowershellModule/MyPowershellModule.psm1`.

### Module manifest definition file

The project sources from a definition file to generate the module manifest file (`.psd1`) used for publishing the module. Ensure that the file exists in your main project at the location `build/definitions/modulemanifest.ps1` and that it contains the right properties and values relevant to your PowerShell module. Remember to update the definition file prior to publishing your module.

The definition template can be found [here](docs/samples/build/definitions/modulemanifest.ps1).

### CI remote templates

**Note:** This section only applies if using the project as a [submodule](#submodule).

Decide on which CI provider to use in your main project based on those supported by this project. Then setup the CI file(s) for your main project, referencing relevant [CI remote template(s)](templates) of this project from your main project's CI file(s).

Sample CI files can be found [here](docs/samples/ci).

### Test files (Optional)

The project optionally runs an entrypoint script for tests at the location `test/test.ps1`. You can add the module's main tests steps in this file for tests to be run.

Sample test files can be found [here](docs/samples/test).

### CI settings

#### Secrets

##### PSGallery API Key

Add a secret variable `NUGET_API_KEY` containing your [PSGallery API key](https://learn.microsoft.com/en-us/powershell/gallery/how-to/publishing-packages/publishing-a-package#powershell-gallery-account-and-api-key) to your main project's CI settings for publishing your module on [PowerShell Gallery](https://www.powershellgallery.com/).

#### Environment variables

##### Project directory

By default, `PSModulePublisher` uses the main project's root directory as the path for execution. To override the default location, set the *environment* variable `PROJECT_DIRECTORY` to contain a custom directory value before executing `PSModulePublisher`.

##### Module version

The default module version is `0.0.0` which prevents a module from being published. To publish a module, simply create a tag for a desired commit and push the tag. Tags must follow [Semantic Versioning](https://semver.org/) and be prepended with a lowercase `v`:

```shell
# Tag the commit to publish
git tag v1.0.12

# Push the tag
git push remotename v1.0.12     # MODULE_VERSION will be 1.0.12
```

The environment variable `MODULE_VERSION` will automatically be populated with the equivalent PowerShell module version based on the semver tag pushed.

## Usage

### Development

The PowerShell cmdlet [`Invoke-PSModulePublisher`](src/PSModulePublisher/Public/Invoke-PSModulePublisher.ps1) is used for executing the project's build, test, and publish steps for PowerShell modules.

#### Parameters

```powershell
Invoke-PSModulePublisher [[-Repository] <string>] [-DryRun] [<CommonParameters>]
```

#### Commands

To perform the project's build, test, and publish steps for a given Powershell module, simply define applicable [environment variables](#environment-variables-1) for the project before executing the cmdlet.

```powershell
# Process applicable environment variables
$env:PROJECT_DIRECTORY="$(git rev-parse --show-toplevel)"

# Build and Test steps (Generates module manifest, Tests module via module manifest)
Invoke-PSModulePublisher

# Publish steps (Publishes module as a dry run)
Invoke-PSModulePublisher -Repository MyPSRepository -DryRun

# Publish steps (Publishes module)
Invoke-PSModulePublisher -Repository MyPSRepository
```

**Note:** Ensure the environment variable [`NUGET_API_KEY`](#psgallery-api-key) is defined prior to publishing PowerShell modules.

The [individual cmdlets](#via-cmdlets) may also be used for executing the project's build, test, and publish steps independently.

### Continuous Integration (CI)

The project provides PowerShell [cmdlets](#via-cmdlets), as well as [CI remote templates](#via-submodule-and-ci-remote-templates) for executing the project's build, test, and publish steps for PowerShell modules.

#### via Cmdlets

The following are the [parameters](#parameters) and [environment variables](#environment-variables-1) supported by the provided PowerShell cmdlets for building, testing, and publishing PowerShell modules.

##### Parameters

```powershell
Invoke-Build [<CommonParameters>]
Invoke-Test [-ModuleManifestPath] <string> [<CommonParameters>]
Invoke-Publish [-ModuleManifestPath] <string> [-Repository] <string> [-DryRun] [<CommonParameters>]
```

##### Environment variables

###### Build, Test, Publish

| Name | Example value | Mandatory | Type |
|:-:|:-:|:-:|:-:|
| [`PROJECT_DIRECTORY`](#project-directory) | `/path/to/my-project` | false | string |
| [`MODULE_VERSION`](#module-version) | `x.x.x` | false, true (Build + Publish) | string |

###### Publish

| Name | Example value | Mandatory | Type |
|:-:|:-:|:-:|:-:|
| [`NUGET_API_KEY`](#psgallery-api-key) | `xxx` | true | string |

##### Commands

To execute build, test, and publish steps for a project, simply define applicable [environment variables](#environment-variables-1) before executing the individual cmdlets within the CI environment to perform their respective functions.

```shell
# Process applicable environment variables
export PROJECT_DIRECTORY=$( git rev-parse --show-toplevel )
export MODULE_VERSION=$( echo "$GITHUB_REF" | sed -rn 's/^refs\/tags\/v(.*)/\1/p' )
export MODULE_NAME=$( basename "$( git rev-parse --show-toplevel )" )

# Install PSModulePublisher
pwsh -NoLogo -NonInteractive -NoProfile -Command 'Install-Module -Name PSModulePublisher -Repository PSGallery -Scope CurrentUser -Force -Verbose'

# Build (Generates module manifest)
pwsh -NoLogo -NonInteractive -NoProfile -Command '$VerbosePreference = "Continue"; Invoke-Build'

# Test (Tests module via module manifest)
pwsh -NoLogo -NonInteractive -NoProfile -Command '$VerbosePreference = "Continue"; Invoke-Test -ModuleManifestPath "./src/$env:MODULE_NAME/$env:MODULE_NAME.psd1"'

# Publish (Publishes module)
pwsh -NoLogo -NonInteractive -NoProfile -Command '$VerbosePreference = "Continue"; Invoke-Publish -ModuleManifestPath "./src/$env:MODULE_NAME/$env:MODULE_NAME.psd1" -Repository PSGallery'
```

**Note:** Ensure the environment variable [`NUGET_API_KEY`](#psgallery-api-key) is defined prior to publishing PowerShell modules.

Sample CI files demonstrating use of this approach can be found [here](docs/samples/ci/github).

#### via Submodule and CI remote templates

The provided [CI remote templates](templates) is composed of the following CI process:

##### Build

1. Display system info
2. Get PowerShell version
3. Process build variables
4. Generate module manifest

##### Test

1. Test module via module's manifest

##### Publish

1. Install publish dependencies *(if applicable)*
1. Publish module

**Build** and **Test** steps can be executed for every commit pushed. Simply [configure](docs/samples/ci/azure-pipelines/azure-pipelines.linux.yml#L8-L11) your main project's CI file(s) and/or settings to allow so.

**Publish** steps will run only for [*tag* refs](templates/azure-pipelines/steps/pwsh/run-publish.yml#L10). Ensure your main project's CI file(s) and/or settings are [configured](docs/samples/ci/azure-pipelines/azure-pipelines.linux.yml#L5-L7) to run CI jobs for *tag* refs.

##### Use cases

For a basic use case, the CI process could simply comprise a single stage containing all the steps from **Build**, **Test**, and **Publish**.

In cases where the module needs to be tested across multiple operating systems and/or versions of PowerShell, two stages can be configured: The 1st stage containing *multiple jobs* executing [**Build** and **Test** steps](docs/samples/ci/azure-pipelines/azure-pipelines.linux-windows.yml#L24-L40) for building and testing the module; the 2nd stage containing a *single* job executing [**Build** and **Publish** steps](docs/samples/ci/azure-pipelines/azure-pipelines.linux-windows.yml#L52) for publishing the module.

Sample CI files demonstrating use of this approach can be found [here](docs/samples/ci/azure-pipelines).

### Managing the submodule

#### Retrieving updates

To update the submodule:

```shell
git submodule update --remote build/PSModulePublisher
```

#### Using a specific tag

To use a specific tag of the submodule:

```shell
# Checkout ref to use
git --git-dir build/PSModulePublisher/.git checkout vx.x.x

# Bump PSModulePublisher to the same ref in CI file
vi azure-pipelines.yml

# Commit the submodule and CI file
git commit -am 'Bump PSModulePublisher to vx.x.x'
```

## Best practices

- Use only tag refs of `PSModulePublisher` in your main project.
- If using the project as a [Submodule with CI remote templates](#submodule), ensure your main project's CI file(s) is configured to use a [tag ref](docs/samples/ci/azure-pipelines/azure-pipelines.linux-container.yml#L19) of `PSModulePublisher` for its CI remote templates, and that the ref matches that of the `PSModulePublisher` submodule used in your main project.
