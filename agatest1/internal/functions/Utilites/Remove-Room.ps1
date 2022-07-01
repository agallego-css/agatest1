
      
    function remove-room() {        
        [CmdletBinding()]
        param(
            [parameter(Mandatory=$true)]
            [string[]]$searchString,
            [parameter(Mandatory=$false)]
            [boolean]$Confirm = $true
        )
        foreach ($item in $searchString) {
            Write-Host "Removing MSOL Users matching ($item)."
            Get-MsolUser -SearchString "$item" | Remove-MsolUser -Force
            Write-Host "Removing MSOL Users from recycle bin matching ($searchstring)."
            Get-MsolUser -SearchString "$item" -ReturnDeletedUsers | Remove-MsolUser -Force -RemoveFromRecycleBin
            Write-Host "Removing MSOL groups matching ($item)."
            Get-MsolGroup -SearchString "$item" | Remove-MsolGroup -Force    
            Write-Host "Removing Exchange Distribution Groups matching ($item)."
            Get-DistributionGroup "*$item*" | Remove-DistributionGroup -Confirm:$Confirm
            Write-Host "Removing Exchange Mailboxes matching ($item)."
            Get-Mailbox "*$item*" -ea SilentlyContinue |remove-mailbox -Force -PermanentlyDelete -ea SilentlyContinue -Confirm:$Confirm
            Write-Host "Removing Exchange Maiboxes that are softdeleted matching ($item)."
            Get-Mailbox *$item* -SoftDeletedMailbox -ea SilentlyContinue | remove-mailbox -Force -PermanentlyDelete -ea SilentlyContinue -Confirm:$Confirm
        }
    }