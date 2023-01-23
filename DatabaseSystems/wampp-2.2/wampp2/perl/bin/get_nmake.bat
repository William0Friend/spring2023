@echo off
set nmake=nmake15.exe
echo off
set ms=http://download.microsoft.com/download/vc15/Patch/1.52/W95/EN-US/Nmake15.exe
@echo on
perl -MLWP::Simple -e "getstore(qq{%ms%}, qq{%nmake%})"
@echo off
if not exist %nmake% goto :error1
@echo on
nmake15.exe
@echo off
if not exist NMAKE.EXE goto :error2
echo Extraction of NMAKE.EXE succeeded
goto :end
:error1
echo Fetch of %nmake% failed
goto :end
:error2
echo Extraction of NMAKE.EXE failed
goto :end
:end
pause


