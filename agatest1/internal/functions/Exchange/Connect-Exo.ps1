function Connect-Exo() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [pscredential] $Credential
    )
    
    Write-Host "Connecting to ExchangeOnline as $($Credential.UserName)" -ForegroundColor Yellow
    connect-exchangeonline -Credential $Credential -ShowBanner:$false -showprogress $false
    $org = Get-OrganizationConfig
    write-host "Connected to $($org.Name) Exchange Online" -ForegroundColor Green
}