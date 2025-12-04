@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================================
:: WERKPLAATS MARC - ADXL345 Data Verzameling Tool
:: ============================================================================
:: Versie: 1.0
:: GitHub: https://github.com/werkplaatsmarc/3d-printer-kalibratie
:: ============================================================================

title WERKPLAATS MARC - ADXL345 Data Verzameling

:MENU
cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo                   WERKPLAATS MARC - ADXL345 Tool
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  🔧 ADXL345 Resonantie Data Verzameling voor Input Shaping
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
echo  [1] Start data verzameling
echo  [2] Configuratie wijzigen
echo  [3] Help en instructies
echo  [4] Afsluiten
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.

set /p choice="Maak een keuze (1-4): "

if "%choice%"=="1" goto START_COLLECTION
if "%choice%"=="2" goto CONFIG
if "%choice%"=="3" goto HELP
if "%choice%"=="4" goto EXIT
goto MENU

:CONFIG
cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo                         CONFIGURATIE
echo ════════════════════════════════════════════════════════════════════════
echo.

:: COM poort instellen
echo 💡 TIP: Check je COM poort in Windows Apparaatbeheer
echo    Zoek naar "Poorten (COM en LPT)"
echo.
set /p com_port="COM poort van ADXL345 (bijv. COM3): "
if "!com_port!"=="" set com_port=COM3

:: Test duur instellen
echo.
echo ⏱️  Data verzamel duur
echo    Aanbevolen: 30 seconden
echo.
set /p duration="Duur in seconden (standaard 30): "
if "!duration!"=="" set duration=30

:: Sample rate
set sample_rate=3200

echo.
echo ✅ Configuratie opgeslagen:
echo    COM Poort: !com_port!
echo    Duur: !duration! seconden
echo    Sample Rate: !sample_rate! Hz
echo.

:: Sla configuratie op in bestand
(
echo COM_PORT=!com_port!
echo DURATION=!duration!
echo SAMPLE_RATE=!sample_rate!
) > config.txt

echo.
pause
goto MENU

:HELP
cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo                     HELP EN INSTRUCTIES
echo ════════════════════════════════════════════════════════════════════════
echo.
echo 📋 BENODIGDHEDEN:
echo    • BigTreeTech ADXL345 v2.0 accelerometer
echo    • USB verbinding naar de PC
echo    • 3D printer met Marlin firmware
echo    • ADXL345 gemonteerd op de nozzle/printhead
echo.
echo 🔌 AANSLUITING:
echo    1. Sluit ADXL345 aan via USB op je computer
echo    2. Check in Windows Apparaatbeheer welke COM poort is toegewezen
echo    3. Noteer het COM poortnummer (bijv. COM3, COM4)
echo.
echo 🎯 VOORBEREIDINGEN:
echo    1. Monteer ADXL345 stevig op de printhead/nozzle
echo    2. Zorg dat alle assen vrij kunnen bewegen
echo    3. Printer moet AAN staan maar stil staan
echo    4. Geen obstructies op het printbed
echo.
echo 📊 DATA VERZAMELING STARTEN:
echo    1. Kies optie [1] in het hoofdmenu
echo    2. Wacht tot de countdown afloopt
echo    3. Tijdens verzameling NIET aan de printer komen
echo    4. Na 30 seconden is de data compleet
echo.
echo 💾 OUTPUT:
echo    • Data wordt opgeslagen in de map 'adxl_data'
echo    • Bestandsnaam bevat datum en tijd
echo    • CSV formaat voor analyse
echo.
echo 🔄 VOLGENDE STAP:
echo    Upload het CSV bestand naar:
echo    https://werkplaatsmarc.be/input-shaping.html
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
pause
goto MENU

:START_COLLECTION
cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo                     DATA VERZAMELING STARTEN
echo ════════════════════════════════════════════════════════════════════════
echo.

:: Laad configuratie
if exist config.txt (
    for /f "tokens=1,2 delims==" %%a in (config.txt) do (
        if "%%a"=="COM_PORT" set com_port=%%b
        if "%%a"=="DURATION" set duration=%%b
        if "%%a"=="SAMPLE_RATE" set sample_rate=%%b
    )
) else (
    set com_port=COM3
    set duration=30
    set sample_rate=3200
)

echo 📋 Huidige configuratie:
echo    COM Poort: !com_port!
echo    Duur: !duration! seconden
echo    Sample Rate: !sample_rate! Hz
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
echo ⚠️  CONTROLEER VOOR JE START:
echo.
echo    ✓ ADXL345 is aangesloten via USB
echo    ✓ ADXL345 is gemonteerd op de nozzle
echo    ✓ Printer staat AAN maar is stil
echo    ✓ Alle assen kunnen vrij bewegen
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.

set /p ready="Klaar om te starten? (J/N): "
if /i not "!ready!"=="J" goto MENU

echo.
echo 🚀 Data verzameling start over 5 seconden...
echo    RAAK DE PRINTER NIET AAN tijdens het verzamelen!
echo.

timeout /t 5 /nobreak >nul

:: Maak output directory
if not exist "adxl_data" mkdir "adxl_data"

:: Genereer bestandsnaam met timestamp
for /f "tokens=1-6 delims=/:. " %%a in ("%date% %time%") do (
    set timestamp=%%c%%b%%a_%%d%%e%%f
)
set output_file=adxl_data\resonance_test_!timestamp!.csv

echo 📊 Data verzameling actief...
echo.

:: Check of Python beschikbaar is
where python >nul 2>&1
if errorlevel 1 (
    echo ❌ FOUT: Python is niet geïnstalleerd
    echo.
    echo 💡 OPLOSSINGEN:
    echo    1. Installeer Python vanaf python.org
    echo    2. OF gebruik de portable versie ^(zie README^)
    echo.
    pause
    goto MENU
)

:: Check of pyserial beschikbaar is
python -c "import serial" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  PySerial niet gevonden - installeren...
    python -m pip install pyserial
    if errorlevel 1 (
        echo ❌ FOUT: Kan PySerial niet installeren
        pause
        goto MENU
    )
)

:: Run Python script met parameters
python "%~dp0python\adxl_collect.py" !com_port! !duration! !sample_rate! "!output_file!"

if errorlevel 1 (
    echo.
    echo ❌ Er is een fout opgetreden tijdens het verzamelen
    echo.
    echo 💡 MOGELIJKE OORZAKEN:
    echo    • Verkeerde COM poort ^(check Apparaatbeheer^)
    echo    • ADXL345 niet aangesloten
    echo    • Driver niet geïnstalleerd
    echo    • Poort al in gebruik door ander programma
    echo.
    pause
    goto MENU
)

echo.
echo ════════════════════════════════════════════════════════════════════════
echo                    ✅ VERZAMELING VOLTOOID!
echo ════════════════════════════════════════════════════════════════════════
echo.
echo 💾 Data opgeslagen in: !output_file!
echo.
echo 🔄 VOLGENDE STAPPEN:
echo    1. Ga naar: https://werkplaatsmarc.be/input-shaping.html
echo    2. Upload het CSV bestand
echo    3. Bekijk de resonantie analyse
echo    4. Kopieer de aanbevolen Input Shaping waarden
echo.
echo 📁 Wil je de output map openen?
echo.
set /p open_folder="Map openen? (J/N): "
if /i "!open_folder!"=="J" start "" "adxl_data"

echo.
pause
goto MENU

:EXIT
cls
echo.
echo ════════════════════════════════════════════════════════════════════════
echo          Bedankt voor het gebruik van de ADXL345 Tool!
echo ════════════════════════════════════════════════════════════════════════
echo.
echo 🌐 Meer kalibratie tools: https://werkplaatsmarc.be
echo 📺 YouTube tutorials: Werkplaats Marc
echo.
timeout /t 3
exit