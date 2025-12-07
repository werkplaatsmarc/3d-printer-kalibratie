#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="Mac"
    OPEN_CMD="open"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    OPEN_CMD="xdg-open"
else
    OS="Unknown"
    OPEN_CMD="echo"
fi

load_config() {
    if [ -f "config.txt" ]; then
        source config.txt
    else
        USB_PORT="/dev/ttyUSB0"
        DURATION=30
        SAMPLE_RATE=3200
    fi
}

show_menu() {
    clear
    echo ""
    echo -e "${BLUE}========================================================================${NC}"
    echo "             WERKPLAATS MARC - ADXL345 Tool v2.0 ($OS)"
    echo -e "${BLUE}========================================================================${NC}"
    echo ""
    echo "  [1] Volledige kalibratie (verzamel + analyse)"
    echo "  [2] Alleen data verzamelen"
    echo "  [3] Analyseer bestaand bestand"
    echo "  [4] Configuratie wijzigen"
    echo "  [5] Help"
    echo "  [6] Afsluiten"
    echo ""
    echo -e "${BLUE}========================================================================${NC}"
    echo ""
}

full_calibration() {
    clear
    echo ""
    echo "VOLLEDIGE KALIBRATIE"
    echo ""
    read -p "Druk op ENTER om te starten..."
    
    load_config
    
    timestamp=$(date +"%Y%m%d_%H%M%S")
    output_file="adxl_data/resonance_${timestamp}.csv"
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}[X] Python3 niet gevonden!${NC}"
        read -p "Druk op ENTER..."
        return
    fi
    
    python3 -c "import numpy, scipy" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}[X] NumPy/SciPy niet geinstalleerd!${NC}"
        read -p "Druk op ENTER..."
        return
    fi
    
    echo ""
    echo "========================================================================"
    echo "  STAP 1: START PRINTER BEWEGINGEN"
    echo "========================================================================"
    echo ""
    echo "  Download: adxl_test_movements.gcode van GitHub"
    echo "  https://github.com/werkplaatsmarc/3d-printer-kalibratie"
    echo ""
    echo "  1. Zet bestand op SD kaart"
    echo "  2. Start print via LCD menu (of Pronterface/OctoPrint)"
    echo "  3. Druk ENTER om data verzameling te starten"
    echo ""
    echo "  Het G-code bestand wacht 5 seconden voordat het begint!"
    echo ""
    echo "========================================================================"
    echo ""
    read -p "Druk op ENTER als print is gestart..."
    
    echo ""
    echo "Start volledige kalibratie..."
    echo ""
    python3 adxl_collect.py "$USB_PORT" $DURATION $SAMPLE_RATE "$output_file"
    
    echo ""
    read -p "Druk op ENTER..."
}

collect_only() {
    clear
    echo ""
    echo "ALLEEN DATA VERZAMELEN"
    echo ""
    read -p "Druk op ENTER om te starten..."
    
    load_config
    
    timestamp=$(date +"%Y%m%d_%H%M%S")
    output_file="adxl_data/data_only_${timestamp}.csv"
    
    echo ""
    echo "========================================================================"
    echo "  STAP 1: START PRINTER BEWEGINGEN"
    echo "========================================================================"
    echo ""
    echo "  Download: adxl_test_movements.gcode van GitHub"
    echo "  https://github.com/werkplaatsmarc/3d-printer-kalibratie"
    echo ""
    echo "  1. Zet bestand op SD kaart"
    echo "  2. Start print via LCD menu (of Pronterface/OctoPrint)"
    echo "  3. Druk ENTER om data verzameling te starten"
    echo ""
    echo "  Het G-code bestand wacht 5 seconden voordat het begint!"
    echo ""
    echo "========================================================================"
    echo ""
    read -p "Druk op ENTER als print is gestart..."
    
    echo ""
    python3 adxl_collect.py "$USB_PORT" $DURATION $SAMPLE_RATE "$output_file" --no-analyze
    
    echo ""
    read -p "Druk op ENTER..."
}

analyze_only() {
    clear
    echo ""
    echo "ANALYSEER BESTAAND BESTAND"
    echo ""
    echo "Beschikbare CSV bestanden:"
    echo ""
    
    if ls adxl_data/*.csv 1> /dev/null 2>&1; then
        ls -1 adxl_data/*.csv
    else
        echo "(Geen bestanden gevonden)"
    fi
    
    echo ""
    read -p "Geef bestandsnaam: " csv_file
    
    if [ -z "$csv_file" ]; then
        echo "[X] Geen bestand opgegeven"
        read -p "Druk op ENTER..."
        return
    fi
    
    if [[ ! "$csv_file" =~ ^/ ]] && [[ ! -f "$csv_file" ]]; then
        csv_file="adxl_data/$csv_file"
    fi
    
    if [ ! -f "$csv_file" ]; then
        echo -e "${RED}[X] Bestand niet gevonden${NC}"
        read -p "Druk op ENTER..."
        return
    fi
    
    echo ""
    python3 adxl_collect.py --analyze "$csv_file"
    
    echo ""
    read -p "Druk op ENTER..."
}

configure() {
    clear
    echo ""
    echo "CONFIGURATIE"
    echo ""
    
    echo "Zoeken naar USB devices..."
    echo ""
    
    if [[ "$OS" == "Mac" ]]; then
        usb_devices=($(ls /dev/tty.usb* 2>/dev/null))
    else
        usb_devices=($(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null))
    fi
    
    if [ ${#usb_devices[@]} -gt 0 ]; then
        echo -e "${GREEN}Gevonden USB devices:${NC}"
        for i in "${!usb_devices[@]}"; do
            echo "  [$((i+1))] ${usb_devices[$i]}"
        done
        echo ""
        read -p "Kies device (1-${#usb_devices[@]}): " device_choice
        
        if [[ "$device_choice" =~ ^[0-9]+$ ]] && [ "$device_choice" -ge 1 ] && [ "$device_choice" -le ${#usb_devices[@]} ]; then
            USB_PORT="${usb_devices[$((device_choice-1))]}"
        else
            USB_PORT="$device_choice"
        fi
    else
        read -p "Geef USB device (bijv. /dev/ttyUSB0): " USB_PORT
    fi
    
    echo ""
    read -p "Duur in seconden (standaard 30): " duration_input
    DURATION=${duration_input:-30}
    
    SAMPLE_RATE=3200
    
    cat > config.txt << EOF
USB_PORT=$USB_PORT
DURATION=$DURATION
SAMPLE_RATE=$SAMPLE_RATE
EOF
    
    echo ""
    echo -e "${GREEN}[OK] Configuratie opgeslagen${NC}"
    echo "   USB Device: $USB_PORT"
    echo "   Duur: $DURATION seconden"
    echo ""
    read -p "Druk op ENTER..."
}

show_help() {
    clear
    echo ""
    echo "HELP"
    echo ""
    echo "QUICK START:"
    echo "  1. Run ./install.sh (eerste keer)"
    echo "  2. Monteer ADXL345 op nozzle"
    echo "  3. Download adxl_test_movements.gcode van GitHub"
    echo "  4. Kies optie [1]"
    echo "  5. Start G-code bestand op printer"
    echo "  6. Kopieer G-code naar printer"
    echo ""
    echo "PRINTER BEWEGINGEN (tijdens data verzameling):"
    echo "  Download: adxl_test_movements.gcode van GitHub"
    echo "  https://github.com/werkplaatsmarc/3d-printer-kalibratie"
    echo ""
    echo "  - Zet bestand op SD kaart"
    echo "  - Start via LCD menu of Pronterface/OctoPrint"
    echo "  - Bestand wacht 5 seconden voordat bewegingen starten"
    echo "  - Totale duur: ~45 seconden"
    echo ""
    echo "LINKS:"
    echo "  - GitHub: github.com/werkplaatsmarc/3d-printer-kalibratie"
    echo "  - Website: werkplaatsmarc.be"
    echo ""
    read -p "Druk op ENTER..."
}

while true; do
    show_menu
    read -p "Keuze (1-6): " choice
    
    case $choice in
        1) full_calibration ;;
        2) collect_only ;;
        3) analyze_only ;;
        4) configure ;;
        5) show_help ;;
        6) 
            echo ""
            echo "Bedankt!"
            echo ""
            exit 0
            ;;
        *) 
            sleep 1
            ;;
    esac
done