function Connect-Msol() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [pscredential] $Credential
    )
    Write-Host "Connecting to MSOnline Service as $($Credential.UserName)." -ForegroundColor Yellow
    Connect-MsolService -Credential $Credential
    Write-Host "Connected to MSOnline." -ForegroundColor Green
}