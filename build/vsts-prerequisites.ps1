param (
    [string]
    $Repository = 'PSGallery'
)

$modules = @("Pester", "PSFramework", "PSModuleDevelopment", "PSScriptAnalyzer", "AzureAD", "ExchangeOnlineManagement", "Microsoft.Graph.Calendar", "MSOnline")

# Automatically add missing dependencies
$data = Import-PowerShellDataFile -Path "$PSScriptRoot\..\agatest1\agatest1.psd1"
foreach ($dependency in $data.RequiredModules) {
    if ($dependency -is [string]) {
        if ($modules -contains $dependency) { continue }
        $modules += $dependency
    }
    else {
        if ($modules -contains $dependency.ModuleName) { continue }
        $modules += $dependency.ModuleName
    }
}

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -Repository $Repository
    Import-Module $module -Force -PassThru
}