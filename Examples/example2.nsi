; example2.nsi
;
; This script is based on example1.nsi but it remembers the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects.
;
; See install-shared.nsi for a more robust way of checking for administrator rights.
; See install-per-user.nsi for a file association example.

;--------------------------------

; The name of the installer
Name "Example2"

; The file to write
OutFile "example2.exe"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES\Example2

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NSIS_Example2" "Install_Dir"

!include "LogicLib.nsh"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Section

  StrCpy $1 "YOURAPP.exe"

  nsProcess::_FindProcess "$1"
  Pop $R0
  ${If} $R0 = 0
    nsProcess::_KillProcess "$1"
    Pop $R0

    Sleep 500
  ${EndIf}

  ; Check if the service is running
  SimpleSC::ServiceIsRunning "MyService"
  Pop $0
  Pop $1

  ; Check if the firewall is enabled
  SimpleFC::IsFirewallEnabled
  Pop $0
  Pop $1

  ; HTTP Get
  NSxfer::Transfer /URL "https://httpbin.org/get?param1=1&param2=2" /LOCAL "$TEMP\Response.json" /END
  Pop $0  ; "OK" for success

SectionEnd

; The stuff to install
Section "Example2 (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  CreateDirectory "$INSTDIR\Data"
  AccessControl::GrantOnFile \
      "$INSTDIR\Data" "(BU)" "GenericRead + GenericWrite"
  Pop $0
  
  ; Put file there
  File "example2.nsi"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_Example2 "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2" "DisplayName" "NSIS Example2"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Example2"
  CreateShortcut "$SMPROGRAMS\Example2\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortcut "$SMPROGRAMS\Example2\Example2 (MakeNSISW).lnk" "$INSTDIR\example2.nsi"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Example2"
  DeleteRegKey HKLM SOFTWARE\NSIS_Example2

  ; Remove files and uninstaller
  Delete $INSTDIR\example2.nsi
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Example2\*.lnk"

  ; Remove directories
  RMDir "$SMPROGRAMS\Example2"
  RMDir "$INSTDIR"

SectionEnd
