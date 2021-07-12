[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$ErrorView = 'NormalView'
$VerbosePreference = 'Continue'

$failedCount = 0

"Function: My-PublicFunction1" | Write-Host
try {
    My-PublicFunction1 -ErrorAction Stop
}catch {
    $_ | Write-Error
    $failedCount++
}

"Function: My-PublicFunction2" | Write-Host
try {
    My-PublicFunction2 -ErrorAction Stop
}catch {
    $_ | Write-Error
    $failedCount++
}

if ($failedCount -gt 0) {
    "$failedCount tests failed." | Write-Warning
}
$failedCount
