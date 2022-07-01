function new-RoomResource() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$BuildingName,
        [Parameter(Mandatory=$true)]
        [int]$RoomNumber,
        [Parameter(Mandatory=$true)]
        [string]$CityName,            
        [Parameter(Mandatory=$false)]
        [string]$BuildingStreet,            
        [Parameter(Mandatory=$false)]
        [string]$BuildingState,            
        [Parameter(Mandatory=$false)]
        [string]$buildingCountry,            
        [Parameter(Mandatory=$false)]
        [string]$buildingPostalCode,
        [Parameter(Mandatory=$false)]
        [string]$BuildingGeo,
        [Parameter(Mandatory=$false)]
        [bool]$WheelChairAccessible = $false,
        [Parameter(Mandatory=$false)]
        [string]$PhoneNumber,
        [Parameter(Mandatory=$false)]
        [string[]]$RoomTags
        )
        
    $s = ""
    if ($RoomNumber.ToString().Length -eq 1) {$s = "0$RoomNumber"} else {$s = $RoomNumber}
    $mbName = ("$($BuildingName)MeetingRoom$($s)").Replace(' ','_')
    $mbDisName = "$BuildingName Meeting Room $s"
    
    #if($PhoneNumber) {$PhoneNumber = $PhoneNumber -replace '[\n]',"$($PhoneNumber.Substring($PhoneNumber.Length) +(get-random -Minimum 0 -Maximum 9))"} else {$PhoneNumber = $null}

    
    $mbx = New-Mailbox -Name $mbName -DisplayName $mbDisName -Room
    do {
        
        Write-Log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "The mailbox object is currently null, sleeping 2 seconds and retrying."
        Write-Verbose -message "The mailbox object is currently null, sleeping 2 seconds and retrying."
        Start-Sleep -Seconds 2
        $mbx = Get-Mailbox $mbName
    } while (
        $null -eq $mbx.PrimarySmtpAddress
        )
    
    write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "`n`nMailbox Generated:`n$($mbx.PrimarySmtpAddress)`n`n"
    Write-Verbose -Message "Mailbox Generated:`t$($mbx.PrimarySmtpAddress)"
   
        
        $table = new-object PSObject -Property @{
            EmailAddress = $mbx.PrimarySMTPAddress
            Building = $buildingName
            Street = $buildingStreet
            City = $buildingCity
            State = $BuildingState;
            PostalCode = $buildingPostalCode
            Country = $buildingCountry
            Phone = $PhoneNumber
            Geocoordinates = $BuildingGeo
            isWheelChairAccessible = $isWheelChairAccessible
            Tags = $RoomTags
            

        }
        write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -Message "Attempting to run 'Set-Place' for $($mbx.DisplayName).`nExample:`n$(Write-Output -InputObject $table)"
        Write-Verbose -Message "Attempting to run 'Set-Place' for $($mbx.DisplayName).`nExample:`t$table"          
        
        #Write-Host "Ignore the following 'Internal Server Error' for Set-place, all attributes of room will be written correctly" -ForegroundColor Yellow
        
        <#start-job -Name "$($mbName)_SetPlace" -InitializationScript {Import-Module ExchangeOnlineManagement,Exo.RoomsManagement -Force} -ScriptBlock {
            $data = @($input);
            Set-Place $data.EmailAddress -Building $data.Building -Street $data.Street -City $data.City -State $data.State -PostalCode $data.PostalCode -CountryOrRegion $data.Country -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $data.Phone -GeoCoordinates $data.Geocoordinates -IsWheelChairAccessible $data.isWheelChairAccessible -Tags ($data.Tags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName) -ErrorVariable setplaceerr 
            
        } -InputObject $table | Receive-Job -AutoRemoveJob -Wait#>

        #start-job -Name "$($mbName)_SetPlace" -InitializationScript {Import-Module ExchangeOnlineManagement,Exo.RoomsManagement} -ScriptBlock {
        #Set-Place $input[0].EmailAddress -Building $input[0].Building -Street $input[0].Street -City $input[0].City -State $input[0].State -PostalCode $input[0].PostalCode -CountryOrRegion $input[0].Country -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $input[0].Phone -GeoCoordinates $input["Geocoordinates"] -IsWheelChairAccessible $_["isWheelChairAccessible"] -Tags ($input[0].Tags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName) -ErrorVariable setplaceerr } -InputObject $table | Receive-Job -AutoRemoveJob -Wait

        Set-Place $mbx.PrimarySMTPAddress -Building $BuildingName -Street $buildingStreet -City $CityName -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $PhoneNumber -GeoCoordinates $BuildingGeo -IsWheelChairAccessible $isWheelChairAccessible -Tags ($RoomTags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName) -ea SilentlyContinue -ErrorVariable setplaceerr
        #start-sleep -Seconds 10

        #Set-Place $mbx.PrimarySMTPAddress -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $PhoneNumber -GeoCoordinates $BuildingGeo
                    
        #start-sleep -Seconds 10

        #Set-Place $mbx.PrimarySMTPAddress -IsWheelChairAccessible $isWheelChairAccessible -Tags ($RoomTags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName)

        $place = get-place $mbx.PrimarySMTPAddress | Select-Object DisplayName,Type,phone,Floor,Capacity,street,city,state,country*,postal*,tags,*device*

        Write-Verbose -Message  "Get-Place Object Created`t($place)"
        if($place.City) {
            write-host "Place object created succesfully:`t$place"-ForegroundColor Green
        }
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Room Resource creation was successful.`t$place"

        if($CreateGraphObject) {
            $gplace = New-PlaceOnGraph -City $place.City -CountryOrRegion $place.CountryOrRegion -PostalCode $place.PostalCode -State $place.State -Street $place.Street -PhoneNumber $place.PhoneNumber -EmailAddress $mbx.PrimarySMTPAddress -Capacity $place.Capacity -Tags $place.Tags -Latitude $place.Geocoordinate.Latitude -Longitude $place.Geocoordinate.Longitude -NickName $place.DisplayName -DisplayedName $place.DisplayName

            Write-Verbose -Message "Graph Place MeetingRoom Object Created`t($gPlace)"
        }
    
    return $mbx
}