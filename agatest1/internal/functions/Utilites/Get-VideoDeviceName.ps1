function Get-VideoDeviceName() {
    $vname = ""
    switch ((Get-Random -Minimum 1 -Maximum 4)) {            
        1 { $vname = "BOSE VIDEOBAR VB1"  }
        2 { $vname = "Polycom G7500" }
        3 { $vname = "Logitech Rally Videoconferencing Kit" }
        4 { $vname = "None" }
    }
    if(!("" -eq $vname)) {
        if(!("none" -eq $vname)) {
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Video device retrieved: $vname"
            Write-Verbose -Message "Video device retrieved: $vname"
        }
        else {                
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel WARN -Message "No video device on this room resource: $vname"
            Write-Verbose -Message "No video device on this room resource: $vname"
        }

    }
    else {
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Video Device is null: $vname"
        Write-Verbose -Message "Video Device is null: $vname"
    }
    return $vname
}