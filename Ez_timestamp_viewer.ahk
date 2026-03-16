#Requires AutoHotkey v2.0
#SingleInstance force
Persistent


global appEnabled := true
global time_zone_GMT := DateDiff(A_Now , A_NowUTC, "Hours") ;Measure local timezone

;---Hotkeys---
^F1::ExitApp()
^`::toggleApp()

OnClipboardChange(clipChanged)


;---Functions---
clipChanged(DataType) {
    try {
        global appEnabled

        if (!appEnabled)
            return

        ;ignore non-text data
        if (DataType != 1)
            return

        ;timestamp often has length 10 or 13
        rawData := A_Clipboard
        if (StrLen(rawData) != 13 && StrLen(rawData) != 10)
            return

        ;convert timestamp to readable text
        rawData := SubStr(rawData, 1, 10)
        timestamp := Number(rawData)
        date := unixTimeToHumanReadable(timestamp)
   
        ToolTip(date)
        SetTimer(ToolTip, -5000)

    } catch Error as e {
    }
}

unixTimeToHumanReadable(seconds)
{
    datetime := DateAdd(19700101000000, seconds, "Seconds")
    datetime := DateAdd(datetime, time_zone_GMT, "Hours")

    ; Return the time
    return FormatTime(datetime, "dd/MM/yyyy HH:mm:ss") . "  GMT+" . time_zone_GMT
}


toggleApp(){
     global appEnabled := !appEnabled

    ToolTip(appEnabled ? "ON" : "OFF")
    SetTimer(ToolTip, -2000)
}








