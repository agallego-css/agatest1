function Get-AudioDeviceName() {
    $aname = ""
    switch ((Get-Random -Minimum 1 -Maximum 4)) {
        1 { $aname = "BOSE VIDEOBAR VB1" }
        2 { $aname = "Polycom G7500" }
        3 { $aname = "Logitech Rally Videoconferencing Kit" }
        4 { $aname = "None" }
    }
    if(!("" -eq $aname)) {
        if(!("none" -eq $aname)) {
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Audio device retrieved: $aname"
            write-verbose -Message "Audio device retrieved: $aname"
        }
        else {                
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel WARN -Message "No audio device on this room resource: $aname"
        Write-Verbose -Message "No audio device on this room resource: $aname"
        }

    }
    else {
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Audio Device is null: $aname"
        Write-Verbose -Message "Audio Device is null: $aname"
    }
    return $aname

}