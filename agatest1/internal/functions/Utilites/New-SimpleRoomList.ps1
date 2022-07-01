function New-SimpleRoomList () {
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]$City,
        [Parameter(Mandatory=$false)]
        [int]$BuildingsPerCity = 2,
        [Parameter(Mandatory=$false)]
        [int]$RoomsPerBuilding = 3,
        [Parameter(Mandatory=$false)]
        [boolean]$includeWorkspaces = $false<#,        
        [Parameter(Mandatory=$false)]
        [string]$LogFile = (Get-Date -Format yyyy-MM-dd) + "_RoomResourceGenerator.txt",        
        [Parameter(Mandatory=$false)]
        [switch]$DebugLogging,
        [Parameter(Mandatory=$false)]
        [switch]$CreateGraphObject#>

    )         
    $StreetName = "First St.","2nd Ave","Third Street","4th Avenue","5th St.","6th Street","Elm Street","Main Street","Broadway"
    $states = 'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY'
    #$tags = "Tag1","Tag2","Tag3","Tag4","Tag5"
    

        #iterate cities 
        foreach ($cty in $City) {
            $state = $states[(Get-Random -minimum 0 -Maximum ($states.Length - 1))]
            #iterate buildings (RoomLists)
            for($i=1;$i -le $BuildingsPerCity;$i++) {
                
                #format building number
                $s = ""
                if ($i.ToString().Length -eq 1) {$s = "0$i"} else {$s = $i}

                #format building name
                $buildingName = "$($cty) Building $s"
                
                #create room distro
                $rl = New-DistributionGroup -Name "$($buildingName -replace ' ','_')_Conference_Rooms" -DisplayName "$buildingName Conference Rooms"
                #set to room list
                Set-DistributionGroup $rl.PrimarySMTPAddress -RoomList

                #create workspace distro
                if($includeWorkspaces) {
                    
                    $wl = New-DistributionGroup -Name "$($buildingName -replace ' ','_')_Workspaces" -DisplayName "$buildingName Workspaces"
                    Set-DistributionGroup $wl.PrimarySMTPAddress -RoomList
                }

                for ($ii=1;$ii -le $RoomsPerBuilding;$ii++) {
                    
                    #format room name and number
                    $ss = ""
                    if ($ii.ToString().Length -eq 1) {$ss = "0$ii"} else {$ss = $ii}
                    $mbxName = "$($buildingName -replace ' ','_')_MeetingRoom_$ss"

                    #create Mailbox
                    $mbx = New-Mailbox -Name $mbxName -DisplayName ($mbxName -replace '_',' ') -Room
                    $email = $mbx.PrimarySmtpAddress
                    
                    do{
                        start-sleep -Seconds 2
                        $mbx = get-mailbox $email
                    } while ($null -eq $mbx.PrimarySMTPAddress) 

                    
                    #add to distro
                    Add-DistributionGroupMember $rl.PrimarySmtpAddress -Member $mbx.PrimarySmtpAddress

                    #create temp place obj
                    $mbxPlace = new-object PSObject -Property @{
                        Identity = $mbx.PrimarySMTPAddress
                        RoomNumber = $ss
                        Building = $buildingName
                        Street = "$(Get-Random -Minimum 100 -Maximum 3889) $($StreetName[(get-random -Minimum 0 -Maximum ($StreetName.Length -1))])"
                        City = $cty
                        State = $state
                        PostalCode = (Get-Random -Minimum 32233 -Maximum 90210)
                        Country = "US"
                        Phone = "($(Get-Random -minimum 201 -Maximum 799)) $(get-random -minimum 201 -Maximum 799)-$(get-random -minimum 1001 -Maximum 9999)"
                        Geocoordinates =$null #"$((Get-Random -minimum -99.9999999 -Maximum 99.9999999)),$((Get-Random -minimum -99.9999999 -Maximum 99.9999999))"
                        isWheelChairAccessible = $false
                        Tags = $null          
                    }
                    Write-Host "Preparing Place Object:`t$mbxPlace" -ForegroundColor Yellow
                    #set the place object
                    Set-Place $mbxPlace.Identity -Building $mbxPlace.building -Street $mbxPlace.Street -City $mbxPlace.City -State $mbxPlace.State -CountryOrRegion $mbxPlace.Country -PostalCode $mbxPlace.PostalCode -ea SilentlyContinue -ErrorVariable setplaceerr


                    
                    Write-Host "Meeting Room Completed:`t$($mbx.DisplayName)`n$mbx" -ForegroundColor Green

                    if($includeWorkspaces) {
                        
                        #create workspace
                        $wkspcName = "$(buildingName -replace ' ','_')_Workspace_$ss"

                    #create Mailbox
                    $wkspc = New-Mailbox -Name $wkspcName -DisplayName ($wkspcName -replace '_',' ') -room
                    Set-Mailbox $wkspc.PrimarySmtpAddress -Type Workspace
                    $email = $wkspc.PrimarySmtpAddress
                    
                    do{
                        start-sleep -Seconds 2
                        $wkspc = get-mailbox $email
                    } while ($null -eq $wkspc.PrimarySMTPAddress) 

                    
                    #add to distro
                    Add-DistributionGroupMember $wl.PrimarySmtpAddress -Member $wkspc.PrimarySmtpAddress

                    #create temp place obj
                    $wkspcPlace = new-object PSObject -Property @{
                        Identity = $wkspc.PrimarySMTPAddress
                        RoomNumber = $ss
                        Building = $buildingName
                        Street = "$(Get-Random -Minimum 100 -Maximum 3889) $($StreetName[(get-random -Minimum 0 -Maximum ($StreetName.Length -1))])"
                        City = $cty
                        State = $states[(Get-Random -minimum 0 -Maximum ($states.Length - 1))]
                        PostalCode = (Get-Random -Minimum 32233 -Maximum 90210)
                        Country = "US"
                        Phone = "($(Get-Random -minimum 201 -Maximum 799)) $(get-random -minimum 201 -Maximum 799)-$(get-random -minimum 1001 -Maximum 9999)"
                        Geocoordinates = $null #"$(Get-Random -minimum -99.9999999 -Maximum 99.9999999),$(Get-Random -minimum -99.9999999 -Maximum 99.9999999)"
                        isWheelChairAccessible = $true
                        Tags = @()        
                    }

                    #set the place object
                    Set-Place $wkspcPlace.Identity -Building $wkspcPlace.building -Street $wkspcPlace.Street -City $wkspcPlace.City -State $wkspcPlace.State -CountryOrRegion $wkspcPlace.Country -PostalCode $wkspcPlace.PostalCode -ea SilentlyContinue -ErrorVariable setplaceerr
                    Write-Host "Workspace created:`t$($wkspc.Displayname)`n$wkspc" -ForegroundColor Green
                    }

                }


                Write-Host "$buildingName completed." -ForegroundColor Cyan
            }

            Write-Host "$cty Buildings completed." -ForegroundColor Cyan
        }

    }