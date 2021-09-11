RAlt & LWin:: ;hide/unhide taskbar (toogle) 
    Run control.exe /name Microsoft.Taskbar
    WinWait ahk_class ApplicationFrameWindow
    WinRestore ahk_class ApplicationFrameWindow
    WinMaximize ahk_class ApplicationFrameWindow
    Sleep, 800
	WinActivate ahk_class ApplicationFrameWindow
    Send {Back}{Tab 3}             
    Sleep 1000
	WinActivate ahk_class ApplicationFrameWindow
    Send {Space}
    Sleep 800
	WinActivate ahk_class ApplicationFrameWindow
    Send !{F4}
return