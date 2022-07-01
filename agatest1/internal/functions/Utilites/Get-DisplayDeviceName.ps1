function Get-DisplayDeviceName() {
    $dname = ""
    switch ((Get-Random -Minimum 1 -Maximum 4)) {
        1 {$dname = "Dell 86 4K Interactive Touch Monitor"}
        2 {$dname = "Avocor E Series 55-inch 4K Interactive Touch Display"}
        3 {$dname = "Samsung QPR-K Series 98-inch 8k QLED"}
        4 {$dname = "None"}
    }
    if(!("" -eq $dname)) {
        if(!("none" -eq $dname)) {
            write-log -ConsoleOutput -LogFile $LogFile -LogLevel SUCCESS -Message "Audio device retrieved: $dname"
            Write-Verbose -Message "Audio device retrieved: $dname"
        }
        else {                
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel WARN -Message "No audio device on this room resource: $dname"
        Write-Verbose -Message "Audio device retrieved: $dname"
        }

    }
    else {
        write-log -ConsoleOutput -LogFile $LogFile -LogLevel ERROR -Message "Audio Device is null: $dname"
        write-verbose -Message "Audio Device is null: $dname"
    }
    return $dname

} 