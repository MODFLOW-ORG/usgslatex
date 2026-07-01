@echo off
setlocal enabledelayedexpansion

set "CURRENT=%~dp0"
echo Current directory=%CURRENT%

REM --- Locate the system-wide (TEXMFLOCAL) and per-user (TEXMFHOME) trees ---
for /f "usebackq delims=" %%i in (`kpsewhich -var-value TEXMFLOCAL`) do set "TEXLOCAL=%%i"
for /f "usebackq delims=" %%i in (`kpsewhich -var-value TEXMFHOME`) do set "TEXHOME=%%i"
set "TEXLOCAL=%TEXLOCAL:/=\%"
set "TEXHOME=%TEXHOME:/=\%"
echo TEXMFLOCAL=%TEXLOCAL%
echo TEXMFHOME=%TEXHOME%

REM --- Decide the target tree based on write access to TEXMFLOCAL. ---
REM     If TEXMFLOCAL is writable (e.g. you own the TeX Live installation,
REM     or you are running elevated), install system-wide with updmap-sys.
REM     Otherwise fall back to the per-user tree TEXMFHOME with updmap-user,
REM     which never requires Administrator privileges.
if not exist "%TEXLOCAL%" mkdir "%TEXLOCAL%" 2>nul
set "WRITABLE=1"
copy /y nul "%TEXLOCAL%\.usgs_wtest" >nul 2>&1 || set "WRITABLE=0"
if exist "%TEXLOCAL%\.usgs_wtest" del /q "%TEXLOCAL%\.usgs_wtest" >nul 2>&1

if "%WRITABLE%"=="1" (
    set "TEXROOT=%TEXLOCAL%"
    set "UPDMAP=updmap-sys"
    echo TEXMFLOCAL is writable -- installing system-wide.
) else (
    set "TEXROOT=%TEXHOME%"
    set "UPDMAP=updmap-user"
    echo TEXMFLOCAL is not writable -- installing for the current user only ^(no Administrator privileges required^).
)
echo Target tree: !TEXROOT!
echo Font-map tool: !UPDMAP!

echo Making a few directories if they do not exist...
mkdir "!TEXROOT!"         2>nul
mkdir "!TEXROOT!\tex"     2>nul
mkdir "!TEXROOT!\bibtex"  2>nul
mkdir "!TEXROOT!\fonts"   2>nul
mkdir "!TEXROOT!\dvips"   2>nul

echo Copying USGS LaTeX style files...
Xcopy "%CURRENT%tex"    "!TEXROOT!\tex"    /E /F /Y
Xcopy "%CURRENT%bibtex" "!TEXROOT!\bibtex" /E /F /Y
Xcopy "%CURRENT%fonts"  "!TEXROOT!\fonts"  /E /F /Y
Xcopy "%CURRENT%dvips"  "!TEXROOT!\dvips"  /E /F /Y

echo Installing Univers Condensed font...
cd /d "!TEXROOT!\dvips"
!UPDMAP! --enable Map=funivers.map
!UPDMAP!

echo Installing Times New Roman font...
!UPDMAP! --enable Map=timesnew.map
!UPDMAP!

echo Rebuild ls-R filename database used by TeX...
mktexlsr "!TEXROOT!"

cd /d "%CURRENT%"
echo Evaluate if USGS style files are available
echo Location of USGS LaTeX style files:
kpsewhich usgsreporta.sty

pause
