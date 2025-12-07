@echo off
chcp 65001 >nul

title WERKPLAATS MARC - Installatie

cls
echo.
echo ========================================================================
echo           WERKPLAATS MARC - ADXL345 Tool Installatie v2.0
echo ========================================================================
echo.
echo  Dit script installeert alle benodigde software voor de ADXL345 tool.
echo  Inclusief FFT analyse libraries voor directe resultaten!
echo.
echo ========================================================================
echo.
pause

echo.
echo ========================================================================
echo  STAP 1: Python Controle
echo ========================================================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo [X] Python is niet geinstalleerd!
    echo.
    echo Download Python van: https://www.python.org/downloads/
    echo Zorg dat je "Add Python to PATH" aanvinkt tijdens installatie!
    echo.
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [OK] Python gevonden: versie %PYTHON_VERSION%

echo.
echo ========================================================================
echo  STAP 2: pip Controle
echo ========================================================================
echo.

python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo [X] pip is niet beschikbaar!
    echo.
    echo Installeer pip via: python -m ensurepip
    pause
    exit /b 1
)

echo [OK] pip is beschikbaar
echo.
echo Updaten van pip naar laatste versie...
python -m pip install --upgrade pip --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install --upgrade pip
)
echo [OK] pip is up-to-date

echo.
echo ========================================================================
echo  STAP 3: Python Libraries Installeren
echo ========================================================================
echo.
echo  De volgende libraries worden geinstalleerd:
echo    - pyserial  (ADXL345 communicatie)
echo    - numpy     (numerieke berekeningen)
echo    - scipy     (FFT analyse)
echo.
echo  Dit kan enkele minuten duren...
echo.

echo Installeren: pyserial...
python -m pip install pyserial --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install pyserial
)
if errorlevel 1 (
    echo [X] FOUT bij installeren van pyserial
    pause
    exit /b 1
)
echo [OK] pyserial geinstalleerd

echo.
echo Installeren: numpy...
python -m pip install numpy --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install numpy
)
if errorlevel 1 (
    echo [X] FOUT bij installeren van numpy
    pause
    exit /b 1
)
echo [OK] numpy geinstalleerd

echo.
echo Installeren: scipy...
echo (Dit kan 2-5 minuten duren...)
python -m pip install scipy --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install scipy
)
if errorlevel 1 (
    echo [X] FOUT bij installeren van scipy
    pause
    exit /b 1
)
echo [OK] scipy geinstalleerd

echo.
echo ========================================================================
echo  STAP 4: Directory Structuur Aanmaken
echo ========================================================================
echo.

if not exist "adxl_data" (
    mkdir "adxl_data"
    echo [OK] adxl_data directory aangemaakt
) else (
    echo [OK] adxl_data directory bestaat al
)

if not exist "python" (
    mkdir "python"
    echo [OK] python directory aangemaakt
) else (
    echo [OK] python directory bestaat al
)

echo.
echo ========================================================================
echo  STAP 5: Installatie Verificatie
echo ========================================================================
echo.

python -c "import serial; import numpy; import scipy; print('[OK] Alle libraries succesvol geimporteerd')" 2>nul
if errorlevel 1 (
    echo [X] Er is een probleem met de geinstalleerde libraries
    echo.
    echo Probeer Python opnieuw te installeren of neem contact op voor support.
    pause
    exit /b 1
)

echo.
echo Geinstalleerde versies:
for /f "tokens=2" %%i in ('python -c "import serial; print(serial.__version__)" 2^>^&1') do echo    - pyserial: %%i
for /f "tokens=2" %%i in ('python -c "import numpy; print(numpy.__version__)" 2^>^&1') do echo    - numpy: %%i
for /f "tokens=2" %%i in ('python -c "import scipy; print(scipy.__version__)" 2^>^&1') do echo    - scipy: %%i

echo.
echo ========================================================================
echo  INSTALLATIE VOLTOOID!
echo ========================================================================
echo.
echo  Je kunt nu de ADXL345 tool gebruiken:
echo    1. Dubbelklik op adxl_verzameling.bat
echo    2. Kies optie [1] voor volledige kalibratie
echo    3. Volg de instructies op het scherm
echo.
echo  Nieuw in v2.0:
echo     - Directe FFT analyse na data verzameling
echo     - Instant Input Shaping configuratie
echo     - Geen web upload meer nodig!
echo.
echo  Hulp nodig?
echo     - GitHub: github.com/werkplaatsmarc/3d-printer-kalibratie
echo     - Website: werkplaatsmarc.be
echo     - YouTube: youtube.com/@werkplaatsmarc
echo.
echo ========================================================================
echo.
pause