@echo off
title ARCH: %PROCESSOR_ARCHITECTURE%
setlocal enableextensions enabledelayedexpansion
set err=100
 
for /f "skip=1 tokens=1-3" %%i in ('2^>nul ^
WMIC LogicalDisk ^
WHERE "DriveType='3'" ^
GET FreeSpace^, Name^, Size^') do (
 
  set sFreeSize=%%i
  set sFreeSizeOf=%%k
 if NOT 1%%j==1 (
    rem echo %%j %%i %%k
    set /A Free=!sFreeSize:~0,-9!
    set /A Size=!sFreeSizeOf:~0,-9!
    set /A Procent=!Free!*100/!Size!
    set ah=HDD:
    if !Procent! LSS 50 (
      set ah=HDD:
      if !Procent! LSS !err! set err=!Procent!
    )
    echo !ah! %%j Free !Free! Gb of !Size! Gb
  )
 
)


@echo off
if defined ProgramFiles(x86) (set oper=x64) else (set oper=x32)
FOR /F "tokens=1* delims==" %%A IN ('wmic os get caption /Format:List ^| FIND "="') DO set "s=%%~B"
echo OS: %s% %oper%
For /F "tokens=2 Delims==" %%J In ('WMIC CPU Get Name /Value^|FindStr .') Do echo Processor: %%J
FOR /F "tokens=1* delims==" %%A IN ('WMIC CPU Get numberoflogicalprocessors /Format:List ^| FIND "="') DO set "ss=%%~B"
echo Cores: %ss%
@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value^|find "="') do set "s=%%a"
set /a s/=1024
echo RAM: %s%Mb
set /a numik=0
goto 2
:vdo
set /a numik=%numik%+1
set /a sss=%s%/1024/1024
echo Video %numik%: %sss% Мб
exit /b
:2
set /a num=0
for /F "tokens=1* delims==" %%A IN ('WMIC Path Win32_VideoController get Name /Format:List ^| FIND "="') DO set "s=%%~B" & call :vdol
goto 3
:vdol
set /a num=%num%+1
echo Video %num%: %s%
exit /b
:3
for /F "tokens=2 delims==" %%A IN ('WMIC Path Win32_VideoController get currenthorizontalresolution /Format:List ^| FIND "="') DO call :hor "%%A"
:hor
if not "%~1"=="" set hh=%~1
for /F "tokens=2 delims==" %%A IN ('WMIC Path Win32_VideoController get currentverticalresolution /Format:List ^| FIND "="') DO call :ver "%%A"
:ver
if not "%~1"=="" set vv=%~1
echo.

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Admin rights - YES 
) ELSE (
    ECHO Admin rights - NO
)

@echo off
for /f "delims=" %%i IN ('net.exe 2^>nul view ^| find.exe /i /c "\"') DO set var=%%i
echo PC in LAN: %var%
pause
DEL "%~f0"
exit
