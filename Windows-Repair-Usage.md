# Windows-Repair.ps1 Usage:
1. Open PowerShell as Administrator via these keyboard shotcuts in sequence
   1. WIN+X
   2. ALT+A
   3. ALT+Y
2. Run
```powershell
powershell.exe -Command "Invoke-WebRequest -Uri `"https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/Windows-Scripts/windows-repair.ps1`" -OutFile `"$env:TEMP\windows-repair.ps1`"" && powershell.exe -ExecutionPolicy Bypass -File "$env:TEMP\windows-repair.ps1"
```