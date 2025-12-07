#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="Mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    OS="Unknown"
fi

clear
echo ""
echo -e "${BLUE}========================================================================${NC}"
echo -e "${BLUE}        WERKPLAATS MARC - ADXL345 Tool Installatie v2.0 ($OS)${NC}"
echo -e "${BLUE}========================================================================${NC}"
echo ""
echo "  Dit script installeert alle benodigde software voor de ADXL345 tool."
echo ""
read -p "Druk op ENTER om te starten..."

echo ""
echo "STAP 1: Python3 Controle"
echo ""

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[X] Python3 is niet geinstalleerd!${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo -e "${GREEN}[OK] Python3 gevonden: versie $PYTHON_VERSION${NC}"

echo ""
echo "STAP 2: pip Controle"
echo ""

if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}[X] pip3 is niet beschikbaar!${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] pip3 is beschikbaar${NC}"
python3 -m pip install --upgrade pip --break-system-packages 2>/dev/null || python3 -m pip install --upgrade pip
echo -e "${GREEN}[OK] pip is up-to-date${NC}"

echo ""
echo "STAP 3: Python Libraries Installeren"
echo ""

echo "Installeren: pyserial..."
python3 -m pip install pyserial --break-system-packages 2>/dev/null || python3 -m pip install pyserial
echo -e "${GREEN}[OK] pyserial geinstalleerd${NC}"

echo ""
echo "Installeren: numpy..."
python3 -m pip install numpy --break-system-packages 2>/dev/null || python3 -m pip install numpy
echo -e "${GREEN}[OK] numpy geinstalleerd${NC}"

echo ""
echo "Installeren: scipy (kan 2-5 minuten duren)..."
python3 -m pip install scipy --break-system-packages 2>/dev/null || python3 -m pip install scipy
echo -e "${GREEN}[OK] scipy geinstalleerd${NC}"

echo ""
echo "STAP 4: Directory Structuur"
echo ""

mkdir -p "adxl_data"
echo -e "${GREEN}[OK] adxl_data directory aangemaakt${NC}"

chmod +x adxl_verzameling.sh 2>/dev/null
echo -e "${GREEN}[OK] Shell script uitvoerbaar gemaakt${NC}"

echo ""
echo "STAP 5: Verificatie"
echo ""

python3 -c "import serial; import numpy; import scipy; print('[OK] Alle libraries geimporteerd')"

echo ""
echo -e "${GREEN}========================================================================${NC}"
echo -e "${GREEN}  INSTALLATIE VOLTOOID!${NC}"
echo -e "${GREEN}========================================================================${NC}"
echo ""
echo "  Run: ./adxl_verzameling.sh"
echo ""