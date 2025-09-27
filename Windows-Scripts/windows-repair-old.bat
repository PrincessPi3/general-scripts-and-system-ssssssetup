@ECHO OFF
mrt
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
chkdsk /r C: