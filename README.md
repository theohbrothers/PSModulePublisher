# PSModulePublisher [![badge-version-github-tag-img][]][badge-version-github-tag-src]

[badge-version-github-tag-img]: https://img.shields.io/github/v/tag/theohbrothers/PSModulePublisher?style=flat-square
[badge-version-github-tag-src]: https://github.com/theohbrothers/PSModulePublisher/releases

A project containing the necessary tools to ease publishing of powershell modules.

## Introduction

This project provides CI templates and scripts that other projects can utilize for building, testing, and publishing powershell modules.

### Main project structure

`PSModulePublisher` requires main projects to adopt the following directory structure:

```shell
/build/                                             # Directory containing build files
/build/PSModulePublisher/                           # The root directory of PSModulePublisher as a submodule
/build/definitions/modulemanifest/definition.ps1    # The module definition file

/src/MyPowershellModule/                            # The module's root directory
/src/MyPowershellModule/MyPowershellModule.psm1     # The .psm1 module file

/test/                                              # Directory containing test files [Optional]
/test/test.ps1                                      # The test entrypoint script [Optional]
```

## Configuration

### Main project

Configure the following components on your main project.

#### Submodule

Add `PSModulePublisher` as a submodule under the directory `build` in your main project:

```shell
# Add the submodule
git submodule add 'https://github.com/theohbrothers/PSModulePublisher.git' build/PSModulePublisher

# Commit the submodule
git commit -m 'Add submodule PSModulePublisher'
```

#### Script Module file

Ensure the main project contains the script module file at the location `src/MyPowershellModule/MyPowershellModule.psm1`.

#### Module definition file

The project sources from a definition file to generate a manifest used for publishing the module. Ensure that the file exists in your main project at the location `build/definitions/modulemanifest/definition.ps1` and that it contains the right properties and values relevant to your powershell module. Remember to update the definition prior to publishing your module.

The definition template can be found [here](docs/samples/definitions/modulemanifest/definition.ps1.sample).

#### CI files

Decide on which CI provider to use in your main project based on those supported by this project. Setup the CI file(s) for your main project. Then simply reference the relevant CI files of this project from your main project's CI file(s).

Sample CI files can be found [here](docs/samples/ci).

#### Test files (Optional)

The project optionally runs an entrypoint test script at the location `test/test.ps1`. You can add the module's main tests' steps in this file for tests to be run.

### CI settings

Configure the following CI settings for your project.

#### Secrets

##### PSGallery API Key

Add a secret variable `NUGET_API_KEY` containing your [PSGallery API key](https://docs.microsoft.com/en-us/powershell/scripting/gallery/how-to/publishing-packages/publishing-a-package?view=powershell-6#powershell-gallery-account-and-api-key) to your main project's CI settings for publishing your module on [PowerShell Gallery](https://www.powershellgallery.com/).

## Usage

### Continuous Integration

The project contains the necessary steps in its CI files for generating and testing module manifests, as well as testing of modules based on generated manifests. You can configure your main project's CI file(s) to run the steps on every push. Refer to the [sample CI files](docs/samples/ci) for some working examples.

### Publishing modules

Publishing of modules occurs for tag refs. Tags must follow [Semantic Versioning](https://semver.org/) and be prepended with a lowercase `v`:

```shell
# Tag the commit to publish
git tag v1.0.12

# Push the tag
git push remotename v1.0.1
```

### Managing the submodule

#### Retrieving updates

To update the submodule:

```shell
git submodule update --remote build/PSModulePublisher
```

#### Using a specific commit / tag

To use a specific commit or tag of the submodule:

```shell
# Change to the submodule's root directory
cd build/PSModulePublisher

# To use a specific commit
git checkout 0123456789abcdef0123456789abcdef01234567
# Or, to use a specific tag
git checkout v1.0.1

# Return to the main project's root directory
cd "$(git rev-parse --show-superproject-working-tree)"
# Commit the submodule
git commit -m 'Update submodule PSModulePublisher'
```

#### Tracking a specific branch

To track a specific branch with `git submodule update`, add the `branch` key-value pair under the submodule's entry in `.gitmodules` like so:

```shell
[submodule "build/PSModulePublisher"]
	path = build/PSModulePublisher
	url = https://github.com/theohbrothers/PSModulePublisher.git
	branch = trackedbranch
```

## Best practices

- Use only tag refs of `PSModulePublisher` in your main project.
- Ensure your main project's CI file(s) is configured to use the CI templates of [`PSModulePublisher`](https://github.com/theohbrothers/PSModulePublisher) and that the commit used matches that of `PSModulePublisher` used in your main project.
