
function New-RoomList() {
    <#
    .SYNOPSIS
    Creates a room list with room resource mailboxes in Exchange Online 
    
    .DESCRIPTION
    Generates a list of room mailboxes for the specified city or cities. If no Bing Maps API key is used, rooms will have minimal metadata added
        
    .EXAMPLE
    New-RoomList -City "Dallas"

    .EXAMPLE
    New-LabRoomList -City "Dallas" -IncludeWorkspaces $true

    .EXAMPLE
    New-RoomList -City "Dallas","Sacramento","Washington D.C." -BingMapsKey $ApiKey -BuildingsPerCity 3 -RoomsPerBuilding 3
    
    .NOTES
    Author - Corey Schneider
    #>
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]
        #[Required] The city or cities to generate roomlist(s) for.
        $City,
        [Parameter(Mandatory=$false)]
        [string]
        #An API key for Bing Maps API
        #
        #https://docs.microsoft.com/en-us/bingmaps/getting-started/bing-maps-dev-center-help/getting-a-bing-maps-key
        $bingmapskey,
        [Parameter(Mandatory=$false)]
        [int]
        #The number of buildings or room lists per specified city, default is 2
        $BuildingsPerCity = 2,
        [Parameter(Mandatory=$false)]
        [int]
        #The number of rooms per room list, default is 3
        $RoomsPerBuilding = 3,
        [Parameter(Mandatory=$false)]
        [boolean]
        #If $true, will effectively double the "RoomsPerBuilding" count by additionally creating workspace mailboxes
        $includeWorkspaces = $false
    )
        If ($bingmapskey) {
            Write-Host "BingMapKey detected, finding city locations from Bing Maps" -ForegroundColor Yellow
            New-BingRoomList -City $City -bingmapskey $bingmapskey -BuildingsPerCity $BuildingsPerCity -RoomsPerBuilding $RoomsPerBuilding -includeWorkspaces $includeWorkspaces
        }
        else { 
            
            Write-Host "No Bing Map API Key Detected, generating simplified room list(s)" -ForegroundColor Yellow
            New-SimpleRoomList -City $city -BuildingsPerCity $BuildingsPerCity -RoomsPerBuilding $RoomsPerBuilding -includeWorkspaces $includeWorkspaces
        }
}