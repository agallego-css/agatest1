@{
	# Script module or binary module file associated with this manifest
	RootModule           = 'agatest1.psm1'
	
	# Version number of this module.
	ModuleVersion        = '1.0.0'
	
	# ID used to uniquely identify this module
	GUID                 = '54ff8b25-5de0-4aa7-a9ea-a3b128f26442'
	
	# Author of this module
	Author               = 'agallego'
	
	# Company or vendor of this module
	CompanyName          = 'Microsoft'
	
	# Copyright statement for this module
	Copyright            = 'Copyright (c) 2022 agallego'
	
	# Description of the functionality provided by this module
	Description          = 'testing module'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion    = '5.1'

	# Supported PSEditions
	CompatiblePSEditions = @('Desktop')
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules      = @(
		@{ ModuleName = 'PSFramework'; ModuleVersion = '1.7.237' }
		"AzureAD"
		"ExchangeOnlineManagement"
		"Microsoft.Graph.Calendar"
		"MSOnline"
	)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\agatest1.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\agatest1.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\agatest1.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport    = @(
		'Connect-Services'
		'Disconnect-Services'
		'New-RoomList'
		'Remove-RoomsByName'
		'Get-RoomReport'
	)
	
	# Cmdlets to export from this module
	CmdletsToExport      = ''
	
	# Variables to export from this module
	VariablesToExport    = ''
	
	# Aliases to export from this module
	AliasesToExport      = ''
	
	# List of all modules packaged with this module
	ModuleList           = @()
	
	# List of all files packaged with this module
	FileList             = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData          = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/CoreySchneider-MSFT/Exo.RoomsManagement'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}