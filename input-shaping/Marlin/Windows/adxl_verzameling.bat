@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title WERKPLAATS MARC - ADXL345 Tool v2.0

:MENU
cls
echo.
echo ========================================================================
echo                WERKPLAATS MARC - ADXL345 Tool v2.0
echo ========================================================================
echo.
echo  ADXL345 Resonantie Analyse voor Input Shaping
echo  Nu met GEINTEGREERDE FFT ANALYSE!
echo.
echo ========================================================================
echo.
echo  [1] Volledige kalibratie (verzamel + analyse)
echo  [2] Alleen data verzamelen
echo  [3] Analyseer bestaand bestand
echo  [4] Configuratie wijzigen
echo  [5] Help en instructies
echo  [6] Afsluiten
echo.
echo ========================================================================
echo.

set /p choice="Maak een keuze (1-6): "

if "%choice%"=="1" goto FULL_CALIBRATION
if "%choice%"=="2" goto COLLECT_ONLY
if "%choice%"=="3" goto ANALYZE_ONLY
if "%choice%"=="4" goto CONFIG
if "%choice%"=="5" goto HELP
if "%choice%"=="6" goto EXIT
goto MENU

:FULL_CALIBRATION
cls
echo.
echo ========================================================================
echo                    VOLLEDIGE KALIBRATIE
echo ========================================================================
echo.
echo  Deze modus verzamelt data EN voert direct FFT analyse uit!
echo  Je krijgt binnen enkele seconden je Input Shaping configuratie.
echo.
echo ========================================================================
echo.
pause

call :LOAD_CONFIG

set timestamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
set output_file=adxl_data\resonance_%timestamp%.csv

python --version >nul 2>&1
if errorlevel 1 (
    echo [X] FOUT: Python niet gevonden!
    echo    Run eerst INSTALL.bat
    pause
    goto MENU
)

python -c "import numpy, scipy" >nul 2>&1
if errorlevel 1 (
    echo [X] FOUT: NumPy/SciPy niet geinstalleerd!
    echo    Run eerst INSTALL.bat
    pause
    goto MENU
)

echo.
echo ========================================================================
echo  STAP 1: START PRINTER BEWEGINGEN
echo ========================================================================
echo.
echo  Download: adxl_test_movements.gcode van GitHub
echo  https://github.com/werkplaatsmarc/3d-printer-kalibratie
echo.
echo  1. Zet bestand op SD kaart
echo  2. Start print via LCD menu (of Pronterface/OctoPrint)
echo  3. Druk ENTER om data verzameling te starten
echo.
echo  Het G-code bestand wacht 5 seconden voordat het begint!
echo.
echo ========================================================================
echo.
pause

echo.
echo Start volledige kalibratie...
echo.
python adxl_collect.py "!com_port!" !duration! !sample_rate! "!output_file!"

if errorlevel 1 (
    echo.
    echo [X] Er is een fout opgetreden
    pause
    goto MENU
)

echo.
echo Wil je de output folder openen? (J/N)
set /p open_folder=""
if /i "!open_folder!"=="J" (
    start "" "adxl_data"
)

echo.
pause
goto MENU

:COLLECT_ONLY
cls
echo.
echo ========================================================================
echo                    ALLEEN DATA VERZAMELEN
echo ========================================================================
echo.
echo  Deze modus verzamelt alleen data ZONDER analyse.
echo  Je kunt de analyse later uitvoeren via optie [3].
echo.
echo ========================================================================
echo.
pause

call :LOAD_CONFIG

set timestamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
set output_file=adxl_data\data_only_%timestamp%.csv

python --version >nul 2>&1
if errorlevel 1 (
    echo [X] FOUT: Python niet gevonden!
    echo    Run eerst INSTALL.bat
    pause
    goto MENU
)

echo.
echo ========================================================================
echo  STAP 1: START PRINTER BEWEGINGEN
echo ========================================================================
echo.
echo  Download: adxl_test_movements.gcode van GitHub
echo  https://github.com/werkplaatsmarc/3d-printer-kalibratie
echo.
echo  1. Zet bestand op SD kaart
echo  2. Start print via LCD menu (of Pronterface/OctoPrint)
echo  3. Druk ENTER om data verzameling te starten
echo.
echo  Het G-code bestand wacht 5 seconden voordat het begint!
echo.
echo ========================================================================
echo.
pause

echo.
echo Start data verzameling...
echo.
python adxl_collect.py "!com_port!" !duration! !sample_rate! "!output_file!" --no-analyze

if errorlevel 1 (
    echo.
    echo [X] Er is een fout opgetreden
    pause
    goto MENU
)

echo.
pause
goto MENU

:ANALYZE_ONLY
cls
echo.
echo ========================================================================
echo                 ANALYSEER BESTAAND BESTAND
echo ========================================================================
echo.
echo  Beschikbare CSV bestanden in adxl_data\:
echo.

if exist "adxl_data\*.csv" (
    dir /b "adxl_data\*.csv"
) else (
    echo  (Geen bestanden gevonden)
)

echo.
echo ========================================================================
echo.
set /p csv_file="Geef bestandsnaam (of volledig pad): "

if "!csv_file!"=="" (
    echo [X] Geen bestand opgegeven
    pause
    goto MENU
)

if not "!csv_file:~1,1!"==":" (
    if not exist "!csv_file!" (
        set csv_file=adxl_data\!csv_file!
    )
)

if not exist "!csv_file!" (
    echo [X] FOUT: Bestand niet gevonden: !csv_file!
    pause
    goto MENU
)

python -c "import numpy, scipy" >nul 2>&1
if errorlevel 1 (
    echo [X] FOUT: NumPy/SciPy niet geinstalleerd!
    echo    Run eerst INSTALL.bat
    pause
    goto MENU
)

echo.
echo Start analyse...
echo.
python python\adxl_collect.py --analyze "!csv_file!"

if errorlevel 1 (
    echo.
    echo [X] Er is een fout opgetreden
    pause
    goto MENU
)

echo.
pause
goto MENU

:CONFIG
cls
echo.
echo ========================================================================
echo                         CONFIGURATIE
echo ========================================================================
echo.

echo Check je COM poort in Windows Apparaatbeheer
echo Zoek naar "Poorten (COM en LPT)"
echo.
set /p com_port="COM poort van ADXL345 (bijv. COM3): "
if "!com_port!"=="" set com_port=COM3

echo.
echo Data verzamel duur
echo Aanbevolen: 30 seconden
echo.
set /p duration="Duur in seconden (standaard 30): "
if "!duration!"=="" set duration=30

set sample_rate=3200

echo.
echo [OK] Configuratie opgeslagen:
echo    COM Poort: !com_port!
echo    Duur: !duration! seconden
echo    Target Sample Rate: !sample_rate! Hz
echo.
echo    OPMERKING: De werkelijke sample rate is ~30-60 Hz
echo    door USB communicatie beperkingen. Dit is normaal!
echo.

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
echo ========================================================================
echo                     HELP EN INSTRUCTIES
echo ========================================================================
echo.
echo BENODIGDHEDEN:
echo    - BigTreeTech ADXL345 v2.0 accelerometer
echo    - USB verbinding naar de PC
echo    - 3D printer met Marlin of Klipper firmware
echo    - ADXL345 gemonteerd op de nozzle/printhead
echo.
echo AANSLUITING:
echo    1. Sluit ADXL345 aan via USB op je computer
echo    2. Check in Windows Apparaatbeheer welke COM poort is toegewezen
echo    3. Configureer de COM poort via optie [4]
echo.
echo QUICK START:
echo    1. Run INSTALL.bat (eerste keer)
echo    2. Monteer ADXL345 stevig op de nozzle
echo    3. Download adxl_test_movements.gcode van GitHub
echo    4. Kies optie [1] voor volledige kalibratie
echo    5. Start G-code bestand op printer
echo    6. Wacht ~30 seconden voor data verzameling
echo    7. Analyse gebeurt automatisch (2-3 seconden)
echo    8. Kopieer de G-code naar je printer terminal
echo    9. Voer M500 uit om op te slaan
echo.
echo PRINTER BEWEGINGEN (tijdens data verzameling):
echo    Download: adxl_test_movements.gcode van GitHub
echo    https://github.com/werkplaatsmarc/3d-printer-kalibratie
echo.
echo    - Zet bestand op SD kaart
echo    - Start via LCD menu of Pronterface/OctoPrint
echo    - Bestand wacht 5 seconden voordat bewegingen starten
echo    - Totale duur: ~45 seconden
echo.
echo WORKFLOW OPTIES:
echo    Optie [1] - AANBEVOLEN voor de meeste gebruikers
echo              Doet alles automatisch in een keer
echo    
echo    Optie [2] - Voor gevorderde gebruikers
echo              Verzamel data nu, analyseer later
echo    
echo    Optie [3] - Analyseer oude data opnieuw
echo              Handig voor troubleshooting
echo.
echo NA KALIBRATIE:
echo    1. Print een test object (ringing tower)
echo    2. Vergelijk met print ZONDER Input Shaping
echo    3. Verwacht 50-80%% reductie in ringing
echo.
echo ONLINE RESOURCES:
echo    - GitHub: github.com/werkplaatsmarc/3d-printer-kalibratie
echo    - Website: werkplaatsmarc.be/input-shaping.html
echo    - YouTube: youtube.com/@werkplaatsmarc
echo.
echo ========================================================================
pause
goto MENU

:LOAD_CONFIG
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
goto :EOF

:EXIT
echo.
echo Bedankt voor het gebruiken van Werkplaats Marc ADXL345 Tool!
echo Bezoek werkplaatsmarc.be voor meer kalibratie guides.
echo.
timeout /t 2 >nul
exit