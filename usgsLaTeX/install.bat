cls
echo off

cd > result.txt
set CURRENT=%~dp0
echo Current drive=%CURRENT:~0,3%
echo Current directory=%CURRENT%

kpsewhich -var-value TEXMFLOCAL > result.txt
set /p TEXLOCAL=<result.txt
set "TEXLOCAL=%TEXLOCAL:/=\%"
echo TEXLOCAL Drive=%TEXLOCAL:~0,3%
echo TEXLOCAL=%TEXLOCAL%

echo Making a few directories if they do not exist..."
mkdir %TEXLOCAL%
mkdir %TEXLOCAL%\tex\
mkdir %TEXLOCAL%\bibtex\
mkdir %TEXLOCAL%\fonts\
mkdir %TEXLOCAL%\dvips\

echo "Copying USGS LaTeX style files...

echo Copy %CURRENT%\tex to %TEXLOCAL%\tex
Xcopy %CURRENT%\tex %TEXLOCAL%\tex /E /F /Y

echo Copy %CURRENT%\bibtex to %TEXLOCAL%\bibtex
Xcopy %CURRENT%\bibtex %TEXLOCAL%\bibtex /E /F /Y

echo Copy %CURRENT%\fonts to %TEXLOCAL%\fonts
Xcopy %CURRENT%\fonts %TEXLOCAL%\fonts /E /F /Y

echo Copy %CURRENT%\dvips to %TEXLOCAL%\dvips
Xcopy %CURRENT%\dvips %TEXLOCAL%\dvips /E /F /Y

echo Installing Univers font...
cd %TEXLOCAL%\dvips
updmap-sys --enable Map=funivers.map
updmap-sys

echo Installing Times New Roman font...
cd %TEXLOCAL%\dvips
updmap-sys --enable Map=timesnew.map
updmap-sys

echo Rebuild ls-R filename databases used by TeX...
mktexlsr

echo Return to %CURRENT%
cd %CURRENT%

echo Evaluate if USGS style files are available
echo Location of USGS LaTeX style files:
kpsewhich usgsreporta.sty

pause
