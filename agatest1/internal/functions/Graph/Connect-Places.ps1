function Connect-Places() {
    
    write-host "Connecting to Graph API, please approve permissions if prompted." -ForegroundColor Yellow
    $graph = Connect-Graph -Scopes "Place.ReadWrite.All","User.Read.All"
    #Select-MgProfile -Name "v1.0"
    write-host $graph -ForegroundColor Green
    

}
<#
Install-Module Microsoft.Graph

#Gets all "Turku" rooms, mailbox properties and place object properties
get-mailbox *turku* -RecipientTypeDetails RoomMailbox | %{$mbx = $_;$recip = Get-Recipient $_.identity; Get-Place $_.PrimarySMTPAddress | Select Identity,@{N="MailboxType";E={$mbx.recipientTypeDetails}},@{N="ResourceType";E={$mbx.ResourceType}},IsManaged,BookingType,Floor,City,State,@{N="IsDirSynced";E={$recip.IsDirSynced}},@{N="HiddenFromAddresListEnabled";E={$mbx.HiddenFromAddressListsEnabled}},Tags} | Export-Csv -Path "<Replace with filepath>\Turku_Rooms_Get-Place.csv" -NoTypeInformation -NoClobber

get-mailbox *thane* -RecipientTypeDetails RoomMailbox | %{$mbx = $_;$recip = Get-Recipient $_.identity; Get-Place $_.PrimarySMTPAddress | Select Identity,@{N="MailboxType";E={$mbx.recipientTypeDetails}},@{N="ResourceType";E={$mbx.ResourceType}},IsManaged,BookingType,Floor,City,State,@{N="IsDirSynced";E={$recip.IsDirSynced}},@{N="HiddenFromAddresListEnabled";E={$mbx.HiddenFromAddressListsEnabled}},Tags} | Export-Csv -Path "<Replace with filepath>\Thane_Rooms_Get-Place.csv" -NoTypeInformation -NoClobber
#>