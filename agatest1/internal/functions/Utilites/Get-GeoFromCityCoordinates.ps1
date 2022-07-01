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
        Write-Log -ConsoleOutput -LogFile $logfile -LogLevel WARN -Message "Running random geocoordinate for throw away: $t"
        Write-Verbose -Message "Running random geocoordinate for throw away: $t"
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
        Write-Verbose -Message "Geocoordinate(s) generated: $location"
        return $location
    }
    else {

        write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Geocoordinate(s) were not generated: $location"
        Write-Verbose -Message "Geocoordinate(s) were not generated: $location"
    }
}