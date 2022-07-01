function Connect-Onprem() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [pscredential] $Credential,        
        [Parameter( Mandatory = $false)]
        [string]$URL = "http://exch-01.$($Credential.UserName.Split("@")[1])/PowerShell/"
    )
    $ExOPSession = $null
    try {
        $UserName = $Credential.UserName.Split("@")[1].Replace('.com', '\') + $Credential.UserName.Split("@")[0]
        [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($UserName, $Credential.Password)
        Write-Host "Connecting to Exchange On-premise server as user $($Credential.UserName) at url $URL" -ForegroundColor Yellow
        $ExOPSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $URL -Authentication Kerberos -Credential $Credential
        #$ExOPSession = New-PSSession -ConfigurationName Microsoft.Exchange -ComputerName 'exch-01.bullhornblog.com' -Authentication Kerberos -Credential $Credential
    
        Write-Host "On-premis Exchange session connected successfully!" -ForegroundColor Green
    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Host "An error occurred:" -ForegroundColor Red
        Write-Host $_ -ForegroundColor Red
    }
    finally {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        
    }

    if ($null -ne $ExOPSession) {
        return Import-PSSession $ExOPSession -DisableNameChecking
    }
}