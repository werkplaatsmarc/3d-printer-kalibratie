#!/bin/bash

# ============================================================================
# WERKPLAATS MARC - ADXL345 Data Verzameling Tool
# ============================================================================
# Versie: 1.0
# Platform: Mac/Linux
# GitHub: https://github.com/werkplaatsmarc/3d-printer-kalibratie
# ============================================================================

# Kleuren voor output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuratie variabelen
CONFIG_FILE="config.txt"
PYTHON_DIR="python"
DATA_DIR="adxl_data"

# Functie: Clear screen
clear_screen() {
    clear
}

# Functie: Print header
print_header() {
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                   WERKPLAATS MARC - ADXL345 Tool"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "  🔧 ADXL345 Resonantie Data Verzameling voor Input Shaping"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
}

# Functie: Detecteer OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Mac"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    else
        echo "Unknown"
    fi
}

# Functie: Zoek beschikbare USB poorten
find_usb_ports() {
    local os_type=$(detect_os)
    
    if [[ "$os_type" == "Mac" ]]; then
        # Mac: zoek naar tty.usb* devices
        ls /dev/tty.usb* 2>/dev/null || ls /dev/cu.usb* 2>/dev/null
    elif [[ "$os_type" == "Linux" ]]; then
        # Linux: zoek naar ttyUSB* of ttyACM* devices
        ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null
    fi
}

# Functie: Selecteer USB poort
select_usb_port() {
    local ports=($(find_usb_ports))
    
    if [ ${#ports[@]} -eq 0 ]; then
        echo -e "${RED}❌ Geen USB apparaten gevonden${NC}"
        echo ""
        echo "💡 CONTROLEER:"
        echo "   • ADXL345 is aangesloten via USB"
        echo "   • Driver is geïnstalleerd"
        echo "   • USB kabel werkt correct"
        echo ""
        return 1
    fi
    
    echo -e "${GREEN}📋 Gevonden USB poorten:${NC}"
    echo ""
    
    local i=1
    for port in "${ports[@]}"; do
        echo "  [$i] $port"
        ((i++))
    done
    
    echo ""
    echo -n "Selecteer een poort (1-${#ports[@]}): "
    read selection
    
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#ports[@]}" ]; then
        selected_port="${ports[$((selection-1))]}"
        echo "$selected_port"
        return 0
    else
        echo -e "${RED}❌ Ongeldige keuze${NC}"
        return 1
    fi
}

# Functie: Laad configuratie
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        # Standaard waarden
        DURATION=30
        SAMPLE_RATE=3200
    fi
}

# Functie: Sla configuratie op
save_config() {
    cat > "$CONFIG_FILE" << EOF
USB_PORT="$USB_PORT"
DURATION=$DURATION
SAMPLE_RATE=$SAMPLE_RATE
EOF
    echo -e "${GREEN}✅ Configuratie opgeslagen${NC}"
}

# Functie: Configuratie menu
config_menu() {
    clear_screen
    print_header
    echo ""
    echo "                         CONFIGURATIE"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # USB poort selecteren
    echo -e "${BLUE}🔌 USB Poort Selectie${NC}"
    echo ""
    selected_port=$(select_usb_port)
    if [ $? -eq 0 ]; then
        USB_PORT="$selected_port"
        echo ""
        echo -e "${GREEN}✅ USB poort ingesteld: $USB_PORT${NC}"
    else
        echo ""
        read -p "Druk op Enter om terug te gaan..."
        return
    fi
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # Test duur
    echo -e "${BLUE}⏱️  Data Verzamel Duur${NC}"
    echo "   Aanbevolen: 30 seconden"
    echo ""
    read -p "Duur in seconden (standaard 30): " input_duration
    DURATION=${input_duration:-30}
    
    # Sample rate
    SAMPLE_RATE=3200
    
    echo ""
    echo -e "${GREEN}✅ Configuratie compleet:${NC}"
    echo "   USB Poort: $USB_PORT"
    echo "   Duur: $DURATION seconden"
    echo "   Sample Rate: $SAMPLE_RATE Hz"
    echo ""
    
    save_config
    
    echo ""
    read -p "Druk op Enter om terug te gaan..."
}

# Functie: Help menu
help_menu() {
    clear_screen
    print_header
    echo ""
    echo "                     HELP EN INSTRUCTIES"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📋 BENODIGDHEDEN:"
    echo "   • BigTreeTech ADXL345 v2.0 accelerometer"
    echo "   • USB verbinding naar de computer"
    echo "   • 3D printer met Marlin firmware"
    echo "   • ADXL345 gemonteerd op de nozzle/printhead"
    echo ""
    echo "🔌 AANSLUITING:"
    echo "   1. Sluit ADXL345 aan via USB"
    echo "   2. De tool detecteert automatisch de USB poort"
    echo "   3. Selecteer de juiste poort in het configuratie menu"
    echo ""
    echo "🎯 VOORBEREIDINGEN:"
    echo "   1. Monteer ADXL345 stevig op de printhead/nozzle"
    echo "   2. Zorg dat alle assen vrij kunnen bewegen"
    echo "   3. Printer moet AAN staan maar stil staan"
    echo "   4. Geen obstructies op het printbed"
    echo ""
    echo "📊 DATA VERZAMELING STARTEN:"
    echo "   1. Kies optie [1] in het hoofdmenu"
    echo "   2. Wacht tot de countdown afloopt"
    echo "   3. Tijdens verzameling NIET aan de printer komen"
    echo "   4. Na 30 seconden is de data compleet"
    echo ""
    echo "💾 OUTPUT:"
    echo "   • Data wordt opgeslagen in de map 'adxl_data'"
    echo "   • Bestandsnaam bevat datum en tijd"
    echo "   • CSV formaat voor analyse"
    echo ""
    echo "🔄 VOLGENDE STAP:"
    echo "   Upload het CSV bestand naar:"
    echo "   https://werkplaatsmarc.be/input-shaping.html"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Druk op Enter om terug te gaan..."
}

# Functie: Check Python installatie
check_python() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python3 niet gevonden${NC}"
        echo ""
        echo "💡 INSTALLATIE:"
        
        local os_type=$(detect_os)
        if [[ "$os_type" == "Mac" ]]; then
            echo "   brew install python3"
        elif [[ "$os_type" == "Linux" ]]; then
            echo "   sudo apt-get install python3 python3-pip"
        fi
        echo ""
        return 1
    fi
    return 0
}

# Functie: Check PySerial
check_pyserial() {
    python3 -c "import serial" 2>/dev/null
    return $?
}

# Functie: Installeer PySerial
install_pyserial() {
    echo ""
    echo -e "${YELLOW}⚠️  PySerial niet gevonden - installeren...${NC}"
    python3 -m pip install pyserial --user
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ PySerial succesvol geïnstalleerd${NC}"
        return 0
    else
        echo -e "${RED}❌ FOUT: Kan PySerial niet installeren${NC}"
        return 1
    fi
}

# Functie: Data verzameling
collect_data() {
    clear_screen
    print_header
    echo ""
    echo "                     DATA VERZAMELING STARTEN"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # Laad configuratie
    load_config
    
    # Controleer of configuratie compleet is
    if [ -z "$USB_PORT" ]; then
        echo -e "${RED}❌ USB poort niet geconfigureerd${NC}"
        echo ""
        echo "💡 Ga eerst naar [2] Configuratie wijzigen"
        echo ""
        read -p "Druk op Enter om terug te gaan..."
        return
    fi
    
    echo "📋 Huidige configuratie:"
    echo "   USB Poort: $USB_PORT"
    echo "   Duur: $DURATION seconden"
    echo "   Sample Rate: $SAMPLE_RATE Hz"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "⚠️  CONTROLEER VOOR JE START:"
    echo ""
    echo "   ✓ ADXL345 is aangesloten via USB"
    echo "   ✓ ADXL345 is gemonteerd op de nozzle"
    echo "   ✓ Printer staat AAN maar is stil"
    echo "   ✓ Alle assen kunnen vrij bewegen"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    
    read -p "Klaar om te starten? (j/n): " ready
    if [[ ! "$ready" =~ ^[jJ]$ ]]; then
        return
    fi
    
    echo ""
    echo "🚀 Data verzameling start over 5 seconden..."
    echo "   RAAK DE PRINTER NIET AAN tijdens het verzamelen!"
    echo ""
    
    sleep 5
    
    # Maak output directory
    mkdir -p "$DATA_DIR"
    
    # Genereer bestandsnaam met timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    output_file="$DATA_DIR/resonance_test_$timestamp.csv"
    
    echo "📊 Data verzameling actief..."
    echo ""
    
    # Check Python en PySerial
    if ! check_python; then
        read -p "Druk op Enter om terug te gaan..."
        return
    fi
    
    if ! check_pyserial; then
        if ! install_pyserial; then
            read -p "Druk op Enter om terug te gaan..."
            return
        fi
    fi
    
    # Run Python script
    python3 "$PYTHON_DIR/adxl_collect.py" "$USB_PORT" "$DURATION" "$SAMPLE_RATE" "$output_file"
    
    if [ $? -ne 0 ]; then
        echo ""
        echo -e "${RED}❌ Er is een fout opgetreden tijdens het verzamelen${NC}"
        echo ""
        echo "💡 MOGELIJKE OORZAKEN:"
        echo "   • Verkeerde USB poort (check configuratie)"
        echo "   • ADXL345 niet aangesloten"
        echo "   • Driver niet geïnstalleerd"
        echo "   • Poort al in gebruik door ander programma"
        echo ""
        read -p "Druk op Enter om terug te gaan..."
        return
    fi
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                    ✅ VERZAMELING VOLTOOID!"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "💾 Data opgeslagen in: $output_file"
    echo ""
    echo "🔄 VOLGENDE STAPPEN:"
    echo "   1. Ga naar: https://werkplaatsmarc.be/input-shaping.html"
    echo "   2. Upload het CSV bestand"
    echo "   3. Bekijk de resonantie analyse"
    echo "   4. Kopieer de aanbevolen Input Shaping waarden"
    echo ""
    echo "📁 Wil je de output map openen?"
    echo ""
    read -p "Map openen? (j/n): " open_folder
    if [[ "$open_folder" =~ ^[jJ]$ ]]; then
        local os_type=$(detect_os)
        if [[ "$os_type" == "Mac" ]]; then
            open "$DATA_DIR"
        elif [[ "$os_type" == "Linux" ]]; then
            xdg-open "$DATA_DIR" 2>/dev/null || nautilus "$DATA_DIR" 2>/dev/null || echo "Open handmatig: $DATA_DIR"
        fi
    fi
    
    echo ""
    read -p "Druk op Enter om terug te gaan..."
}

# Functie: Hoofdmenu
main_menu() {
    while true; do
        clear_screen
        print_header
        echo ""
        echo "  [1] Start data verzameling"
        echo "  [2] Configuratie wijzigen"
        echo "  [3] Help en instructies"
        echo "  [4] Afsluiten"
        echo ""
        echo "════════════════════════════════════════════════════════════════════════"
        echo ""
        
        read -p "Maak een keuze (1-4): " choice
        
        case $choice in
            1)
                collect_data
                ;;
            2)
                config_menu
                ;;
            3)
                help_menu
                ;;
            4)
                clear_screen
                echo ""
                echo "════════════════════════════════════════════════════════════════════════"
                echo "          Bedankt voor het gebruik van de ADXL345 Tool!"
                echo "════════════════════════════════════════════════════════════════════════"
                echo ""
                echo "🌐 Meer kalibratie tools: https://werkplaatsmarc.be"
                echo "📺 YouTube tutorials: Werkplaats Marc"
                echo ""
                sleep 3
                exit 0
                ;;
            *)
                echo -e "${RED}Ongeldige keuze. Probeer opnieuw.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Start het programma
main_menu