function new-building() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$geo
        )

    $geo2 = Get-GeoFromCityCoordinates -latitude $geo.Split(',')[0] -longitude $geo.Split(',')[1]
    $m = "Calling rest API: 'https://dev.virtualearth.net/REST/v1/LocationRecog/$($geo2)?&top=1&includeEntityTypes=businessAndPOI&r=1.33&key=$($bingmapskey)'"
    write-log -ConsoleOutput -LogFile $LogFile -LogLevel INFO -Message $m
    Write-Verbose -Message $m
    $b = (Invoke-RestMethod "https://dev.virtualearth.net/REST/v1/LocationRecog/$($geo2)?&top=1&includeEntityTypes=businessAndPOI&r=1.33&key=$($bingmapskey)").resourceSets.resources.businessesAtLocation
    if($b){
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Building retrivial was a success.`n $($b.businessAddress)`n$($b.businessinfo)"
        Write-Verbose -Message "Building retrivial was a success.`n $($b.businessAddress)`n$($b.businessinfo)"
        return ($b)
    }
    else { 
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Building retrivial failed."
        Write-Verbose -Message "Building retrivial failed."
    }
}