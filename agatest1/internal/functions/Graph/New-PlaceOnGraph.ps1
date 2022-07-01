function New-PlaceOnGraph() {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER City
    Parameter description
    
    .PARAMETER CountryOrRegion
    Parameter description
    
    .PARAMETER PostalCode
    Parameter description
    
    .PARAMETER State
    Parameter description
    
    .PARAMETER Street
    Parameter description
    
    .PARAMETER DisplayedName
    Parameter description
    
    .PARAMETER PhoneNumber
    Parameter description
    
    .PARAMETER NickName
    Parameter description
    
    .PARAMETER EmailAddress
    Parameter description
    
    .PARAMETER Capacity
    Parameter description
    
    .PARAMETER BookingType
    Parameter description
    
    .PARAMETER IsWheelChairAccessible
    Parameter description
    
    .PARAMETER Tags
    Parameter description
    
    .PARAMETER Accuracy
    Parameter description
    
    .PARAMETER Altitude
    Parameter description
    
    .PARAMETER AltitudeAccuracy
    Parameter description
    
    .PARAMETER Latitude
    Parameter description
    
    .PARAMETER Longitude
    Parameter description

    .PARAMETER Confirm
    If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.

    .PARAMETER WhatIf
    If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "")]
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $City,
        
        [Parameter(Mandatory=$false)]
        [string] $CountryOrRegion = "",
        
        [Parameter(Mandatory=$false)]
        [string] $PostalCode = "",
        
        [Parameter(Mandatory=$false)]
        [string] $State = "",
        
        [Parameter(Mandatory=$false)]
        [string] $Street = "",
        
        [Parameter(Mandatory=$true)]
        [string] $DisplayedName,
        
        [Parameter(Mandatory=$false)]
        [string] $PhoneNumber,
        
        [Parameter(Mandatory=$true)]
        [string] $NickName,
        
        [Parameter(Mandatory=$true)]
        [string] $EmailAddress,
        
        [Parameter(Mandatory=$false)]
        [string] $Capacity ="",
        
        [Parameter(Mandatory=$false)]
        [string] $BookingType = "",
        
        [Parameter(Mandatory=$false)]
        [boolean] $IsWheelChairAccessible = $false,
        
        [Parameter(Mandatory=$false)]
        [string[]] $Tags = @(""),
        
        [Parameter(Mandatory=$false)]
        [double] $Accuracy,
        
        [Parameter(Mandatory=$false)]
        [double] $Altitude,
        
        [Parameter(Mandatory=$false)]
        [double] $AltitudeAccuracy,
        
        [Parameter(Mandatory=$false)]
        [double] $Latitude,
        
        [Parameter(Mandatory=$false)]
        [double] $Longitude
    )

    
        $Address = @{
        City = $City
        CountryOrRegion = $CountryOrRegion
        PostalCode = $PostalCode
        State = $State
        Street = $Street
        Type = $null
    }

    #$DisplayName = $DisplayedName

    #$Phone = $PhoneNumber

    $AdditionalProperties = @{
        displayedName = "$DisplayedName"
        nickname = "$NickName"
        emailAddress = $EmailAddress
        capacity = $Capacity
        bookingType = $BookingType
        isWheelChairAccessible = $IsWheelChairAccessible
        tags = '"' + ($Tags -join '","') + '"'
    }

    $GeoCoordinates = @{
        Latitude = $Latitude
        Longitude = $Longitude
        Accuracy = $Accuracy
        Altitude = $Altitude
        AlltitudeAccuracy = $AltitudeAccuracy
    }
    <#
    [-AdditionalProperties <Hashtable>]
   [-Address <IMicrosoftGraphPhysicalAddress1>]
   [-DisplayName <String>]
   [-GeoCoordinates <IMicrosoftGraphOutlookGeoCoordinates>]
   [-Id <String>]
   [-Phone <String>]
    #>

    New-MgPlace -AdditionalProperties $AdditionalProperties -Address $Address -DisplayName $DisplayedName -GeoCoordinates $GeoCoordinates -Phone $PhoneNumber
    
    
    $place = get-mgplace -placeId "$EmailAddress"
    if($null -ne $place) {
        
    Write-Verbose -Message "Graph obj created successfully.`t$place"
    return $true
    }
    else {

        Write-Verbose -Message "Graph obj creation falied.`t$place"
        return $false
    }
    
}