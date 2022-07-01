function Write-Log([string[]]$Message, [string]$LogFile = $LogFile, [switch]$ConsoleOutput, [ValidateSet("SUCCESS", "INFO", "WARN", "ERROR", "DEBUG")][string]$LogLevel)
    {
        $Message = $Message + $Input
        If (!$LogLevel) { $LogLevel = "INFO" }
            switch ($LogLevel)
            {
                SUCCESS { $Color = "Green" }
                INFO { $Color = "White" }
                WARN { $Color = "Yellow" }
                ERROR { $Color = "Red" }
                DEBUG { $Color = "Gray" }
            }
        if ($null -eq $Message -and $Message.Length -gt 0)
        {
            $TimeStamp = [System.DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
            if ($null -eq $LogFile -and $LogFile -ne [System.String]::Empty)
            {
                Out-File -Append -FilePath $LogFile -InputObject "[$TimeStamp] [$LogLevel] :: $Message"
            }
            if ($ConsoleOutput -eq $true)
            {
                Write-Output "[$TimeStamp] [$LogLevel] :: $Message" -ForegroundColor $Color
            }
        }
    }