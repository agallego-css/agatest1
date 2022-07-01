<#
.VERSION 0.1.0
 
.GUID 
 
.AUTHOR Corey Schneider
 
.COMPANYNAME Microsoft
 
.COPYRIGHT 2022
 
.TAGS
 
.LICENSEURI
 
.PROJECTURI 
https://github.com/CoreySchneider-MSFT/Exo.RoomsManagement

.ICONURI
 
.EXTERNALMODULEDEPENDENCIES
- ExchangeOnlineManagement
- MSOnline

.REQUIREDSCRIPTS
 
.EXTERNALSCRIPTDEPENDENCIES
 
.RELEASENOTES
 
.DESCRIPTION
Generates rooms and workspaces in an tenant, intended for SE lab environments
 
.PRIVATEDATA
 
.SYNOPSIS
Generate Room or Workspace mailboxes and resources dynamically
 
 
.EXAMPLE
 
.LINK

 
.NOTES
 Requires a BingMapsAPI key to run.
 https://docs.microsoft.com/en-us/bingmaps/getting-started/bing-maps-dev-center-help/getting-a-bing-maps-key
#>
function New-RoomList () {
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]$City,
        [Parameter(Mandatory=$true)]
        [string]$bingmapskey,
        [Parameter(Mandatory=$false)]
        [int]$BuildingsPerCity = 5,
        [Parameter(Mandatory=$false)]
        [int]$RoomsPerBuilding = 5,
        [Parameter(Mandatory=$false)]
        [boolean]$includeWorkspaces = $false<#,        
        [Parameter(Mandatory=$false)]
        [string]$LogFile = (Get-Date -Format yyyy-MM-dd) + "_RoomResourceGenerator.txt",        
        [Parameter(Mandatory=$false)]
        [switch]$DebugLogging,
        [Parameter(Mandatory=$false)]
        [switch]$CreateGraphObject#>

    )         
    
<#
    function Write-Log([string[]]$Message, [string]$LogFile = $LogFile, [switch]$ConsoleOutput, [ValidateSet("SUCCESS", "INFO", "WARN", "ERROR", "DEBUG")][string]$LogLevel)
    {
        $Message = $Message + $Input
        If (!$LogLevel) { $LogLevel = "INFO" }
            switch ($LogLevel)
            {
                SUCCESS { $Color = "Green" }
                INFO { $Color = "White" }
                WARN { $Color = "Yellow" }
                ERROR { $Color = "Red" }
                DEBUG { $Color = "Gray" }
            }
        if ($null -eq $Message -and $Message.Length -gt 0)
        {
            $TimeStamp = [System.DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
            if ($null -eq $LogFile -and $LogFile -ne [System.String]::Empty)
            {
                Out-File -Append -FilePath $LogFile -InputObject "[$TimeStamp] [$LogLevel] :: $Message"
            }
            if ($ConsoleOutput -eq $true)
            {
                Write-Host "[$TimeStamp] [$LogLevel] :: $Message" -ForegroundColor $Color
            }
        }
    }
    function Get-GeoFromCityCoordinates() {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true)]
        [decimal]$latitude,
        [Parameter(Mandatory=$true)]
        [decimal]$longitude
        )

        #Write-Host "Input Latitude:`t$latitude`nInput Longitude:`t$longitude"
        function new-random() {
            $t = get-random -Minimum -0.0099999 -Maximum 0.0099999
            Write-Log -ConsoleOutput -LogFile $logfile -LogLevel WARN -Message "Running random geo for throw away: $t"
            return [decimal](get-random -Minimum -0.0099999 -Maximum 0.0099999)
        }


        $switchRand = (get-random -Minimum 1 -Maximum 4)
        $location = ""
        switch ($switchRand) {
            1 { $location = "$($latitude - (new-random)),$($longitude - (new-random))"  }
            2 { $location = "$($latitude - (new-random)),$($longitude + (new-random))" }
            3 { $location = "$($latitude + (new-random)),$($longitude + (new-random))"  }
            4 { $location = "$($latitude + (new-random)),$($longitude - (new-random))" }
        }
        if(!("" -eq $location)){
            
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Geocoordinate(s) generated: $location"
            return $location
        }
        else {

            write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Geocoordinate(s) were not generated: $location"
        }
    }

    function Get-VideoDeviceName() {
        $vname = ""
        switch ((Get-Random -Minimum 1 -Maximum 4)) {            
            1 { $vname = "BOSE VIDEOBAR VB1"  }
            2 { $vname = "Polycom G7500" }
            3 { $vname = "Logitech Rally Videoconferencing Kit" }
            4 { $vname = "None" }
        }
        if(!("" -eq $vname)) {
            if(!("none" -eq $vname)) {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Video device retrieved: $vname"
            }
            else {                
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel WARN -Message "No video device on this room resource: $vname"
            }

        }
        else {
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Video Device is null: $vname"
        }
        return $vname
    }

    function Get-AudioDeviceName() {
        $aname = ""
        switch ((Get-Random -Minimum 1 -Maximum 4)) {
            1 { $aname = "BOSE VIDEOBAR VB1" }
            2 { $aname = "Polycom G7500" }
            3 { $aname = "Logitech Rally Videoconferencing Kit" }
            4 { $aname = "None" }
        }
        if(!("" -eq $aname)) {
            if(!("none" -eq $aname)) {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Audio device retrieved: $aname"
            }
            else {                
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel WARN -Message "No audio device on this room resource: $aname"
            }

        }
        else {
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Audio Device is null: $aname"
        }
        return $aname

    }

    function Get-DisplayDeviceName() {
        $dname = ""
        switch ((Get-Random -Minimum 1 -Maximum 4)) {
            1 {$dname = "Dell 86 4K Interactive Touch Monitor"}
            2 {$dname = "Avocor E Series 55-inch 4K Interactive Touch Display"}
            3 {$dname = "Samsung QPR-K Series 98-inch 8k QLED"}
            4 {$dname = "None"}
        }
        if(!("" -eq $dname)) {
            if(!("none" -eq $dname)) {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Audio device retrieved: $dname"
            }
            else {                
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel WARN -Message "No audio device on this room resource: $dname"
            }

        }
        else {
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Audio Device is null: $dname"
        }
        return $dname

    } 

    function new-city() {                
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$true)]
            [string[]]$cityname
            )
        
        $m = "Calling rest API: 'http://dev.virtualearth.net/REST/v1/Locations?query=$([System.Web.HttpUtility]::UrlEncode("Downtown $cityname"))&includeNeighborhood=0&include=ciso2&maxResults=1&key=$($apikey)'"
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel INFO -Message $m
        $c = (Invoke-RestMethod "http://dev.virtualearth.net/REST/v1/Locations?query=$([System.Web.HttpUtility]::UrlEncode("Downtown $cityname"))&includeNeighborhood=0&include=ciso2&maxResults=1&key=$($apikey)").resourceSets.resources
        if(!($null -eq $c)){
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "City retrival was successful.`n $c"
            return (Get-GeoFromCityCoordinates -latitude $c.point.coordinates[0] -longitude $c.point.coordinates[1])
        }
        else {
            
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel Error -Message "City retrieval failed."
        }
    }

    function new-building() {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true)]
            [string]$geo
            )

        $m = "Calling rest API: 'https://dev.virtualearth.net/REST/v1/LocationRecog/$($geo)?&top=1&includeEntityTypes=businessAndPOI&r=1.33&key=$($apikey)'"
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel INFO -Message $m
        $b = (Invoke-RestMethod "https://dev.virtualearth.net/REST/v1/LocationRecog/$($geo)?&top=1&includeEntityTypes=businessAndPOI&r=1.33&key=$($apikey)").resourceSets.resources.businessesAtLocation
        if($b){
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Building retrivial was a success.`n $($b.businessAddress)`n$($b.businessinfo)"
            return ($b)
        }
        else { 
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Building retrivial failed."
        }
    }

    #Creates a new Room mailbox, and set-place object
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
            [bool]$WhellChairAccessible = $false,
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
            Start-Sleep -Seconds 2
            $mbx = Get-Mailbox $mbName
        } while (
            $null -eq $mbx.PrimarySmtpAddress
            )
        
        write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "`n`nMailbox Generated:`n$($mbx.PrimarySmtpAddress)`n`n"
        try {
            
            $table = new-object PSObject -Property @{
                Identity = $mbx.PrimarySMTPAddress
                RoomNumber = $RoomNumber
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
            write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -Message "Attempting to run 'Set-Place' for $($mbx.DisplayName).`nExample:`n$(Write-Output -InputObject $table)";           
            
            
            Set-Place $mbx.PrimarySMTPAddress -Building $BuildingName -Street $buildingStreet -City $CityName -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry
            #start-sleep -Seconds 10

            Set-Place $mbx.PrimarySMTPAddress -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $PhoneNumber -GeoCoordinates $BuildingGeo
                        
            #start-sleep -Seconds 10

            Set-Place $mbx.PrimarySMTPAddress -IsWheelChairAccessible $isWheelChairAccessible -Tags ($RoomTags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName)

            $place = get-place $mbx.PrimarySMTPAddress | Select-Object DisplayName,Type,phone,Floor,Capacity,street,city,state,country*,postal*,tags,*device*
            if($place) {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Room Resource creation was successful.`n $(write-output -inputobject $place)"
                
                return (Get-Mailbox $mbx.PrimarySMTPAddress)

            }
            else {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Room Resource creation failed.`n$($error[0])"
            }

        }
        catch {
            {1:write-log -ConsoleOutput -LogFile $logfile -LogLevel ERROR -message "$($error[0])"}
        }
    }
    

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
        $wkspc = Set-Mailbox $wkspc.PrimarySMTPAddress -Type Workspace
        do {
            Write-Log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "The workspace object is currently null, sleeping 2 seconds and retrying."
            start-sleep -Seconds 2
            $wkspc = get-mailbox $wkspcName
        } while (
            $null -eq $wkspc.PrimarySmtpAddress
        )
        write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -message "`n`nMailbox Generated:`n$($wkspc.PrimarySmtpAddress)`n`n"
        try {
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
            

            Set-Place $wkspc.PrimarySmtpAddress -Building $BuildingName -Street $buildingStreet -City $CityName -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry
            
            #Start-Sleep -Seconds 10

            Set-Place $wkspc.PrimarySmtpAddress -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $PhoneNumber -GeoCoordinates $BuildingGeo
            
            #Start-Sleep -Seconds 10

            Set-Place $wkspc.PrimarySmtpAddress -IsWheelChairAccessible $isWheelChairAccessible -Tags ($WorkspaceTags -split ',') -AudioDeviceName (Get-AudioDeviceName) -VideoDeviceName (Get-VideoDeviceName) -DisplayDeviceName (Get-DisplayDeviceName)
            
            $place = get-place $wkspc.PrimarySmtpAddress  | Select-Object DisplayName,Type,phone,Floor,Capacity,street,city,state,country*,postal*,tags,*device*
            if($place) {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Workspace Resource creation was successful.`n $(Write-Outpu -inputobject $place)"
                
                return (Get-Mailbox $wkspc.PrimarySmtpAddress)
            }
            else {
                write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Workspace Resource creation failed.`n$($error[0])"
            }
        }
        catch {
            {1:write-log -ConsoleOutput -LogFile $logfile -LogLevel ERROR -message "$($error[0])"}
        }
    }
#>

        #iterate cities 
        foreach ($cty in $City) {
            #10 streets = 10 buildings per city
            #$cityRes = Invoke-RestMethod "http://dev.virtualearth.net/REST/v1/Locations?query=$([System.Web.HttpUtility]::UrlEncode("Downtown $city"))&includeNeighborhood=0&include=ciso2&maxResults=1&key=$($bingmapskey)"

            $cityRes = new-city -cityname $cty
            $m = "Starting buildout of $BuildingsPerCity building(s) in $cty.`t$($cityRes.resourceSets.resources.address)"
            $cityCountry = $cityRes.resourceSets.resources.address.countryRegionIso2
            
            #write-log -ConsoleOutput -LogFile $LogFile -LogLevel INFO -Message $m
            Write-Verbose -Message $m
            Write-Host "$($m)" -ForegroundColor Cyan
            #get a place from cityRes
            for($b=1; $b -le $BuildingsPerCity; $b++) {
                
                do {
                    #$geo = Get-GeoFromCityCoordinates -latitude $cityRes.resourceSets.resources.bbox[0] -longitude $cityRes.resourceSets.resources.bbox[1]
                    #$buildingRes = Invoke-RestMethod "https://dev.virtualearth.net/REST/v1/LocationRecog/$($geo)?&top=1&includeEntityTypes=businessAndPOI&r=1.33&key=$($global::apikey)"
                    $buildingRes = new-building -geo $cityRes

                    #Make building name
                    #$buildingRes.resourceSets.resources.businessesAtLocation.businessinfo
                    <#
                    entityName : Ropes Park
                    phone      : (361) 826-3460
                    type       : Parks and Recreation
                    otherTypes : {Attractions, Arts and Entertainment, Government and Community, Parks...}
                    #>
                    write-log -ConsoleOutput -LogFile $logfile -LogLevel WARN -Message "TAGS: $($buildingRes.businessinfo.otherTypes)"
                    $buildingName = $buildingRes.businessinfo.entityName
                    $phone = [int64]($buildingRes.businessinfo.phone -replace '[\W]','')
                    $tags = "$($buildingRes.businessInfo.otherTypes -join ',')" -Replace ' ','_'
                    $isWheelChairAccessible = [boolean]::Parse([boolean]$buildingRes.businessinfo.isWheelChairAccessible)
    
                    #$buildingRes.resourceSets.resources.businessesAtLocation.businessAddress
                    <#
    
                    latitude         : 27.753394
                    longitude        : -97.376313
                    addressLine      : 3560 Ocean Dr
                    locality         : Bay Area
                    adminDivision    : TX
                    countryIso2      : US
                    postalCode       : 78411
                    formattedAddress : 3560 Ocean Dr, Bay Area, TX 78411, US
                    #>
                    
                    $buildingStreet = $buildingRes.businessaddress.addressLine
                    $buildingCountry = $buildingRes.businessaddress.countryIso2
                    $buildingCity = $buildingRes.businessaddress.locality
                    $buildingState = $buildingRes.businessaddress.adminDivision
                    $buildingPostalCode = $buildingRes.businessaddress.postalCode
                    $geoCoordinates = "$($buildingRes.businessaddress.latitude);$($buildingRes.businessaddress.longitude)"
                    
                } while (($null -eq $buildingName) -and ($cty -ne $buildingCity) -and ($null -eq $buildingPostalCode) -and ($null -eq $BuildingStreet) -and ($null -eq $BuildingState) -and ($cityCountry -ne $BuildingCountry) -and($null -eq $geoCoordinates) -and ($null -eq $tags))

                #Replace special characters with nothing (mailbox name compliance)
                $pattern = ('[]~_!@#$%^*();:",<>./?\{}+=-'.ToCharArray() | ForEach-Object { [Regex]::Escape($_) }) -join "|"
                $buildingName = $buildingName -replace $pattern,''
                $buildingName = $buildingName -replace '|',''
                

                Write-Host "$buildingName location found, beginning room creation" -ForegroundColor Green


                #create room distribution group for building
                $rl = New-DistributionGroup -Name ("$($buildingName) Meeting Rooms").Replace(' ','_') -DisplayName "$($buildingName) Meeting Rooms"
                #set group to type of room list
                Set-DistributionGroup $rl.PrimarySmtpAddress -RoomList

                #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -Message "Distribution List created: $rl"
                #Write-Verbose -Message "MeetingRoom Distribution List created:`t$rl"
                write-host "MeetingRoom Distribution List created:`t$rl" -ForegroundColor Green

                #if workspaces, create workspace distribution group
                if($includeWorkspaces) { 
                    #create the distribution group
                    $wl = New-DistributionGroup -Name ("$($buildingName) Workspaces").Replace(' ','_') -DisplayName "$($buildingName) Workspaces"
                    #set it to type room list
                    Set-DistributionGroup $wl.PrimarySmtpAddress -RoomList 
                }

                #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -Message "Distribution List created: $wl`n"
                Write-Verbose -Message "Workspace Distribution List created:`t$wl"
                

                #iterate number of rooms and create resources
                for($rm=1;$rm -le $RoomsPerBuilding; $rm++) {
                    #create room mailbox
                    #$s = ""
                    #if ($rm.ToString().Length -eq 1) {$s = "0$rm"} else {$s = $rm}
                    #$mbName = ("$($buildingName)MeetingRoom$($s)").Replace(' ','_')
                    #$mbDisName = "$buildingName Meeting Room $s"
                    #write-host "`nCreating Room Resource: $mbDisName"
                    #if($phone) {$phone = $phone -replace '[\n]',"$($phone.Substring($phone.Length) +1)"} else {$phone = $null}
                    #$email = "$mbName@bullhornblog.com"
                    #create room resource
                    #$mbx = New-Mailbox -Name $mbName -DisplayName $mbDisName -Room
                    if($phone) {$phone = '{0:(###) ###-####}' -f ([int64]($phone -replace '[\W]','') + 1)} else {$phone = $null}

                    $mbx = new-RoomResource -BuildingName $buildingName -RoomNumber $rm -CityName $buildingCity -BuildingState $buildingState -BuildingStreet $buildingStreet -BuildingCountry $buildingCountry -BuildingPostalCode $buildingPostalCode -RoomTags $tags -BuildingGeo $geoCoordinates -PhoneNumber $phone -WheelChairAccessible $isWheelChairAccessible

                    #start-sleep -Seconds 20
                    #Get-mailbox $mbx.PrimarySMTPAddress | FT
                    #add room to building room list
                    #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -message "Adding meetingroom $($mbx.PrimarySmtpAddress) to Distribution group $($rl.DisplayName)"
                    Write-Verbose -Message "Adding meetingroom $($mbx.PrimarySmtpAddress) to Distribution group $($rl.DisplayName)"
                    Write-Host "Adding meetingroom $($mbx.PrimarySmtpAddress) to Distribution group $($rl.DisplayName)" -ForegroundColor Cyan
                    Add-DistributionGroupMember -Identity $rl.Identity -Member $mbx.PrimarySMTPAddress
                    Write-Verbose -Message "$($mbx.PrimarySMTPAddress) added to distribution list $($rl.PrimarySMTPAddress)"
                    write-host "$($mbx.PrimarySMTPAddress) added to distribution list $($rl.PrimarySMTPAddress)" -ForegroundColor Green
                    #run set-place to create places object 

                    #Set-Place $mbx.PrimarySMTPAddress -Building $buildingName -Street $buildingStreet -City $buildingCity -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $phone -GeoCoordinates $geoCoordinates -IsWheelChairAccessible $isWheelChairAccessible -Tags $tags -verbose
                    
                    #Set-Place $mbx.PrimarySMTPAddress -Building $buildingName -Street $buildingStreet -City $buildingCity -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry

                    #start-sleep -Seconds 5

                    #Set-Place $mbx.PrimarySMTPAddress -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $phone -GeoCoordinates $geoCoordinates -IsWheelChairAccessible $isWheelChairAccessible -Tags $tags -AudioDeviceName Get-AudioDeviceName -VideoDeviceName Get-VideoDeviceName -DisplayDeviceName Get-DisplayDeviceName
                    start-sleep -Seconds 5
                    #create workspace mailbox 
                    if($includeWorkspaces) {
                        
                        #$wkspcName = ("$($buildingName)WorkSpace$($s)").Replace(' ','_')
                        #$wkspcDisName = "$buildingName WorkSpace $s"

                        #if($phone) {$phone = $phone -replace '[\n]',"$($phone.Substring($phone.Length) +1)"} else {$phone = $null}
                        #write-host "Creating Workspace Resource: $wkspcDisName"
                        #create workspace resource
                        #$wkspc = New-Mailbox -Name $wkspcName -DisplayName $wkspcDisName -Room
                        #Set-Mailbox $wkspc.PrimarySMTPAddress -Type Workspace
                        if($phone) {$phone = '{0:(###) ###-####}' -f ([int64]($phone -replace '[\W]','') + 1)} else {$phone = $null}

                        $wkspc = new-WorkspaceResource -BuildingName $buildingName -WorkspaceNumber $rm -CityName $buildingCity -BuildingState $buildingState -BuildingStreet $buildingStreet -BuildingCountry $buildingCountry -BuildingPostalCode $buildingPostalCode -WorkspaceTags $tags -BuildingGeo $geoCoordinates -PhoneNumber $phone

                        #start-sleep -Seconds 20

                        #Get-mailbox $mbx.PrimarySMTPAddress | FT
                        #add workspace to room list for workspace
                        #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -message "Adding workspace $($wkspc.PrimarySmtpAddress) to Distribution group $($wl.DisplayName)"
                        write-verbose "Adding workspace $($wkspc.PrimarySmtpAddress) to Distribution group $($wl.DisplayName)"
                        Write-Host "Adding workspace $($wkspc.PrimarySmtpAddress) to Distribution group $($wl.DisplayName)" -ForegroundColor Cyan
                        Add-DistributionGroupMember -Identity $wl.Identity -Member $wkspc.PrimarySMTPAddress
                        Write-verbose -Message "$($wkspc.PrimarySMTPAddress) added to distribution list $($rl.PrimarySMTPAddress)"
                        Write-Host "$($wkspc.PrimarySMTPAddress) added to distribution list $($rl.PrimarySMTPAddress)" -ForegroundColor Green

                        #Set-Place $wkspc.PrimarySMTPAddress -Building "$buildingName" -Street $buildingStreet -City $buildingCity -State $buildingState -PostalCode $buildingPostalCode -CountryOrRegion $buildingCountry 
                        
                        #start-sleep -Seconds 5
                        
                        #Set-Place $wkspc.PrimarySMTPAddress -Floor (Get-Random -Minimum 1 -Maximum 30) -Capacity (Get-Random -Minimum 5 -Maximum 20) -Phone $phone -GeoCoordinates $geoCoordinates -IsWheelChairAccessible $isWheelChairAccessible -Tags $tags -AudioDeviceName Get-AudioDeviceName -VideoDeviceName Get-VideoDeviceName -DisplayDeviceName Get-DisplayDeviceName
                        #Set-Place $wkspc.PrimarySMTPAddress -Tags $tags
                    }#end workspace

                }#end room

                $dl = Get-DistributionGroupMember (Get-DistributionGroup $rl.PrimarySmtpAddress).Identity | Select-Object DisplayName,PrimarySMTPAddress,@{N='RoomListName';E={$rl.DisplayName}}
                #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -Message "Building List completed.`n $($dl)"
                Write-Verbose -Message "Building MeetingRoom List completed.`t$dl"
                write-host "Building MeetingRoom List completed.`t$dl" -ForegroundColor Green -BackgroundColor Black
                if($includeWorkspaces) {
                    $dl = Get-DistributionGroupMember (Get-DistributionGroup $wl.PrimarySmtpAddress).Identity | Select-Object DisplayName,PrimarySMTPAddress,@{N='RoomListName';E={$wl.DisplayName}}
                    #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -Message "Building List completed.`n $($dl)"
                    Write-Verbose -Message "Building Workspace List completed.`t$dl"
                    write-host "Building Workspace List completed.`t$dl" -ForegroundColor Green -BackgroundColor Black
                }
                
            $citybuilding = Get-DistributionGroup | Where-Object -Property Displayname -Contains $buildingName | Select-Object DisplayName,PrimarySmtpAddress
            #write-log -ConsoleOutput -LogFile $logfile -LogLevel INFO -Message "City building has been created.`n $($citybuilding)"
            Write-Verbose -Message "City building has been created.`t$citybuilding"
            Write-Host "City building has been created.`t$citybuilding" -ForegroundColor Green -BackgroundColor Black
            } #end building loop
            Write-Verbose -Message "Ending City Build out." 
            Write-Host "Ending City Build out." -ForegroundColor Green  
        } #end City loop
    }
