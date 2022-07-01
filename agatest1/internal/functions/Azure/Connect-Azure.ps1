function Connect-Azure() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [pscredential] $Credential
    )
    
    Write-Host "Connecting to AzureAD as $($Credential.UserName)" -ForegroundColor Yellow
     $azuread = Connect-AzureAD -Credential $Credential
     $global:tenantID = $azureAD.TenantID
     $global:tenantDomain = $azuread.TenantDomain
     write-host "Connected to AzureAD Tenant:($tenantID), Domain:($tenantDomain)" -ForegroundColor Green
     <#$azureAcct = Connect-AzAccount -Credential $Credential
     write-host "Connected to Tenant:($($azureAcct.TenantId)), Account:($($azureAcct.Account))"#>
     #$global:accesstoken = Get-TokenFromAzure -AccessToken MSGraph
}