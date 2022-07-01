function new-WorkspaceResource() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$BuildingName,
        [Parameter(Mandatory=$true)]
        [int]$WorkspaceNumber,
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
        [bool]$WhellChairAccessible = $false,
        [Parameter(Mandatory=$false)]
        [string]$PhoneNumber,
        [Parameter(Mandatory=$false)]
        [string[]]$WorkspaceTags
        )


    $s = ""
    if ($WorkspaceNumber.ToString().Length -eq 1) {$s = "0$WorkspaceNumber"} else {$s = $WorkspaceNumber}
    $wkspcName = ("$($buildingName)WorkSpace$($s)").Replace(' ','_')
    $wkspcDisName = "$buildingName WorkSpace $s"
            
    $wkspc = New-Mailbox -Name $wkspcName -DisplayName $wkspcDisName -Room 
    start-sleep -Seconds 5
    $email = $wkspc.PrimarySMTPAddress
    $wkspc = Set-Mailbox $wkspc.PrimarySMTPAddress -Type Workspace
    $wkspc = get-mailbox $email
    do {
        Write-Log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "The workspace object is currently null, sleeping 2 seconds and retrying."
        Write-Verbose -message "The workspace object is currently null, sleeping 2 seconds and retrying."
        start-sleep -Seconds 2
        $wkspc = get-mailbox $wkspcName
    } while (
        $null -eq $wkspc.PrimarySmtpAddress
    )
    write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "`n`nMailbox Generated:`n$($wkspc.PrimarySmtpAddress)`n`n"
    Write-Verbose -message "Mailbox Generated:`t$wkspc.PrimarySmtpAddress)"

        $table = new-object PSObject -Property @{
            Identity = $mbx.PrimarySMTPAddress
            RoomNumber = $WorkspaceNumber
            Building = $buildingName
            Street = $buildingStreet
            City = $buildingCity
            State = $BuildingState
            PostalCode = $buildingPostalCode
            Country = $buildingCountry
            Phone = $PhoneNumber
            Geocoordinates = $BuildingGeo
            isWheelChairAccessible = $isWheelChairAccessible
            Tags = $WorkspaceTags

        }
        write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -Message "Attempting to run 'Set-Place' for $($wkspc.DisplayName).`nExample:`n$(Write-Output -InputObject $table)"            
        Write-Verbose "Attempting to run 'Set-Place' for $($wkspc.DisplayName).`nExample:`t$table"

        #Write-Host "Ignore the following 'Internal Server Error' for Set-place, all attributes of room will be written correctly" -ForegroundColor Yellow

        <#start-job -Name "$($wkspcName)_SetPlace" -ScriptBlock {
        Set-Place $table.EmailAddress -Building $table.Building -Street $table.Street -City $table.City -State $table.State -PostalCode $table.PostalCode -CountryOrRegion $table.Country -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $table.Phone -GeoCoordinates $table.Geocoordinates -IsWheelChairAccessible $isWheelChairAccessible -Tags ($table.Tags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName) -ErrorVariable setplaceerr }#>
        

        Set-Place $wkspc.PrimarySmtpAddress -Building $BuildingName -Street $buildingStreet -City $CityName -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $PhoneNumber -GeoCoordinates $BuildingGeo -IsWheelChairAccessible $isWheelChairAccessible -Tags ($WorkspaceTags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName) -ea SilentlyContinue -ErrorVariable setplaceerr
        #Start-Sleep -Seconds 10

        #Set-Place $wkspc.PrimarySmtpAddress -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $PhoneNumber -GeoCoordinates $BuildingGeo
        
        #Start-Sleep -Seconds 10

        #Set-Place $wkspc.PrimarySmtpAddress -IsWheelChairAccessible $isWheelChairAccessible -Tags ($WorkspaceTags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName)
        
        $place = get-place $wkspc.PrimarySmtpAddress  | Select-Object DisplayName,Type,phone,Floor,Capacity,street,city,state,country*,postal*,tags,*device*
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Workspace Resource creation was successful.`n $(Write-Output -inputobject $place)"
       
        Write-Verbose -Message "Get-Place Object Created`t($place)"
        if($place.City) {
            write-host "Place object created succesfully:`t$place"-ForegroundColor Green
        }

        if($CreateGraphObject) {
            $gplace = New-PlaceOnGraph -City $place.City -CountryOrRegion $place.CountryOrRegion -PostalCode $place.PostalCode -State $place.State -Street $place.Street -PhoneNumber $place.PhoneNumber -EmailAddress $mbx.PrimarySMTPAddress -Capacity $place.Capacity -Tags $place.Tags -Latitude $place.Geocoordinate.Latitude -Longitude $place.Geocoordinate.Longitude -NickName $place.DisplayName -DisplayedName $place.DisplayName
                
            
            Write-Verbose "Graph Place Workspace Object Created`t($gPlace)"

        }
        
        return $wkspc
       
}