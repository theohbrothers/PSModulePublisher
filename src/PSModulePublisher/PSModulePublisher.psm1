$script:MODULE_BASE_DIR = Split-Path $MyInvocation.MyCommand.Path -Parent
$script:MODULE_PRIVATE_DIR = Join-Path $MODULE_BASE_DIR 'Private'
$script:MODULE_PUBLIC_DIR = Join-Path $MODULE_BASE_DIR 'Public'

Get-ChildItem "$script:MODULE_PRIVATE_DIR/*.ps1" -exclude *.Tests.ps1 | % {
    . $_.FullName
}

Get-ChildItem "$script:MODULE_PUBLIC_DIR/*.ps1" -exclude *.Tests.ps1 | % {
    . $_.FullName
}
