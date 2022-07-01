function Disconnect-Services() {
    <#
    .SYNOPSIS
    Disconnects the current service sessions
    
    .DESCRIPTION
    Disconnects from current AzureAD, Exchange Online, MSOnline, MSGraph sessions.
    
    .EXAMPLE
    Disconnect-Services
    
    .NOTES
    Re-connection to services will not require to re-enter credentials unless module is unloaded, or Powershell is closed. 
    #>
    disconnect-azuread;
    Disconnect-ExchangeOnline -Confirm:$false;
    Disconnect-Graph;
    Disconnect-MsolService;
}