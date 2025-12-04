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
pause