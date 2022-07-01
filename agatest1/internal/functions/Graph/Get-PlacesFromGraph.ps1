function Get-PlacesFromGraph() {
    #Get-DistributionGroup *meeting* | % { $room = $_.identity ; Get-DistributionGroupMember $_.identity | select @{N="DistributionGroup Name";E={$room}},name,*type*} | ft -a
    $gPlaces = (Get-RoomsFromExo | Select-object PrimarySMTPAddress | ForEach-Object {Get-MgPlace -PlaceId "$($_.PrimarySMTPAddress)" -ErrorAction SilentlyContinue | Select-object *})
    return Format-PlacesFromGraph -Places $gPlaces
}
function Format-PlacesFromGraph() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [psobject[]] $places
    )
    $p = @()
    foreach ($place in $places) {
        $pl = [ordered]@{
            Id = $place.Id
            Phone = $place.Phone
            StreetAddress = $place.Address.StreetAddress
            City = $place.Address.City
            State = $place.Address.State
            PostalCode = $place.Address.PostalCode
            CountryOrRegion = $place.Address.CountryOrRegion
            DisplayName = $place.DisplayName
            Latitude = $place.GeoCoordinates.Latitude
            Longitude = $place.GeoCoordinates.Longitude
            Accuracy = $place.GeoCoordinates.Accuracy
            Altitude = $place.GeoCoordinates.Altitude
            AltitudeAccuracy = $place.GeoCoordinates.AltitudeAccuracy
            NickName = $place.AdditionalProperties["nickname"]
            EmailAddress = $place.AdditionalProperties["emailAddress"]
            Capacity = $place.AdditionalProperties["capacity"]
            BookingType = $place.AdditionalProperties["bookType"]
            IsWheelChairAccessible = $place.AdditionalProperties["isWheelChairAccessible"]
            Tags = $place.AdditionalProperties["tags"]

        }
        $p += new-object psobject -Property $pl
    }

    return $p
}


