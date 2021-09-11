~!q::
HideOrShowDesktopIcons()
return

HideOrShowDesktopIcons()
{
	ControlGet, class, Hwnd,, SysListView321, ahk_class Progman
	If class =
		ControlGet, class, Hwnd,, SysListView321, ahk_class WorkerW

	If DllCall("IsWindowVisible", UInt,class)
		WinHide, ahk_id %class%
	Else
		WinShow, ahk_id %class%
}
