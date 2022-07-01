function new-city() {                
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]$cityname
        )
    
    $m = "Calling rest API: 'http://dev.virtualearth.net/REST/v1/Locations?query=$([System.Web.HttpUtility]::UrlEncode("Downtown $cityname"))&includeNeighborhood=0&include=ciso2&maxResults=1&key=$($bingmapskey)'"
    write-log -ConsoleOutput -LogFile $LogFile -LogLevel INFO -Message $m
    Write-Verbose -Message $m
    $c = (Invoke-RestMethod "http://dev.virtualearth.net/REST/v1/Locations?query=$([System.Web.HttpUtility]::UrlEncode("Downtown $cityname"))&includeNeighborhood=0&include=ciso2&maxResults=1&key=$($bingmapskey)").resourceSets.resources
    if(!($null -eq $c)){
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "City retrival was successful.`n $c"
        Write-Verbose -Message "City retrieval was successful.`n $c"
        return (Get-GeoFromCityCoordinates -latitude $c.point.coordinates[0] -longitude $c.point.coordinates[1])
    }
    else {
        
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel Error -Message "City retrieval failed."
        Write-Verbose -Message "City retrieval failed."
    }
}