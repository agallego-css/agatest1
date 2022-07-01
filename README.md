# Exchange Room and Workspace Resource management
## A module to assist with Room Resource management in Exchange and Exchange Online

**Installation:**
- Fork repository to your local machine
- Import the module into powershell:
```powershell
Import-Module 'C:\<fork-installation-path>\Exo.RoomsManagement.psd1'
```

---
**<h4 id="requirements">Requirements:</h4>**
- [MSOnline Module for PowerShell](https://www.powershellgallery.com/packages/MSOnline/1.1.183.66)
- [ExchangeOnlineManagement Module for PowerShell](https://www.powershellgallery.com/packages/ExchangeOnlineManagement/2.0.6-Preview6)
- [BingMaps API Key](https://docs.microsoft.com/en-us/bingmaps/getting-started/bing-maps-dev-center-help/getting-a-bing-maps-key)
<br><br>
## **Usage:**

---
### Connect/Disconnect to and from Services
<br> Connects to the ExchangeOnline Shell, MSOL Shell, AzureAD Shell, and MSGraph Shell. 

Example:

```powershell
Connect-Services
```

```powershell
Disconnect-Services
```

---
### Room Reports
<br> Outputs a list of all room lists or specified roomlists, their members, place objects, and graph object in one convenient table

Example:
```powershell
Get-RoomReport -RoomList <RoomList_Name> | FT RoomList,DisplayName,Building,City,Floor,*Graph*
```
```powershell
Get-RoomReport -RoomList <RoomList_Name1>,<RoomList_Name2> | FT RoomList,DisplayName,Building,City,Floor,*Graph*
```

Example 2: Generates output to csv file - filepath defaults to current user's documents folder. 
```powershell
Get-RoomReport -FilePath <Path_to_Directory> -ToCsv 
```
```powershell
Get-RoomReport -RoomList <RoomList_Name> -FilePath <Path_to_Directory> -ToCsv 
```

---
### Create Room Lists
<br> Generates a room list, with room mailboxes for the specified city name. 

- '-BingMapsKey' parameter requires a Bing Maps API key. [(*See Requirements*)](#requirements)

Example: 
```powershell
New-LabRoomList -City "Dallas" -IncludeWorkspaces $true
```
```powershell
New-LabRoomList -City "Dallas","Sacramento","Washington D.C." -BingMapsKey <Required_API_Key> -BuildingsPerCity 3 -RoomsPerBuilding 3
```

---
### Remove Rooms and Room Lists
<br> Removes all objects (that do not have a Legal hold / retention / or eDiscovery hold) from environment. (EXO & MSOL)

Example:
```powershell
Remove-RoomsByName -SearchString "RoomName"
```
```powershell
Remove-RoomsByName -SearchString "RoomName1","Room Name 2" -Confirm:$false
```