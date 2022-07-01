function Get-RoomReport() {
    <#
    .SYNOPSIS
    Generates output of Room lists, assigned members, Exchange Place objects, and Graph Places objects
    
    .DESCRIPTION
    Generates detailed list of room lists and member attributes to compare, outputs to host shell and will save to csv file if switch is used
    
    .EXAMPLE
    Get-RoomReport | FT RoomList,DisplayName,City,State

    Description: Gets list of all roomlists and members, then formats output to table with specified attributes

    .EXAMPLE
    Get-RoomReport -RoomList "Boerne*","Bulverde*" | FT RoomList,DisplayName,City,State
    
    Description: Gets list of specified roomlists and members, then formats output to table with specified attributes

    .EXAMPLE
    Get-RoomReport -RoomList "Boerne*","Bulverde*" -ToCsv | FT RoomList,DisplayName,City,State

    Description: Gets list of Specified roomlists and members, outputs to csv file then formats output to table with specified attributes to host shell
    .NOTES
    Will always output data to host shell 
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string[]]        
        #[REQUIRED] The room list or lists to generate a report for$RoomList = $null,
        [Parameter(Mandatory=$false)]
        [switch]
        #Generates a report csv file for each specified room list in currecnt user's documents folder
        $ToCSVFile,
        [Parameter(Mandatory=$false)]
        [string]
        #The file path to save csv reports to.
        #
        #Default value          "C:\Users\<currentuser>\Documents\$FileName.csv"
        $FilePath = "$($env:USERPROFILE)\Documents",
        [Parameter(Mandatory=$false)]
        [string]
        #The FileName for csv report to be saved as.
        #
        #Default Value      RoomReport_All_DayOfWeek_MM-dd-yyyy_HH:mm.csv
        $FileName = "RoomReport_All_$((Get-Date -UFormat "%A_%m-%d-%Y_%R")).csv"
        )
    $report = @()
    If ($null -ne $RoomList) {
        foreach($list in $roomlist) {
            $rooms = Get-DistributionGroup *$list* | ForEach-Object{ $dl=$_; Get-DistributionGroupMember $dl.Identity -ea SilentlyContinue| ForEach-Object{get-mailbox $_.identity -ea SilentlyContinue| ForEach-Object{$mbx = $_;$recip = Get-Recipient $_.identity;$graphPlace = get-mgplace -placeid $_.PrimarySMTPAddress -ea SilentlyContinue; Get-Place $_.PrimarySMTPAddress | Select-Object *,@{N="RoomList";E={$dl.DisplayName}},@{N="DL_HFALE";E={$dl.HiddenFromAddresslistsEnabled}},@{N="MailboxType";E={$mbx.recipientTypeDetails}},@{N="ResourceType";E={$mbx.ResourceType}},@{N="IsDirSynced";E={$recip.IsDirSynced}},@{N="Mbx_HFALE";E={$mbx.HiddenFromAddressListsEnabled}},@{N="HasGraphPlace";E={if ($null -eq $graphPlace) {$false} else {$true}}},@{N="GraphObj_City";E={$graphPlace.Address.City}},@{N="GraphObj_Capacity";E={$graphPlace.AdditionalProperties["capacity"]}},@{N="GraphObj_Email";E={$graphPlace.AdditionalProperties["emailAddress"]}},@{N="GraphObj_Nickname";E={$graphPlace.AdditionalProperties["nickname"]}},@{N="GraphObj_Floor";E={$graphPlace.AdditionalProperties["floorNumber"]}},@{N="GraphObj_Tags";E={$graphPlace.AdditionalProperties["tags"]}}}}}
            
            $report += $rooms
            If($ToCSVFile) {
                if($null -ne $rooms) {
                    $FileName = "Roomreport_$($list)_$((Get-Date -UFormat "%A_%m-%d-%Y_%R")).csv"
                    $rooms | Export-Csv -Path "$($FilePath)\$($FileName)" -NoClobber -NoTypeInformation
                }
            }
        }
        return $report
    }
    else {
        $rooms = Get-DistributionGroup -RecipientTypeDetails RoomList | ForEach-Object{ $dl=$_; Get-DistributionGroupMember $dl.Identity -ea SilentlyContinue| ForEach-Object{get-mailbox $_.identity -ea SilentlyContinue| ForEach-Object{$mbx = $_;$recip = Get-Recipient $_.identity;$graphPlace = get-mgplace -placeid $_.PrimarySMTPAddress -ea SilentlyContinue; Get-Place $_.PrimarySMTPAddress | Select-Object *,@{N="RoomList";E={$dl.DisplayName}},@{N="DL_HFALE";E={$dl.HiddenFromAddresslistsEnabled}},@{N="MailboxType";E={$mbx.recipientTypeDetails}},@{N="ResourceType";E={$mbx.ResourceType}},@{N="IsDirSynced";E={$recip.IsDirSynced}},@{N="Mbx_HFALE";E={$mbx.HiddenFromAddressListsEnabled}},@{N="HasGraphPlace";E={if ($null -eq $graphPlace) {$false} else {$true}}},@{N="GraphObj_City";E={$graphPlace.Address.City}},@{N="GraphObj_Capacity";E={$graphPlace.AdditionalProperties["capacity"]}},@{N="GraphObj_Email";E={$graphPlace.AdditionalProperties["emailAddress"]}},@{N="GraphObj_Nickname";E={$graphPlace.AdditionalProperties["nickname"]}},@{N="GraphObj_Floor";E={$graphPlace.AdditionalProperties["floorNumber"]}},@{N="GraphObj_Tags";E={$graphPlace.AdditionalProperties["tags"]}}}}}
        
        $report += $rooms
        If($ToCSVFile) {
            if($null -eq $report) {
                $report | Export-Csv -Path "$($FilePath)\$FileName" -NoClobber -NoTypeInformation
            }
        }
        return $report
    }
    return $report
}