function Get-TokenFromAzure() {
    return Get-AzAccessToken -ResourceTypeName MSGraph
}