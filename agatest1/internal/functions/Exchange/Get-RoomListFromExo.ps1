function Get-RoomListFromExo() {
    return (Get-DistributionGroup -recipienttypedetails roomlist)
}