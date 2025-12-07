<<<<<<< HEAD
@echo off
chcp 65001 >nul

:: ============================================================================
:: WERKPLAATS MARC - ADXL345 Tool Installatie Script
:: ============================================================================
:: Versie: 2.0 - Nu met FFT analyse dependencies
:: ============================================================================

title WERKPLAATS MARC - Installatie

cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo           WERKPLAATS MARC - ADXL345 Tool Installatie v2.0
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  Dit script installeert alle benodigde software voor de ADXL345 tool.
echo  Inclusief FFT analyse libraries voor directe resultaten!
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
pause

:: ============================================================================
:: STAP 1: Check Python
:: ============================================================================
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  STAP 1: Python Controle
echo ════════════════════════════════════════════════════════════════════════
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is niet geïnstalleerd!
    echo.
    echo 💡 Download Python van: https://www.python.org/downloads/
    echo    Zorg dat je "Add Python to PATH" aanvinkt tijdens installatie!
    echo.
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python gevonden: versie %PYTHON_VERSION%

:: ============================================================================
:: STAP 2: Check/Update pip
:: ============================================================================
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  STAP 2: pip (Python Package Manager) Controle
echo ════════════════════════════════════════════════════════════════════════
echo.

python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ pip is niet beschikbaar!
    echo.
    echo    Installeer pip via: python -m ensurepip
    pause
    exit /b 1
)

echo ✅ pip is beschikbaar
echo.
echo 🔄 Updaten van pip naar laatste versie...
python -m pip install --upgrade pip --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install --upgrade pip
)
echo ✅ pip is up-to-date

:: ============================================================================
:: STAP 3: Installeer Dependencies
:: ============================================================================
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  STAP 3: Python Libraries Installeren
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  De volgende libraries worden geïnstalleerd:
echo    • pyserial  - Voor ADXL345 communicatie
echo    • numpy     - Voor numerieke berekeningen
echo    • scipy     - Voor FFT analyse
echo.
echo  Dit kan enkele minuten duren...
echo.

:: Installeer pyserial
echo 📦 Installeren: pyserial...
python -m pip install pyserial --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install pyserial
)
if errorlevel 1 (
    echo ❌ FOUT bij installeren van pyserial
    pause
    exit /b 1
)
echo ✅ pyserial geïnstalleerd

:: Installeer numpy
echo.
echo 📦 Installeren: numpy...
python -m pip install numpy --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install numpy
)
if errorlevel 1 (
    echo ❌ FOUT bij installeren van numpy
    pause
    exit /b 1
)
echo ✅ numpy geïnstalleerd

:: Installeer scipy
echo.
echo 📦 Installeren: scipy...
echo    (Dit kan 2-5 minuten duren...)
python -m pip install scipy --break-system-packages 2>nul
if errorlevel 1 (
    python -m pip install scipy
)
if errorlevel 1 (
    echo ❌ FOUT bij installeren van scipy
    pause
    exit /b 1
)
echo ✅ scipy geïnstalleerd

:: ============================================================================
:: STAP 4: Maak Directory Structuur
:: ============================================================================
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  STAP 4: Directory Structuur Aanmaken
echo ════════════════════════════════════════════════════════════════════════
echo.

if not exist "adxl_data" (
    mkdir "adxl_data"
    echo ✅ adxl_data directory aangemaakt
) else (
    echo ✅ adxl_data directory bestaat al
)

if not exist "python" (
    mkdir "python"
    echo ✅ python directory aangemaakt
) else (
    echo ✅ python directory bestaat al
)

:: ============================================================================
:: STAP 5: Verificatie
:: ============================================================================
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  STAP 5: Installatie Verificatie
echo ════════════════════════════════════════════════════════════════════════
echo.

:: Test imports
python -c "import serial; import numpy; import scipy; print('✅ Alle libraries succesvol geïmporteerd')" 2>nul
if errorlevel 1 (
    echo ❌ Er is een probleem met de geïnstalleerde libraries
    echo.
    echo 💡 Probeer Python opnieuw te installeren of neem contact op voor support.
    pause
    exit /b 1
)

:: Toon versies
echo.
echo 📊 Geïnstalleerde versies:
for /f "tokens=2" %%i in ('python -c "import serial; print(serial.__version__)" 2^>^&1') do echo    • pyserial: %%i
for /f "tokens=2" %%i in ('python -c "import numpy; print(numpy.__version__)" 2^>^&1') do echo    • numpy: %%i
for /f "tokens=2" %%i in ('python -c "import scipy; print(scipy.__version__)" 2^>^&1') do echo    • scipy: %%i

:: ============================================================================
:: VOLTOOID
:: ============================================================================
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  ✅ INSTALLATIE VOLTOOID!
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  Je kunt nu de ADXL345 tool gebruiken:
echo    1. Dubbelklik op adxl_verzameling.bat
echo    2. Kies optie [1] voor volledige kalibratie
echo    3. Volg de instructies op het scherm
echo.
echo  🎉 Nieuwe in v2.0:
echo     • Directe FFT analyse na data verzameling
echo     • Instant Input Shaping configuratie
echo     • Geen web upload meer nodig!
echo.
echo  📚 Hulp nodig?
echo     • GitHub: github.com/werkplaatsmarc/3d-printer-kalibratie
echo     • Website: werkplaatsmarc.be
echo     • YouTube: youtube.com/@werkplaatsmarc
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
=======
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================================
:: WERKPLAATS MARC - ADXL345 Tool Installer
:: ============================================================================

title WERKPLAATS MARC - ADXL345 Tool Installatie

cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo              WERKPLAATS MARC - ADXL345 Tool Installatie
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  Deze installer controleert en installeert alle benodigdheden:
echo.
echo  ✓ Python 3.x
echo  ✓ PySerial bibliotheek
echo  ✓ Map structuur
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
pause
echo.

:: Check of Python is geïnstalleerd
echo [1/3] Python controleren...
where python >nul 2>&1
if errorlevel 1 (
    echo ❌ Python niet gevonden
    echo.
    echo 💡 Python installeren:
    echo    1. Ga naar: https://www.python.org/downloads/
    echo    2. Download de nieuwste Python versie
    echo    3. Voer de installer uit
    echo    4. ⚠️  BELANGRIJK: Vink "Add Python to PATH" aan!
    echo    5. Klik op "Install Now"
    echo    6. Start deze installer opnieuw na Python installatie
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('python --version 2^>^&1') do set python_version=%%i
    echo ✅ !python_version! gevonden
)

echo.

:: Check of pip werkt
echo [2/3] Pip controleren...
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Pip niet gevonden
    echo.
    echo 💡 Pip installeren:
    python -m ensurepip --default-pip
    if errorlevel 1 (
        echo ❌ Kan pip niet installeren
        echo    Herinstalleer Python met pip optie ingeschakeld
        pause
        exit /b 1
    )
) else (
    echo ✅ Pip gereed
)

echo.

:: Installeer PySerial
echo [3/3] PySerial installeren...
python -c "import serial" >nul 2>&1
if errorlevel 1 (
    echo 📦 PySerial wordt geïnstalleerd...
    python -m pip install pyserial
    if errorlevel 1 (
        echo ❌ FOUT: Kan PySerial niet installeren
        pause
        exit /b 1
    )
    echo ✅ PySerial geïnstalleerd
) else (
    echo ✅ PySerial reeds geïnstalleerd
)

echo.

:: Maak directories
echo 📁 Map structuur aanmaken...
if not exist "python" mkdir "python"
if not exist "adxl_data" mkdir "adxl_data"
echo ✅ Map structuur gereed

echo.
echo ════════════════════════════════════════════════════════════════════════
echo                    ✅ INSTALLATIE VOLTOOID!
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  Alles is klaar voor gebruik!
echo.
echo  🚀 VOLGENDE STAPPEN:
echo     1. Sluit je ADXL345 aan via USB
echo     2. Check de COM poort in Windows Apparaatbeheer
echo     3. Dubbelklik op "adxl_verzameling.bat"
echo     4. Kies optie [2] om je COM poort in te stellen
echo     5. Kies optie [1] om data te verzamelen
echo.
echo  📚 DOCUMENTATIE:
echo     Lees README.md voor uitgebreide instructies
echo.
echo  🌐 MEER INFO:
echo     Website: https://werkplaatsmarc.be
echo     YouTube: Werkplaats Marc
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.

:: Test installatie
echo 🔍 Installatie testen...
echo.
python -c "import serial; print('✅ PySerial test geslaagd - versie:', serial.__version__)" 2>nul
if errorlevel 1 (
    echo ⚠️  PySerial test gefaald - probeer handmatig:
    echo    python -m pip install pyserial
) else (
    echo.
    echo ✅ Alle tests geslaagd!
)

echo.
>>>>>>> cf6473c415b34583da961cdf5fbd2fe95f503f53
pause