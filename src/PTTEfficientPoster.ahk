/*
 * Copyright 2005-2021 Henry Chang
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

; N.B.: Only works with the AutoHotkey ANSI version.

Version := "Version 2.1"
Author := "Henry Chang"
FirstVersionDate := "Sunday, November 6th, 2005"
Intro := ""
. "■ 軟體介紹`n"
. "`n"
. "PTT Efficient Poster 是一支為了讓使用者在 PTT 發表文章後，能得到合理的稿酬而誕生的程式。"
. "因應 PTT 計算稿酬的方式，本程式會像打字機一般，將剪貼簿中的文章，在背景自動、逐字貼到 PTT 中。`n"
. "`n"
. "`n"
. "■ 軟體特色`n"
. "`n"
. "‧支援 BBS 控制碼。`n"
. "‧支援雙色全形字（一字雙色）。`n"
. "‧支援 Big-5 擴充字集（支援 Unicode 補完計畫內的日文字）。`n"
. "‧支援背景貼文。`n"
. "‧支援臨時暫停貼文。`n"
. "‧支援 Windows 2000/XP/Vista/7/8/10 (x86 & x64)。`n"
. "`n"
. "`n"
. "■ 使用前準備`n"
. "`n"
. "‧修改 PTT 站台設定如下：`n"
. "`n"
. "　　(U)ser         【 個人設定區 】`n"
. "　　　(U)Customize    個人化設定`n"
. "　　　　i. DBCS       自動偵測雙位元字集(如全型中文)　　　　：是`n"
. "　　　　j. DBCS       忽略連線程式為雙位元字集送出的重複按鍵：是`n"
. "　　　　k. DBCS       禁止在雙位元中使用色碼(去除一字雙色)　：否`n"
. "`n"
. "`n"
. "■ 使用說明`n"
. "`n"
. "‧貼文方法：`n"
. "`n"
. "　1. 將欲張貼的文章內容貼到程式中。`n"
. "　2. 打開 PCMan 並進入發文狀態。`n"
. "　3. 在 PCMan 中按下 Shift + F9 開始張貼。`n"
. "　4. 開始張貼後，可以切換到別的視窗做其他事，`n"
. "　　 唯獨不可在 PCMan 中另開新分頁。`n"
. "`n"
. "‧張貼完成後程式會自動彈出提示視窗。`n"
. "‧欲暫停張貼，請按 Shift + F11。`n"
. "　暫停後，從工作列圖示的選單中取消暫停即可繼續貼文。`n"
. "‧欲取消張貼，請按 Shift + F12 重新載入本程式，或關閉本程式。"

#SingleInstance Force
SetTitleMatchMode, 3  ; A window's title must exactly match WinTitle to be a match.


; Tray icon
Menu, Tray, NoStandard
Menu, Tray, Click, 1 ; Specify 1 for ClickCount to allow a single-click to activate the tray menu's default menu item.
Menu, Tray, Add, 顯示主視窗, L_GuiShowHideToggle
Menu, Tray, Add, 暫停 ( Shift + F11 ), L_TrayPause
Menu, Tray, Add, 重新載入 ( Shift + F12 ), L_TrayReload
Menu, Tray, Add, 離開, L_TrayExit
Menu, Tray, Default, 顯示主視窗

TrayTip, , PTT Efficient Poster, 1, 1
SetTimer, L_RemoveTrayTip, 1500


; GUI
Gui, Font, s18 Bold, Courier ; Consolas
Gui, Add, Text, vMyText1, PTT Efficient Poster
Gui, Font, s12 norm, 細明體
Gui, Add, Edit, HwndMyEditHwnd r19 w666 vMyEdit

Gui, Font, s10, 新細明體
Gui, Add, Statusbar, ,　閒置
SB_SetParts(200)
Gui, Add, Text, y+10, %FirstVersionDate% - %Version% -
Gui, Font, cBlue
Gui, Add, Text, x+5 gLink1 vURL_Link1, %Author%
Gui, Font, Norm

; Customize the GUI edit background
EditBackgroundColor := 0xFFFFFF  ; A custom color in BGR format.
EditBackgroundBrush := DllCall("CreateSolidBrush", UInt, EditBackgroundColor)
Gui +LastFound
GuiHwnd := WinExist()
WindowProcNew := RegisterCallback("WindowProc", ""  ; Specifies "" to avoid fast-mode for subclassing.
    , 4, MyEditHwnd)  ; Must specify exact ParamCount when EventInfo parameter is present.
WindowProcOld := DllCall("SetWindowLong", UInt, GuiHwnd, Int, -4  ; -4 is GWL_WNDPROC
    , Int, WindowProcNew, UInt)  ; Return value must be set to UInt vs. Int.
GuiShowHide(1)

; Retrieve scripts PID
Process, Exist
MyPID := ErrorLevel

; Retrieve unique ID number (HWND/handle)
WinGet, HW_GUI, ID, ahk_class AutoHotkeyGUI ahk_pid %MyPID%

; Call "HandleMessage" when script receives WM_SETCURSOR message
WM_SETCURSOR = 0x20
OnMessage(WM_SETCURSOR, "HandleMessage")

; Call "HandleMessage" when script receives WM_MOUSEMOVE message
WM_MOUSEMOVE = 0x200
OnMessage(WM_MOUSEMOVE, "HandleMessage")

Return


Link1:
    Run https://about.me/changyuheng
Return


GuiSize:
    If (ErrorLevel = 1) {  ; The window has been minimized. No action needed.
        Sleep, 400
        GuiShowHide(0)
    }
Return


GuiClose:
    MsgBox, 4, , 確定關閉 PTT Efficient Poster？
    IfMsgBox, Yes
        ExitApp
Return


L_RemoveTrayTip:
    TrayTip
Return


L_TrayPause:
    If (A_IsPaused = 1) {
        Menu, Tray, UnCheck, 暫停 ( Shift + F11 )
    } Else {
        Menu, Tray, Check, 暫停 ( Shift + F11 )
    }
    Pause
Return


L_TrayReload:
    Reload
Return


L_TrayExit:
    ExitApp
Return


L_GuiShowHideToggle:
    GuiIsVisible := GuiIsVisible()
    If (GuiIsVisible = 0) {
        GuiShowHide(1)
    } Else {
        GuiShowHide(0)
    }
Return


+F9 Up::
    KeyWait, Shift, P
    Run()
Return


+F11 Up::
    GoSub, L_TrayPause
Return


+F12 Up::
    Reload
Return


GuiIsVisible() {
    Global GuiHwnd

    WS_VISIBLE := 0x10000000

    WinGet, GuiStyle, Style, ahk_id %GuiHwnd% 
    Transform, Result, BitAnd, %GuiStyle%, %WS_VISIBLE%

    If (Result = 0) {
        Return 0
    } Else {
        Return 1
    }
}


GuiShowHide(ShouldBeVisible) {
    Global GuiHwnd
    If (ShouldBeVisible = 0) {
        Gui, Hide
        Menu, Tray, Rename, 隱藏主視窗, 顯示主視窗
    } Else {
        Gui, Show, , PTT Efficient Poster
        ControlFocus, , ahk_id %GuiHwnd%
        SendMessage, 177, -1, 0, , %hMyTextBox%  ; http://msdn.microsoft.com/en-gb/library/bb761661%28VS.85%29.aspx
        Menu, Tray, Rename, 顯示主視窗, 隱藏主視窗
    }
}


Run() {
    Global MyEdit

    ControlGetFocus, ControlName, A
    WinGet, WindowID, ID, A

    Gui, Submit, NoHide

    Content := Clipboard
    Content := MyEdit
    Len := StrLen(Content)
    Ptr := &Content
    WM_KEYDOWN := 0x100
    WM_KEYUP := 0x101
    WM_CHAR := 0x102

    Minute := Len * 0.525 / 60
    Reward := Len * 0.5
    SetFormat, float, 0.2
    Minute += 0
    SetFormat, float, 0.0
    Reward += 0
    SetFormat, float, 6.2
    SB_SetText("　本次發表文章約需 " . Minute . " 分，約可獲得 " . Reward . " P。", 2)

    LastContent := ""

    Loop, %Len%
    {
        PtrContent := *Ptr

        If (StrLen(LastContent) > 0 && PtrContent != LastContent) {
            Random, Interval, 500, 550
            Sleep, %Interval%
        }

        If (PtrContent = 0xA || PtrContent = 0xD) {
            PostMessage, WM_CHAR, 0xD, , %ControlName%, ahk_id %WindowID%
            PostMessage, WM_CHAR, 0xA, , %ControlName%, ahk_id %WindowID%
        } Else {
            PostMessage, WM_CHAR, PtrContent, , %ControlName%, ahk_id %WindowID%
        }

        LastContent := PtrContent
        Ptr++

        Stat := (Ptr - &Content) / Len * 100
        SetFormat, float, 0.2
        Stat += 0
        SetFormat, float, 6.2
        SB_SetText("　已完成 " . Stat . " %", 1)
    }

    SB_SetText("　閒置")
    MsgBox, 完成。
}


; HyperLink hover effect
HandleMessage(p_w, p_l, p_m, p_hw)
  {
    global   WM_SETCURSOR, WM_MOUSEMOVE,
    static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl

    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {
        ; Mouse cursor hovers URL text control
        StringLeft, CtrlIsURL, A_GuiControl, 3
        If (CtrlIsURL = "URL")
          {
            If URL_hover=
              {
                Gui, Font, cBlue underline
                GuiControl, Font, %A_GuiControl%
                LastCtrl = %A_GuiControl%

                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)

                URL_hover := true
              }
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }
        ; Mouse cursor doesn't hover URL text control
        Else
          {
            If URL_hover
              {
                Gui, Font, norm cBlue
                GuiControl, Font, %LastCtrl%

                DllCall("SetCursor", "uint", h_old_cursor)

                URL_hover=
              }
          }
      }
}


; Customize GUI edit background
WindowProc(hwnd, uMsg, wParam, lParam)
{
    Critical
    global EditBackgroundColor, EditBackgroundBrush, WindowProcOld
    if (uMsg = 0x138 && lParam = A_EventInfo)  ; 0x138 is WM_CTLCOLORSTATIC.
    {
        DllCall("SetBkColor", UInt, wParam, UInt, EditBackgroundColor)
        return EditBackgroundBrush  ; Return the HBRUSH to notify the OS that we altered the HDC.
    }
    ; Otherwise (since above didn't return), pass all unhandled events to the original WindowProc.
    return DllCall("CallWindowProcA", UInt, WindowProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)
}
