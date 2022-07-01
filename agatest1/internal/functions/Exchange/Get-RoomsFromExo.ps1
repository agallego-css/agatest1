<#
.SYNOPSIS Gets the room and equipment resource mailboxes
#>
function Get-RoomsFromExo() {
    return (get-mailbox -recipienttypedetails roommailbox,equipmentmailbox | Select-object *)
}