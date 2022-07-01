<#
.SYNOPSIS Gets the room mailboxes
#>
function Get-PlacesFromExo() {
    return (Get-RoomsFromExo | ForEach-Object {$hidden = $_.HiddenFromAddressListsEnabled; Get-Place $_.PrimarySMTPAddress | Select-object *,@{N="HiddenFromAddressListsEnabled";E={$hidden}}})
}