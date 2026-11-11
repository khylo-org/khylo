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
; Silent install: khylo-server-...-setup.exe /S   (a first install runs as the limited service account; an update keeps how Khylo already runs; add /D=C:\somewhere\Khylo to choose the folder)
;
; How Khylo runs (the "Account" page): as the limited LocalService account (recommended: if Khylo were ever broken into, the rest of the PC
; is not), as the system (full access, what earlier versions did), or as a Windows account. When Khylo itself can't install updates (every
; way except the system) a second task, "Khylo Update Helper", runs as the system every two minutes and installs an update the server has
; staged, after checking its signature and checksum again (khylo.exe --apply-update; it ends at once when nothing is waiting).
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
!define HELPER_TASK_NAME "Khylo Update Helper"
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
Var RadioLimited
Var PreviousMode
Var RunMode
Var UserBox
Var PasswordBox
Var RunAsUser
Var RunAsPassword
Var ProblemText
Var DataAcl

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
      MessageBox MB_OK|MB_ICONSTOP "This is the download for Arm PCs. Please download the Intel/AMD one (the file with x64 in its name)." /SD IDOK
      Abort
    ${EndIf}
  !endif
  ; An update goes to the folder Khylo is already in
  ReadRegStr $0 HKLM "Software\Khylo" "InstallDir"
  ${If} $0 != ""
    StrCpy $INSTDIR $0
  ${EndIf}
  ; How an earlier install ran Khylo. An install that didn't write this down (older versions) ran as the system.
  ReadRegStr $PreviousMode HKLM "Software\Khylo" "RunMode"
  ${If} $PreviousMode == ""
  ${AndIf} $0 != ""
    StrCpy $PreviousMode "system"
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

  ${NSD_CreateRadioButton} 0 0 100% 11u "As a limited account made for services (recommended)"
  Pop $RadioLimited
  ${NSD_AddStyle} $RadioLimited ${WS_GROUP}
  ${NSD_CreateLabel} 12u 11u 94% 17u "Khylo starts with the PC, and if anyone ever broke into it they would not get the whole PC. Network folders use the login you give Khylo for them."
  Pop $0

  ${NSD_CreateRadioButton} 0 30u 100% 11u "As the system (full access, how earlier versions ran)"
  Pop $RadioSystem
  ${NSD_CreateLabel} 12u 41u 94% 17u "Khylo can open any folder. In the folder picker, the network drives mapped on this PC are listed so you can connect each one with a click."
  Pop $0

  ${NSD_CreateRadioButton} 0 60u 100% 11u "As me, while I'm logged in"
  Pop $RadioLogon
  ${NSD_CreateLabel} 12u 71u 94% 17u "Khylo runs in your own session, so your mapped drive letters (X:, Y:) work directly. It only runs while you are logged in."
  Pop $0

  ${NSD_CreateRadioButton} 0 90u 100% 11u "As me, even when I'm logged out"
  Pop $RadioUser
  ${NSD_CreateLabel} 12u 101u 94% 17u "Starts with the PC and needs your Windows password once (below). Uses addresses like \\nas\Movies, not drive letters."
  Pop $0

  ${NSD_CreateLabel} 0 122u 30u 10u "Account:"
  Pop $0
  ${NSD_CreateText} 30u 120u 100u 12u "$RunAsUser"
  Pop $UserBox
  ${NSD_CreateLabel} 136u 122u 34u 10u "Password:"
  Pop $0
  ${NSD_CreatePassword} 172u 120u 80u 12u ""
  Pop $PasswordBox

  ; An install that is run again keeps the way it ran, so nothing changes unless it is chosen here
  ${If} $PreviousMode == "system"
    ${NSD_Check} $RadioSystem
  ${ElseIf} $PreviousMode == "logon"
    ${NSD_Check} $RadioLogon
  ${ElseIf} $PreviousMode == "always"
    ${NSD_Check} $RadioUser
  ${Else}
    ${NSD_Check} $RadioLimited
  ${EndIf}
  nsDialogs::Show
FunctionEnd

Function AccountPageLeave
  StrCpy $RunMode "system"
  ${NSD_GetState} $RadioLogon $0
  ${NSD_GetState} $RadioUser $1
  ${NSD_GetState} $RadioLimited $2
  ${If} $2 == ${BST_CHECKED}
    StrCpy $RunMode "limited"
    StrCpy $RunAsUser ""
    StrCpy $RunAsPassword ""
  ${ElseIf} $0 == ${BST_CHECKED}
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
    ; An update keeps how Khylo already runs; a first silent install gets the limited account
    ${If} $PreviousMode == ""
      StrCpy $RunMode "limited"
    ${Else}
      StrCpy $RunMode $PreviousMode
    ${EndIf}
    StrCpy $RunAsUser ""
    StrCpy $RunAsPassword ""
  ${EndIf}

  ; An update: stop the running copy first, and clear out the old program files (the library and settings live elsewhere)
  DetailPrint "Stopping Khylo if it is running..."
  nsExec::ExecToLog 'schtasks /End /TN "${TASK_NAME}"'
  Pop $0
  ; The update helper runs khylo.exe, which can't be replaced while it runs: stopped and removed here, set up again below
  nsExec::ExecToLog 'schtasks /End /TN "${HELPER_TASK_NAME}"'
  Pop $0
  nsExec::ExecToLog 'schtasks /Delete /TN "${HELPER_TASK_NAME}" /F'
  Pop $0
  Sleep 3000
  ${If} ${FileExists} "$INSTDIR\khylo.exe"
    RMDir /r "$INSTDIR"
  ${EndIf}

  DetailPrint "Copying Khylo..."
  SetOutPath "$INSTDIR"
  File /r "Khylo\*.*"
  File "khylo.ico"

  ; The program folder is for administrators to change; everyone else may only read and run it. The update helper runs khylo.exe from
  ; here as the system, so the account Khylo runs as (and every other user) must not be able to replace it, whichever folder was chosen.
  ; Anything set by hand on the folder itself is cleared first, then nothing is inherited and only these three are listed.
  nsExec::ExecToLog 'icacls "$INSTDIR" /reset /Q'
  Pop $0
  nsExec::ExecToLog 'icacls "$INSTDIR" /inheritance:r /grant:r *S-1-5-18:(OI)(CI)F *S-1-5-32-544:(OI)(CI)F *S-1-5-32-545:(OI)(CI)RX /Q'
  Pop $0

  ; Where the system keeps what an update needs (its copy of the installer, the update script and the backup). It sits beside Khylo's
  ; folder, not inside it, because the account Khylo runs as can change everything inside that one. A link left in its place is removed
  ; (never followed), then the folder is owned by the administrators and open only to them and the system.
  RMDir "$APPDATA\KhyloUpdate"
  CreateDirectory "$APPDATA\KhyloUpdate"
  nsExec::ExecToLog 'icacls "$APPDATA\KhyloUpdate" /setowner *S-1-5-32-544 /Q'
  Pop $0
  nsExec::ExecToLog 'icacls "$APPDATA\KhyloUpdate" /inheritance:r /grant:r *S-1-5-18:(OI)(CI)F *S-1-5-32-544:(OI)(CI)F /Q'
  Pop $0

  ; The library, settings, cache and logs live apart from the program, so updates never touch them
  CreateDirectory "$APPDATA\Khylo"
  CreateDirectory "$APPDATA\Khylo\data"
  CreateDirectory "$APPDATA\Khylo\config"
  CreateDirectory "$APPDATA\Khylo\cache"
  CreateDirectory "$APPDATA\Khylo\cache\update-stage"
  CreateDirectory "$APPDATA\Khylo\log"
  ${If} $RunAsUser != ""
    nsExec::ExecToLog 'icacls "$APPDATA\Khylo" /grant "$RunAsUser:(OI)(CI)F" /T /C /Q'
    Pop $0
  ${EndIf}

  ; Khylo's folders hold the library, every login and the plug-ins and updates Khylo runs, so only administrators (and the
  ; account Khylo runs as, granted above or by an earlier install) may open them. ProgramData's default lets every user on
  ; this PC read them and add files to them. One command takes the inherited everyone-groups out and lists the owners. Windows
  ; has to rewrite the permissions on every file inside, which on a big library (artwork, thumbnails, trickplay: a million files)
  ; takes minutes the first time an older install is updated, and nothing the second time. So unless Khylo runs as the limited
  ; account (a new install, an empty folder), it runs in the background and Khylo starts straight away instead of waiting for it.
  ; The limited account (LocalService) may read and change what is inside, but not who else can open it (Modify, not Full
  ; control). Any other way of running drops that entry.
  DetailPrint "Making Khylo's folders private to administrators..."
  ${If} $RunMode == "limited"
    StrCpy $DataAcl 'icacls "$APPDATA\Khylo" /inheritance:r /grant:r "*S-1-5-18:(OI)(CI)F" "*S-1-5-32-544:(OI)(CI)F" "*S-1-5-19:(OI)(CI)M" /Q'
    nsExec::ExecToLog '$DataAcl'
    Pop $0
  ${Else}
    StrCpy $DataAcl 'icacls "$APPDATA\Khylo" /inheritance:r /grant:r "*S-1-5-18:(OI)(CI)F" "*S-1-5-32-544:(OI)(CI)F" /remove:g "*S-1-5-19" /Q'
    ExecShell "open" "$SYSDIR\cmd.exe" '/c $DataAcl' SW_HIDE
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
  Call CreateUpdateHelperTask
  Call OpenFirewall

  ; Start Menu, and the entry in Windows' Installed apps
  CreateDirectory "$SMPROGRAMS\Khylo"
  WriteINIStr "$SMPROGRAMS\Khylo\Open Khylo.url" "InternetShortcut" "URL" "${WEB_URL}"
  WriteINIStr "$SMPROGRAMS\Khylo\Open Khylo.url" "InternetShortcut" "IconFile" "$INSTDIR\khylo.ico"
  WriteINIStr "$SMPROGRAMS\Khylo\Open Khylo.url" "InternetShortcut" "IconIndex" "0"
  CreateShortcut "$SMPROGRAMS\Khylo\Uninstall Khylo.lnk" "$INSTDIR\Uninstall.exe"

  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Khylo" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "Software\Khylo" "RunMode" "$RunMode"
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
    ${ElseIf} $RunMode == "limited"
      ; The built-in LocalService account (S-1-5-19): no password, and none of the rights of the system
      FileWriteUTF16LE $0 '  <Principals><Principal id="Author"><UserId>S-1-5-19</UserId></Principal></Principals>$\r$\n'
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
    MessageBox MB_OK|MB_ICONSTOP "Khylo's files are in place, but Windows would not set Khylo to start with the PC:$\r$\n$\r$\n$ProblemText$\r$\nRun this setup again to retry (check the account name and password if you chose your Windows account)." /SD IDOK
    Abort
  ${EndIf}
FunctionEnd

; The update helper: a task that runs as the system every two minutes and installs an update the server has staged (khylo.exe
; --apply-update). It ends at once when nothing is waiting. It is only needed when Khylo itself can't install updates, which is every
; way of running except as the system; it re-checks the update's signature and checksum itself and only installs a newer build.
Function CreateUpdateHelperTask
  ${If} $RunMode == "system"
    DeleteRegValue HKLM "Software\Khylo" "UpdateHelper"
    Return
  ${EndIf}
  GetTempFileName $1
  FileOpen $0 $1 w
  FileWriteUTF16LE /BOM $0 '<?xml version="1.0" encoding="UTF-16"?>$\r$\n'
  FileWriteUTF16LE $0 '<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">$\r$\n'
  FileWriteUTF16LE $0 '  <RegistrationInfo><Description>Installs the Khylo update the server has staged, after checking it again. Does nothing when no update is waiting.</Description></RegistrationInfo>$\r$\n'
  FileWriteUTF16LE $0 '  <Triggers><TimeTrigger><StartBoundary>2026-01-01T00:00:00</StartBoundary><Enabled>true</Enabled><Repetition><Interval>PT2M</Interval></Repetition></TimeTrigger></Triggers>$\r$\n'
  FileWriteUTF16LE $0 '  <Principals><Principal id="Author"><UserId>S-1-5-18</UserId><RunLevel>HighestAvailable</RunLevel></Principal></Principals>$\r$\n'
  FileWriteUTF16LE $0 '  <Settings>$\r$\n'
  FileWriteUTF16LE $0 '    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>$\r$\n'
  FileWriteUTF16LE $0 '    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>$\r$\n'
  FileWriteUTF16LE $0 '    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>$\r$\n'
  FileWriteUTF16LE $0 '    <AllowHardTerminate>true</AllowHardTerminate>$\r$\n'
  FileWriteUTF16LE $0 '    <StartWhenAvailable>true</StartWhenAvailable>$\r$\n'
  FileWriteUTF16LE $0 '    <AllowStartOnDemand>true</AllowStartOnDemand>$\r$\n'
  FileWriteUTF16LE $0 '    <Enabled>true</Enabled>$\r$\n'
  FileWriteUTF16LE $0 '    <Hidden>true</Hidden>$\r$\n'
  FileWriteUTF16LE $0 '    <ExecutionTimeLimit>PT10M</ExecutionTimeLimit>$\r$\n'
  FileWriteUTF16LE $0 '    <Priority>7</Priority>$\r$\n'
  FileWriteUTF16LE $0 '  </Settings>$\r$\n'
  FileWriteUTF16LE $0 '  <Actions Context="Author"><Exec>$\r$\n'
  FileWriteUTF16LE $0 '    <Command>$INSTDIR\khylo.exe</Command>$\r$\n'
  FileWriteUTF16LE $0 '    <Arguments>--apply-update --cachedir "$APPDATA\Khylo\cache"</Arguments>$\r$\n'
  FileWriteUTF16LE $0 '    <WorkingDirectory>$INSTDIR</WorkingDirectory>$\r$\n'
  FileWriteUTF16LE $0 '  </Exec></Actions>$\r$\n'
  FileWriteUTF16LE $0 '</Task>$\r$\n'
  FileClose $0
  DetailPrint "Setting up the update helper..."
  nsExec::ExecToStack 'schtasks /Create /TN "${HELPER_TASK_NAME}" /XML "$1" /F'
  Pop $2
  Pop $ProblemText
  Delete $1
  ${If} $2 != 0
    DetailPrint "Windows would not set up the update helper: $ProblemText"
    DeleteRegValue HKLM "Software\Khylo" "UpdateHelper"
  ${Else}
    WriteRegDWORD HKLM "Software\Khylo" "UpdateHelper" 1
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
  nsExec::ExecToLog 'schtasks /End /TN "${HELPER_TASK_NAME}"'
  Pop $0
  nsExec::ExecToLog 'schtasks /Delete /TN "${HELPER_TASK_NAME}" /F'
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
  RMDir /r "$APPDATA\KhyloUpdate"

  ${IfNot} ${Silent}
    MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 "Also delete your Khylo library, users and settings in $APPDATA\Khylo?$\r$\n$\r$\nThis cannot be undone. Choose No to keep them (for example if you plan to install Khylo again)." /SD IDNO IDNO keepData
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
