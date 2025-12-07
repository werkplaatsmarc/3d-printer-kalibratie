<<<<<<< HEAD
#!/bin/bash

# ============================================================================
# WERKPLAATS MARC - ADXL345 Data Verzameling & Analyse Tool
# ============================================================================
# Versie: 2.0 - Nu met geïntegreerde FFT analyse!
# GitHub: https://github.com/werkplaatsmarc/3d-printer-kalibratie
# ============================================================================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="Mac"
    OPEN_CMD="open"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    OPEN_CMD="xdg-open"
    # Fallback voor sommige Linux systemen
    if ! command -v xdg-open &> /dev/null; then
        OPEN_CMD="nautilus"
    fi
else
    OS="Unknown"
    OPEN_CMD="echo"
fi

# Function: Load configuration
load_config() {
    if [ -f "config.txt" ]; then
        source config.txt
    else
        USB_PORT="/dev/ttyUSB0"
        DURATION=30
        SAMPLE_RATE=3200
    fi
}

# Function: Main menu
show_menu() {
    clear
    echo -e "${BLUE}"
    echo "════════════════════════════════════════════════════════════════════════"
    echo "             WERKPLAATS MARC - ADXL345 Tool v2.0 ($OS)"
    echo "════════════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
    echo "  🔧 ADXL345 Resonantie Analyse voor Input Shaping"
    echo "     Nu met GEÏNTEGREERDE FFT ANALYSE!"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "  [1] ⚡ Volledige kalibratie (verzamel + analyse)"
    echo "  [2] 📊 Alleen data verzamelen"
    echo "  [3] 🔬 Analyseer bestaand bestand"
    echo "  [4] ⚙️  Configuratie wijzigen"
    echo "  [5] ❓ Help en instructies"
    echo "  [6] ❌ Afsluiten"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
}

# Function: Full calibration
full_calibration() {
    clear
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                    VOLLEDIGE KALIBRATIE"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "  Deze modus verzamelt data EN voert direct FFT analyse uit!"
    echo "  Je krijgt binnen enkele seconden je Input Shaping configuratie."
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Druk op ENTER om te starten..."
    
    load_config
    
    # Generate output filename
    timestamp=$(date +"%Y%m%d_%H%M%S")
    output_file="adxl_data/resonance_${timestamp}.csv"
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ FOUT: Python3 niet gevonden!${NC}"
        echo "   Run eerst install.sh"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # Check dependencies
    python3 -c "import numpy, scipy" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ FOUT: NumPy/SciPy niet geïnstalleerd!${NC}"
        echo "   Run eerst install.sh"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # Run full calibration
    echo ""
    echo -e "${GREEN}🚀 Start volledige kalibratie...${NC}"
    echo ""
    python3 python/adxl_collect.py "$USB_PORT" $DURATION $SAMPLE_RATE "$output_file"
    
    if [ $? -ne 0 ]; then
        echo ""
        echo -e "${RED}❌ Er is een fout opgetreden${NC}"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # Ask to open folder
    echo ""
    read -p "Wil je de output folder openen? (y/n): " open_folder
    if [[ "$open_folder" =~ ^[Yy]$ ]]; then
        $OPEN_CMD "adxl_data" 2>/dev/null || echo "Kon folder niet openen"
    fi
    
    echo ""
    read -p "Druk op ENTER om terug te gaan..."
}

# Function: Collect only
collect_only() {
    clear
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                    ALLEEN DATA VERZAMELEN"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "  Deze modus verzamelt alleen data ZONDER analyse."
    echo "  Je kunt de analyse later uitvoeren via optie [3]."
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Druk op ENTER om te starten..."
    
    load_config
    
    # Generate output filename
    timestamp=$(date +"%Y%m%d_%H%M%S")
    output_file="adxl_data/data_only_${timestamp}.csv"
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ FOUT: Python3 niet gevonden!${NC}"
        echo "   Run eerst install.sh"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # Collect data without analysis
    echo ""
    echo -e "${GREEN}📊 Start data verzameling...${NC}"
    echo ""
    python3 python/adxl_collect.py "$USB_PORT" $DURATION $SAMPLE_RATE "$output_file" --no-analyze
    
    echo ""
    read -p "Druk op ENTER om terug te gaan..."
}

# Function: Analyze existing file
analyze_only() {
    clear
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                 ANALYSEER BESTAAND BESTAND"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "  Beschikbare CSV bestanden in adxl_data/:"
    echo ""
    
    if ls adxl_data/*.csv 1> /dev/null 2>&1; then
        ls -1 adxl_data/*.csv
    else
        echo "  (Geen bestanden gevonden)"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "Geef bestandsnaam (of volledig pad): " csv_file
    
    if [ -z "$csv_file" ]; then
        echo -e "${RED}❌ Geen bestand opgegeven${NC}"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # If only filename, add adxl_data/ prefix
    if [[ ! "$csv_file" =~ ^/ ]] && [[ ! -f "$csv_file" ]]; then
        csv_file="adxl_data/$csv_file"
    fi
    
    # Check if file exists
    if [ ! -f "$csv_file" ]; then
        echo -e "${RED}❌ FOUT: Bestand niet gevonden: $csv_file${NC}"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # Check dependencies
    python3 -c "import numpy, scipy" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ FOUT: NumPy/SciPy niet geïnstalleerd!${NC}"
        echo "   Run eerst install.sh"
        read -p "Druk op ENTER om terug te gaan..."
        return
    fi
    
    # Run analysis
    echo ""
    echo -e "${GREEN}🔬 Start analyse...${NC}"
    echo ""
    python3 python/adxl_collect.py --analyze "$csv_file"
    
    echo ""
    read -p "Druk op ENTER om terug te gaan..."
}

# Function: Configuration
configure() {
    clear
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                         CONFIGURATIE"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    
    # Auto-detect USB devices
    echo "🔍 Zoeken naar USB devices..."
    echo ""
    
    if [[ "$OS" == "Mac" ]]; then
        usb_devices=($(ls /dev/tty.usb* 2>/dev/null))
    else
        usb_devices=($(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null))
    fi
    
    if [ ${#usb_devices[@]} -gt 0 ]; then
        echo -e "${GREEN}✅ Gevonden USB devices:${NC}"
        for i in "${!usb_devices[@]}"; do
            echo "  [$((i+1))] ${usb_devices[$i]}"
        done
        echo ""
        read -p "Kies een device (1-${#usb_devices[@]}) of geef handmatig op: " device_choice
        
        if [[ "$device_choice" =~ ^[0-9]+$ ]] && [ "$device_choice" -ge 1 ] && [ "$device_choice" -le ${#usb_devices[@]} ]; then
            USB_PORT="${usb_devices[$((device_choice-1))]}"
        else
            USB_PORT="$device_choice"
        fi
    else
        echo -e "${YELLOW}⚠️  Geen USB devices gevonden${NC}"
        echo ""
        read -p "Geef USB device handmatig op (bijv. /dev/ttyUSB0): " USB_PORT
    fi
    
    # Duration
    echo ""
    echo "⏱️  Data verzamel duur"
    echo "   Aanbevolen: 30 seconden"
    echo ""
    read -p "Duur in seconden (standaard 30): " duration_input
    DURATION=${duration_input:-30}
    
    # Sample rate (not changeable but show)
    SAMPLE_RATE=3200
    
    # Save configuration
    cat > config.txt << EOF
USB_PORT=$USB_PORT
DURATION=$DURATION
SAMPLE_RATE=$SAMPLE_RATE
EOF
    
    echo ""
    echo -e "${GREEN}✅ Configuratie opgeslagen:${NC}"
    echo "   USB Device: $USB_PORT"
    echo "   Duur: $DURATION seconden"
    echo "   Target Sample Rate: $SAMPLE_RATE Hz"
    echo ""
    echo "   📝 OPMERKING: De werkelijke sample rate is ~30-60 Hz"
    echo "      door USB communicatie beperkingen. Dit is normaal!"
    echo ""
    read -p "Druk op ENTER om terug te gaan..."
}

# Function: Help
show_help() {
    clear
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    echo "                     HELP EN INSTRUCTIES"
    echo "════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📋 BENODIGDHEDEN:"
    echo "   • BigTreeTech ADXL345 v2.0 accelerometer"
    echo "   • USB verbinding naar je computer"
    echo "   • 3D printer met Marlin of Klipper firmware"
    echo "   • ADXL345 gemonteerd op de nozzle/printhead"
    echo ""
    echo "🔌 AANSLUITING ($OS):"
    echo "   1. Sluit ADXL345 aan via USB op je computer"
    if [[ "$OS" == "Mac" ]]; then
        echo "   2. Check USB device met: ls /dev/tty.usb*"
    else
        echo "   2. Check USB device met: ls /dev/ttyUSB*"
    fi
    echo "   3. Configureer via optie [4]"
    echo ""
    echo "🚀 QUICK START:"
    echo "   1. Run ./install.sh (eerste keer)"
    echo "   2. Monteer ADXL345 stevig op de nozzle"
    echo "   3. Kies optie [1] voor volledige kalibratie"
    echo "   4. Wacht ~30 seconden voor data verzameling"
    echo "   5. Analyse gebeurt automatisch (2-3 seconden)"
    echo "   6. Kopieer de G-code naar je printer terminal"
    echo "   7. Voer M500 uit om op te slaan"
    echo ""
    echo "📊 WORKFLOW OPTIES:"
    echo "   Optie [1] - AANBEVOLEN voor de meeste gebruikers"
    echo "             Doet alles automatisch in één keer"
    echo "   "
    echo "   Optie [2] - Voor gevorderde gebruikers"
    echo "             Verzamel data nu, analyseer later"
    echo "   "
    echo "   Optie [3] - Analyseer oude data opnieuw"
    echo "             Handig voor troubleshooting"
    echo ""
    echo "⚙️  NA KALIBRATIE:"
    echo "   1. Print een test object (ringing tower)"
    echo "   2. Vergelijk met print ZONDER Input Shaping"
    echo "   3. Verwacht 50-80% reductie in ringing"
    echo ""
    echo "🌐 ONLINE RESOURCES:"
    echo "   • GitHub: github.com/werkplaatsmarc/3d-printer-kalibratie"
    echo "   • Website: werkplaatsmarc.be/input-shaping.html"
    echo "   • YouTube: youtube.com/@werkplaatsmarc"
    echo ""
    echo "════════════════════════════════════════════════════════════════════════"
    read -p "Druk op ENTER om terug te gaan..."
}

# Main loop
while true; do
    show_menu
    read -p "Maak een keuze (1-6): " choice
    
    case $choice in
        1) full_calibration ;;
        2) collect_only ;;
        3) analyze_only ;;
        4) configure ;;
        5) show_help ;;
        6) 
            echo ""
            echo "👋 Bedankt voor het gebruiken van Werkplaats Marc ADXL345 Tool!"
            echo "   Bezoek werkplaatsmarc.be voor meer kalibratie guides."
            echo ""
            exit 0
            ;;
        *) 
            echo -e "${RED}Ongeldige keuze${NC}"
            sleep 1
            ;;
    esac
done
=======
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
>>>>>>> cf6473c415b34583da961cdf5fbd2fe95f503f53
