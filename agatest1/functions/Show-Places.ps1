function Show-Places() {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param(
        # Parameters
    )
    Write-Host "`nGraph Places objects for room resources";
    Get-PlacesFromGraph | Format-Table Display*,Email*,Street,City,State,PostalCode,Country* -AutoSize;
    Write-Host "`nExchange Online objects for room resources";
    Get-RoomsFromExo | Format-Table DisplayName,Identity,Street,City,State,PostalCode,Country*,HiddenFromAddressListsEnabled -AutoSize
    Write-Host "`nExchange Get-Place Objects for room resources";
    Get-PlacesFromExo | Format-Table DisplayName,Identity,Street,City,State,PostalCode,Country*,HiddenFromAddressListsEnabled -AutoSize
    Write-Host "`nAzure User Objects for room resources";
    Get-RoomsFromAzure | Format-Table DisplayName,UserPrincipalName,Street,City,State,PostalCode,Country* -AutoSize

}