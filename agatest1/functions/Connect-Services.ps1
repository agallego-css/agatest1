function Connect-Services() {
    <#
    .SYNOPSIS
    Connects to required services shells in Microsoft cloud
    
    .DESCRIPTION
    Connects to AzureAD, Exchange Online, MSOnline, and MicrosoftGraph shells.
    
    .EXAMPLE
    Connect-Services
    
    .NOTES
    Auto prompts for credentials.

    MSGraph connection may require consent of permissions "Place.ReadWrite.All","User.Read.All"

    Support for on-prem connections via remote powershell planned in future releases.

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param(
        #[Parameter(Mandatory=$false)]
        #[boolean]$OnPrem=$false
    )
    if ($null -eq $creds) {
        $creds = get-credential -Message "Please enter your credentials, make sure you are using a global administrator account for 'AzureAD', 'ExcangeOnline', and 'MSGraph'"

    }
    <#
    if($true -eq $OnPrem) {
        Connect-OnPrem -Credential $global:creds
    }#>
    Connect-Azure -Credential $creds
    Connect-Exo -Credential $creds
    Connect-Places
    Connect-Msol -Credential $creds
}