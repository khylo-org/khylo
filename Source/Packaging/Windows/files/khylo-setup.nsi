; Khylo Server for Windows: the installer. Built with NSIS (makensis) by Source/Packaging/Windows/Dockerfile; run
; Source/Packaging/Windows/build.sh instead of calling this directly.
;
; Defines passed on the makensis command line: VERSION (26.11.02.01), VIVERSION (26.11.2.1), ARCH (x64 or arm64), OUTFILE.
;
; What it does: copies Khylo to Program Files, keeps the library and settings in C:\ProgramData\Khylo, starts Khylo when
; the PC starts (a scheduled task named "Khylo Server" that starts it again within five minutes if it ever stops), opens the firewall for the web
; app (8096) and for apps finding the server (7360), and adds Start Menu entries and an entry in Windows' Installed apps.
; Running it again updates Khylo and keeps the library and settings.
;
; Silent install: khylo-server-...-setup.exe /S   (a first install runs as the system account; an update keeps the startup task as it is; add /D=C:\somewhere\Khylo to choose the folder)
; Silent uninstall: "C:\Program Files\Khylo\Uninstall.exe" /S   (keeps the library and settings)

Unicode true
SetCompressor /SOLID lzma
RequestExecutionLevel admin

!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

!ifndef BUILD
  !define BUILD "DEV"
!endif
!ifndef VERSION
  !define VERSION "0.0.0"
!endif
!ifndef VIVERSION
  !define VIVERSION "0.0.0.0"
!endif
!ifndef ARCH
  !define ARCH "x64"
!endif
!ifndef OUTFILE
  !define OUTFILE "khylo-server-setup.exe"
!endif

!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Khylo"
!define TASK_NAME "Khylo Server"
!define WEB_URL "http://localhost:8096"

Name "Khylo Server"
OutFile "${OUTFILE}"
BrandingText "Khylo Server ${BUILD}"
InstallDir "$PROGRAMFILES64\Khylo"

VIProductVersion "${VIVERSION}"
VIAddVersionKey "ProductName" "Khylo Server"
VIAddVersionKey "CompanyName" "Khylo"
VIAddVersionKey "FileDescription" "Khylo Server setup"
VIAddVersionKey "FileVersion" "${BUILD}"
VIAddVersionKey "ProductVersion" "${BUILD}"
VIAddVersionKey "LegalCopyright" "Khylo is free software, released under the GNU General Public License"

!define MUI_ICON "khylo.ico"
!define MUI_UNICON "khylo.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "This sets up Khylo Server on this PC. Khylo starts with Windows and keeps running in the background, so your library is always ready.$\r$\n$\r$\nYour library and settings are kept in C:\ProgramData\Khylo and are never touched by updates.$\r$\n$\r$\nClick Next to continue."
!define MUI_FINISHPAGE_TITLE "Khylo is installed"
!define MUI_FINISHPAGE_TEXT "Khylo is starting. The first start can take a minute.$\r$\n$\r$\nOpen it in your browser to finish setup. To use it from other devices, open http://<this PC's address>:8096."
!define MUI_FINISHPAGE_RUN ""
!define MUI_FINISHPAGE_RUN_TEXT "Open Khylo in my web browser"
!define MUI_FINISHPAGE_RUN_FUNCTION OpenKhylo

Var AccountDialog
Var RadioLogon
Var RadioSystem
Var RadioUser
Var RunMode
Var UserBox
Var PasswordBox
Var RunAsUser
Var RunAsPassword
Var ProblemText

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirectoryLeave
!insertmacro MUI_PAGE_DIRECTORY
Page custom AccountPage AccountPageLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; ---- Start --------------------------------------------------------------------------------------------------------------

Function .onInit
  SetRegView 64
  ; The Arm download only runs on Arm PCs; the Intel/AMD one also runs on Arm PCs
  !if "${ARCH}" == "arm64"
    ${If} ${IsNativeAMD64}
      MessageBox MB_OK|MB_ICONSTOP "This is the download for Arm PCs. Please download the Intel/AMD one (the file with x64 in its name)."
      Abort
    ${EndIf}
  !endif
  ; An update goes to the folder Khylo is already in
  ReadRegStr $0 HKLM "Software\Khylo" "InstallDir"
  ${If} $0 != ""
    StrCpy $INSTDIR $0
  ${EndIf}
  ExpandEnvStrings $RunAsUser "%USERDOMAIN%\%USERNAME%"
FunctionEnd

; Khylo always lives in a folder called Khylo, so the uninstaller can remove the whole folder safely
Function EnsureKhyloFolder
  StrCpy $0 $INSTDIR 5 -5
  ${If} $0 != "Khylo"
    StrCpy $INSTDIR "$INSTDIR\Khylo"
  ${EndIf}
FunctionEnd

Function DirectoryLeave
  Call EnsureKhyloFolder
FunctionEnd

; ---- Who Khylo runs as ---------------------------------------------------------------------------------------------------

Function AccountPage
  !insertmacro MUI_HEADER_TEXT "How should Khylo run?" "Choose this once. You can run this setup again to change it."
  nsDialogs::Create 1018
  Pop $AccountDialog

  ${NSD_CreateRadioButton} 0 0 100% 11u "As the system, starting with the PC (recommended)"
  Pop $RadioSystem
  ${NSD_AddStyle} $RadioSystem ${WS_GROUP}
  ${NSD_CreateLabel} 12u 11u 94% 22u "Khylo starts before anyone logs in and keeps running. In the folder picker, the network drives mapped on this PC are listed so you can connect each one with a click."
  Pop $0

  ${NSD_CreateRadioButton} 0 36u 100% 11u "As me, while I'm logged in"
  Pop $RadioLogon
  ${NSD_CreateLabel} 12u 47u 94% 22u "Khylo runs in your own session, so your mapped drive letters (X:, Y:) work directly. It only runs while you are logged in."
  Pop $0

  ${NSD_CreateRadioButton} 0 72u 100% 11u "As me, even when I'm logged out"
  Pop $RadioUser
  ${NSD_CreateLabel} 12u 83u 94% 22u "Starts with the PC and needs your Windows password once. Uses addresses like \\nas\Movies, not drive letters."
  Pop $0

  ${NSD_CreateLabel} 0 110u 34u 10u "Account:"
  Pop $0
  ${NSD_CreateText} 36u 108u 130u 12u "$RunAsUser"
  Pop $UserBox
  ${NSD_CreateLabel} 0 126u 34u 10u "Password:"
  Pop $0
  ${NSD_CreatePassword} 36u 124u 130u 12u ""
  Pop $PasswordBox
  ${NSD_CreateLabel} 172u 126u 120u 10u "(only for the third choice)"
  Pop $0

  ${NSD_Check} $RadioSystem
  nsDialogs::Show
FunctionEnd

Function AccountPageLeave
  StrCpy $RunMode "system"
  ${NSD_GetState} $RadioLogon $0
  ${NSD_GetState} $RadioUser $1
  ${If} $0 == ${BST_CHECKED}
    StrCpy $RunMode "logon"
    ${NSD_GetText} $UserBox $RunAsUser
    StrCpy $RunAsPassword ""
    ${If} $RunAsUser == ""
      MessageBox MB_OK|MB_ICONEXCLAMATION "Please enter your Windows account, or choose a different way to run Khylo."
      Abort
    ${EndIf}
  ${ElseIf} $1 == ${BST_CHECKED}
    StrCpy $RunMode "always"
    ${NSD_GetText} $UserBox $RunAsUser
    ${NSD_GetText} $PasswordBox $RunAsPassword
    ${If} $RunAsUser == ""
    ${OrIf} $RunAsPassword == ""
      MessageBox MB_OK|MB_ICONEXCLAMATION "Please enter your Windows account and password, or choose a different way to run Khylo."
      Abort
    ${EndIf}
  ${Else}
    StrCpy $RunAsUser ""
    StrCpy $RunAsPassword ""
  ${EndIf}
FunctionEnd

; ---- Install --------------------------------------------------------------------------------------------------------------

Section "Khylo Server" SecMain
  SetShellVarContext all
  SetRegView 64
  Call EnsureKhyloFolder
  ${If} ${Silent}
    StrCpy $RunMode "system"
    StrCpy $RunAsUser ""
    StrCpy $RunAsPassword ""
  ${EndIf}

  ; An update: stop the running copy first, and clear out the old program files (the library and settings live elsewhere)
  DetailPrint "Stopping Khylo if it is running..."
  nsExec::ExecToLog 'schtasks /End /TN "${TASK_NAME}"'
  Pop $0
  Sleep 3000
  ${If} ${FileExists} "$INSTDIR\khylo.exe"
    RMDir /r "$INSTDIR"
  ${EndIf}

  DetailPrint "Copying Khylo..."
  SetOutPath "$INSTDIR"
  File /r "Khylo\*.*"
  File "khylo.ico"

  ; The library, settings, cache and logs live apart from the program, so updates never touch them
  CreateDirectory "$APPDATA\Khylo"
  CreateDirectory "$APPDATA\Khylo\data"
  CreateDirectory "$APPDATA\Khylo\config"
  CreateDirectory "$APPDATA\Khylo\cache"
  CreateDirectory "$APPDATA\Khylo\log"
  ${If} $RunAsUser != ""
    nsExec::ExecToLog 'icacls "$APPDATA\Khylo" /grant "$RunAsUser:(OI)(CI)F" /T /C /Q'
    Pop $0
  ${EndIf}

  ; A silent update (Khylo updating itself) keeps the startup task as it is, so the account it runs as is not changed
  ${If} ${Silent}
    nsExec::ExecToStack 'schtasks /Query /TN "${TASK_NAME}"'
    Pop $0
    ${If} $0 == 0
      DetailPrint "Keeping the existing startup task"
    ${Else}
      Call CreateStartupTask
    ${EndIf}
  ${Else}
    Call CreateStartupTask
  ${EndIf}
  Call OpenFirewall

  ; Start Menu, and the entry in Windows' Installed apps
  CreateDirectory "$SMPROGRAMS\Khylo"
  WriteINIStr "$SMPROGRAMS\Khylo\Open Khylo.url" "InternetShortcut" "URL" "${WEB_URL}"
  WriteINIStr "$SMPROGRAMS\Khylo\Open Khylo.url" "InternetShortcut" "IconFile" "$INSTDIR\khylo.ico"
  WriteINIStr "$SMPROGRAMS\Khylo\Open Khylo.url" "InternetShortcut" "IconIndex" "0"
  CreateShortcut "$SMPROGRAMS\Khylo\Uninstall Khylo.lnk" "$INSTDIR\Uninstall.exe"

  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Khylo" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayName" "Khylo Server"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayVersion" "${BUILD}"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "Publisher" "Khylo"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\khylo.ico"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM "${UNINSTALL_KEY}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'
  WriteRegStr HKLM "${UNINSTALL_KEY}" "URLInfoAbout" "https://github.com/khylo-org/khylo"
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoModify" 1
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "NoRepair" 1
  SectionGetSize ${SecMain} $0
  WriteRegDWORD HKLM "${UNINSTALL_KEY}" "EstimatedSize" $0

  DetailPrint "Starting Khylo..."
  nsExec::ExecToLog 'schtasks /Run /TN "${TASK_NAME}"'
  Pop $0
  Call WaitForKhylo
SectionEnd

; Starts with the PC (or at login) and starts again within five minutes if it ever stops
Function CreateStartupTask
  GetTempFileName $1
  FileOpen $0 $1 w
  FileWriteUTF16LE /BOM $0 '<?xml version="1.0" encoding="UTF-16"?>$\r$\n'
  FileWriteUTF16LE $0 '<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">$\r$\n'
  FileWriteUTF16LE $0 '  <RegistrationInfo><Description>Khylo Server</Description></RegistrationInfo>$\r$\n'
  ${If} $RunMode == "logon"
    ; In the user's own desktop session, so the network drives mapped to their login are there
    FileWriteUTF16LE $0 '  <Triggers><LogonTrigger><Enabled>true</Enabled><UserId>$RunAsUser</UserId></LogonTrigger><TimeTrigger><StartBoundary>2026-01-01T00:00:00</StartBoundary><Enabled>true</Enabled><Repetition><Interval>PT5M</Interval></Repetition></TimeTrigger></Triggers>$\r$\n'
    FileWriteUTF16LE $0 '  <Principals><Principal id="Author"><UserId>$RunAsUser</UserId><LogonType>InteractiveToken</LogonType><RunLevel>LeastPrivilege</RunLevel></Principal></Principals>$\r$\n'
  ${Else}
    ; At boot, and then every five minutes: if Khylo ever stops (for example the disk was full), the next check starts it again
    FileWriteUTF16LE $0 '  <Triggers><BootTrigger><Enabled>true</Enabled></BootTrigger><TimeTrigger><StartBoundary>2026-01-01T00:00:00</StartBoundary><Enabled>true</Enabled><Repetition><Interval>PT5M</Interval></Repetition></TimeTrigger></Triggers>$\r$\n'
    ${If} $RunMode == "always"
      FileWriteUTF16LE $0 '  <Principals><Principal id="Author"><UserId>$RunAsUser</UserId><LogonType>Password</LogonType><RunLevel>HighestAvailable</RunLevel></Principal></Principals>$\r$\n'
    ${Else}
      FileWriteUTF16LE $0 '  <Principals><Principal id="Author"><UserId>S-1-5-18</UserId><RunLevel>HighestAvailable</RunLevel></Principal></Principals>$\r$\n'
    ${EndIf}
  ${EndIf}
  FileWriteUTF16LE $0 '  <Settings>$\r$\n'
  FileWriteUTF16LE $0 '    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>$\r$\n'
  FileWriteUTF16LE $0 '    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>$\r$\n'
  FileWriteUTF16LE $0 '    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>$\r$\n'
  FileWriteUTF16LE $0 '    <AllowHardTerminate>true</AllowHardTerminate>$\r$\n'
  FileWriteUTF16LE $0 '    <StartWhenAvailable>true</StartWhenAvailable>$\r$\n'
  FileWriteUTF16LE $0 '    <AllowStartOnDemand>true</AllowStartOnDemand>$\r$\n'
  FileWriteUTF16LE $0 '    <Enabled>true</Enabled>$\r$\n'
  FileWriteUTF16LE $0 '    <Hidden>false</Hidden>$\r$\n'
  FileWriteUTF16LE $0 '    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>$\r$\n'
  FileWriteUTF16LE $0 '    <Priority>7</Priority>$\r$\n'
  FileWriteUTF16LE $0 '    <RestartOnFailure><Interval>PT1M</Interval><Count>999</Count></RestartOnFailure>$\r$\n'
  FileWriteUTF16LE $0 '  </Settings>$\r$\n'
  FileWriteUTF16LE $0 '  <Actions Context="Author"><Exec>$\r$\n'
  ${If} $RunMode == "logon"
    ; Khylo is a console program; in a desktop session it is started hidden so no black window sits on the screen
    FileWriteUTF16LE $0 '    <Command>powershell.exe</Command>$\r$\n'
    FileWriteUTF16LE $0 `    <Arguments>-NoProfile -WindowStyle Hidden -Command "&amp; '$INSTDIR\khylo.exe' --service --webdir '$INSTDIR\web' --ffmpeg '$INSTDIR\ffmpeg\ffmpeg.exe' --datadir '$APPDATA\Khylo\data' --configdir '$APPDATA\Khylo\config' --cachedir '$APPDATA\Khylo\cache' --logdir '$APPDATA\Khylo\log'"</Arguments>$\r$\n`
  ${Else}
    FileWriteUTF16LE $0 '    <Command>$INSTDIR\khylo.exe</Command>$\r$\n'
    FileWriteUTF16LE $0 '    <Arguments>--service --webdir "$INSTDIR\web" --ffmpeg "$INSTDIR\ffmpeg\ffmpeg.exe" --datadir "$APPDATA\Khylo\data" --configdir "$APPDATA\Khylo\config" --cachedir "$APPDATA\Khylo\cache" --logdir "$APPDATA\Khylo\log"</Arguments>$\r$\n'
  ${EndIf}
  FileWriteUTF16LE $0 '    <WorkingDirectory>$INSTDIR</WorkingDirectory>$\r$\n'
  FileWriteUTF16LE $0 '  </Exec></Actions>$\r$\n'
  FileWriteUTF16LE $0 '</Task>$\r$\n'
  FileClose $0

  DetailPrint "Setting Khylo to start with Windows..."
  ${If} $RunMode == "always"
    nsExec::ExecToStack 'schtasks /Create /TN "${TASK_NAME}" /XML "$1" /RU "$RunAsUser" /RP "$RunAsPassword" /F'
  ${Else}
    nsExec::ExecToStack 'schtasks /Create /TN "${TASK_NAME}" /XML "$1" /F'
  ${EndIf}
  Pop $2
  Pop $ProblemText
  Delete $1
  ${If} $2 != 0
    DetailPrint "Windows would not set up the startup task: $ProblemText"
    MessageBox MB_OK|MB_ICONSTOP "Khylo's files are in place, but Windows would not set Khylo to start with the PC:$\r$\n$\r$\n$ProblemText$\r$\nRun this setup again to retry (check the account name and password if you chose your Windows account)."
    Abort
  ${EndIf}
FunctionEnd

; Firewall: the web app and apps finding the server, on private and work networks
Function OpenFirewall
  DetailPrint "Opening the firewall for Khylo..."
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="Khylo Server (web)"'
  Pop $0
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="Khylo Server (discovery)"'
  Pop $0
  nsExec::ExecToLog 'netsh advfirewall firewall add rule name="Khylo Server (web)" dir=in action=allow protocol=TCP localport=8096 profile=private,domain'
  Pop $0
  nsExec::ExecToLog 'netsh advfirewall firewall add rule name="Khylo Server (discovery)" dir=in action=allow protocol=UDP localport=7360 profile=private,domain'
  Pop $0
FunctionEnd

; Waits (up to a minute) for Khylo to answer, so the Finish page opens a page that works
Function WaitForKhylo
  DetailPrint "Waiting for Khylo to start..."
  StrCpy $3 0
  ${Do}
    nsExec::ExecToStack 'curl.exe -s -o nul -w "%{http_code}" --max-time 3 http://localhost:8096/health'
    Pop $0
    Pop $1
    ${If} $1 == "200"
      DetailPrint "Khylo is running."
      ${Break}
    ${EndIf}
    Sleep 2000
    IntOp $3 $3 + 1
  ${LoopUntil} $3 >= 30
  ${If} $1 != "200"
    DetailPrint "Khylo has not answered yet. Give it a minute, then open ${WEB_URL}. Logs are in $APPDATA\Khylo\log."
  ${EndIf}
FunctionEnd

Function OpenKhylo
  ExecShell "open" "${WEB_URL}"
FunctionEnd

; ---- Uninstall ------------------------------------------------------------------------------------------------------------

Section "Uninstall"
  SetShellVarContext all
  SetRegView 64

  DetailPrint "Stopping Khylo..."
  nsExec::ExecToLog 'schtasks /End /TN "${TASK_NAME}"'
  Pop $0
  nsExec::ExecToLog 'schtasks /Delete /TN "${TASK_NAME}" /F'
  Pop $0
  Sleep 3000

  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="Khylo Server (web)"'
  Pop $0
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="Khylo Server (discovery)"'
  Pop $0

  Delete "$SMPROGRAMS\Khylo\Open Khylo.url"
  Delete "$SMPROGRAMS\Khylo\Uninstall Khylo.lnk"
  RMDir "$SMPROGRAMS\Khylo"

  DeleteRegKey HKLM "${UNINSTALL_KEY}"
  DeleteRegKey HKLM "Software\Khylo"

  ; Only ever the Khylo folder (the installer makes sure the folder is called Khylo)
  RMDir /r "$INSTDIR"

  ${IfNot} ${Silent}
    MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "Also delete your Khylo library, users and settings in $APPDATA\Khylo?$\r$\n$\r$\nThis cannot be undone. Choose No to keep them (for example if you plan to install Khylo again)." IDNO keepData
    ; A library holds tens of thousands of small files (artwork, metadata); NSIS deletes them one by one and shows nothing,
    ; which looks frozen. Windows' robocopy empties a folder in parallel, many times faster.
    DetailPrint "Deleting your library, users and settings (this can take a few minutes)..."
    CreateDirectory "$TEMP\khylo-empty"
    nsExec::ExecToLog 'robocopy "$TEMP\khylo-empty" "$APPDATA\Khylo" /MIR /MT:64 /R:0 /W:0 /NFL /NDL /NJH /NJS /NP'
    Pop $0
    RMDir "$TEMP\khylo-empty"
    ; whatever robocopy could not remove (a locked file): the plain way
    RMDir /r "$APPDATA\Khylo"
    keepData:
  ${EndIf}
SectionEnd
