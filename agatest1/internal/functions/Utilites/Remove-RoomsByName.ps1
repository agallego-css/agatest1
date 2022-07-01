<#
WARNING: This function is highly destructive. IT WILL delete mailboxes and distribution lists from your environment(s). 
#>
function Remove-RoomsByName() {
    <#
    .SYNOPSIS
    Removes room lists and mailboxes by specified search keyword that do not have any holds or retention policy applied to them
    
    .DESCRIPTION
    Removes the MSOLUser, MSOLGroup, Exchange Online Distribution Group, and Mailboxes that contain specified keyword that do not have any holds or retention policy applied to them

    [WARNING] This function WILL cause data loss and has potential to break mailboxes  
    
    .PARAMETER SearchString
    The name(s) of roomlists) or mailbox(es) to search for.
    
    .PARAMETER Confirm
    Switch for confirmation of destructive actions

    [WARNING] Specifying $true with this switch WILL force remove objects from your environment.
    
    Default value      true
    
    .EXAMPLE
    Remove-RoomsByName -SearchString "Los Angeles"
    
    .EXAMPLE
    Remove-RoomsByName -SearchString "Los Angeles" -Confirm:$false

    [Warning] Specifying $false for the -confirm switch WILL force delete objects in your environment that match the searchstring keyword.
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [string[]]
        #The name of a roomlist or mailbox to search for.
        $SearchString,
        [parameter(Mandatory=$false)]
        [boolean]
        #Switch for confirmation of destructive actions
        #
        #Default value      true
        $Confirm = $true
    )
    $message = "`nThis will delete mailboxes, distribution groups, and their corrisponding msol objects."
    $title    = 'Remove Rooms Confirmation'
    $question = 'Are you sure you want to proceed?'
    $choices  = '&Yes','&All','&No'
    if ($confirm) {

        $decision = $Host.UI.PromptForChoice(($title + $message), $question, $choices, 2)
        
        if($decision -eq 0) {
            foreach($item in $SearchString) {
                remove-room -searchString "$item" -Confirm:$Confirm
            }
        } 
        elseif ($decision -eq 1) {
            remove-room -searchString $SearchString -Confirm:$false
        }
        else {

            Write-Host 'cancelled room removal' -ForegroundColor Yellow
        }
    }
    else {
        remove-room -searchString $SearchString -Confirm:$confirm
    }
    

    
   
}