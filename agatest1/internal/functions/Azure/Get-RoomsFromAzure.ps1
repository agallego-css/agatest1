function Get-RoomsFromAzure() {
    return (Get-RoomsFromExo | Select-Object PrimarySMTPAddress | ForEach-Object {Get-AzureADUser -SearchString "$($_.PrimarySMTPAddress)" | Select-Object DisplayName,UserPrincipalName,PhysicalDeliveryOfficeName,StreetAddress,City,State,PostalCode,Country })
}