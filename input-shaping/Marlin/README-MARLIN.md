# 🔷 Input Shaping voor MARLIN - Werkplaats Marc

**Complete gids voor Input Shaping kalibratie op Marlin firmware**

Deze gids leidt je stap-voor-stap door het proces van Input Shaping kalibratie voor Marlin 2.1.x+ printers met behulp van de ADXL345 accelerometer.

---

## 📋 Inhoudsopgave

1. [Overzicht](#overzicht)
2. [Vereisten](#vereisten)
3. [Platform Keuze](#platform-keuze)
4. [Hardware Setup](#hardware-setup)
5. [Data Verzameling](#data-verzameling)
6. [Online Analyse](#online-analyse)
7. [Marlin Configuratie](#marlin-configuratie)
8. [Verificatie](#verificatie)
9. [Troubleshooting](#troubleshooting)

---

## 🎯 Overzicht

### Workflow Samenvatting

```
1. ADXL345 monteren op nozzle
      ↓
2. ADXL345 via USB naar PC/laptop
      ↓
3. Data verzamelen met tool (Windows/Mac/Linux)
      ↓
4. CSV uploaden naar werkplaatsmarc.be
      ↓
5. Resonantie frequenties krijgen
      ↓
6. Input Shaping configureren in Marlin
      ↓
7. Testen en genieten!
```

### Tijdsinvestering

- **Hardware setup:** 15-30 minuten
- **Data verzameling:** 5 minuten
- **Analyse:** 2 minuten (online)
- **Marlin configuratie:** 5 minuten
- **Totaal:** ~30-45 minuten

---

## ✅ Vereisten

### Hardware

- ✅ **3D Printer** met Marlin 2.1.x+ firmware
- ✅ **BigTreeTech ADXL345 v2.0** accelerometer (~€25)
- ✅ **USB-C kabel** voor ADXL345
- ✅ **Computer** (Windows, Mac, of Linux)
- ✅ **Stevig montagepunt** voor ADXL345 op printhead

### Software

#### Windows:
- Python 3.7+ (wordt automatisch geïnstalleerd via INSTALL.bat)
- PySerial (wordt automatisch geïnstalleerd)

#### Mac/Linux:
- Python 3.7+ (meestal al aanwezig)
- PySerial (wordt automatisch geïnstalleerd)

### Marlin Firmware Check

Controleer of je Marlin Input Shaping support heeft:

1. Open een terminal (Pronterface, OctoPrint, etc.)
2. Stuur commando:
   ```
   M593
   ```
3. **Geen error** = Input Shaping beschikbaar! ✅
4. **Error "Unknown command"** = Update je firmware naar Marlin 2.1.x+

---

## 💻 Platform Keuze

Kies je besturingssysteem:

### Windows
→ [Windows Tools & Instructies](Windows/)

**Bevat:**
- `adxl_verzameling.bat` - Hoofdprogramma
- `INSTALL.bat` - Automatische installatie
- `SNELSTART.md` - Snelstart gids
- Complete Windows workflow

### Mac / Linux
→ [Mac-Linux Tools & Instructies](Mac-Linux/)

**Bevat:**
- `adxl_verzameling.sh` - Hoofdprogramma
- `install.sh` - Automatische installatie
- Automatische USB poort detectie
- Complete Unix workflow

---

## 🔌 Hardware Setup

### Stap 1: ADXL345 Montage

**Belangrijkste regel: STEVIG monteren!**

De ADXL345 moet:
- ✅ Direct op de printhead/nozzle gemonteerd zijn
- ✅ Stevig vastzitten (geen trillingen/beweging)
- ✅ X/Y assen correct georiënteerd zijn

**Montage opties:**
1. **3D geprinte mount** (aanbevolen)
   - Download STL van Thingiverse
   - Print in PETG of ABS voor stabiliteit
   - Gebruik M3 schroeven

2. **Zip-ties** (tijdelijk)
   - Meerdere ties voor stevigheid
   - Controleer dat het niet los zit

3. **Dubbelzijdige tape** (niet aanbevolen)
   - Alleen voor zeer lichte sensoren
   - Grote kans op slechte data

### Stap 2: USB Verbinding

1. Sluit USB-C kabel aan op ADXL345
2. Sluit andere kant aan op je computer
3. Wacht op Windows driver installatie (Windows)
4. LED op ADXL345 zou moeten branden

### Stap 3: COM Poort / Device Vinden

**Windows:**
1. Open Apparaatbeheer (Win + X → Apparaatbeheer)
2. Vouw "Poorten (COM & LPT)" uit
3. Zoek "USB Serial Port" of "CH340"
4. Noteer COM nummer (bijv. COM3)

**Mac:**
```bash
ls /dev/tty.usb*
# of
ls /dev/cu.usb*
```

**Linux:**
```bash
ls /dev/ttyUSB*
# of
ls /dev/ttyACM*
```

---

## 📊 Data Verzameling

### Voor Windows Gebruikers

1. **Installatie (eenmalig):**
   ```
   Dubbelklik: INSTALL.bat
   ```
   - Controleert Python
   - Installeert PySerial
   - Maakt map structuur

2. **Configuratie (eenmalig):**
   ```
   Dubbelklik: adxl_verzameling.bat
   Kies: [2] Configuratie wijzigen
   ```
   - Voer COM poort in (bijv. COM3)
   - Stel duur in (standaard 30 seconden)
   - Configuratie wordt opgeslagen

3. **Data Verzamelen:**
   ```
   Dubbelklik: adxl_verzameling.bat
   Kies: [1] Start data verzameling
   ```

### Voor Mac/Linux Gebruikers

1. **Installatie (eenmalig):**
   ```bash
   cd Mac-Linux
   chmod +x install.sh
   ./install.sh
   ```

2. **Starten:**
   ```bash
   chmod +x adxl_verzameling.sh
   ./adxl_verzameling.sh
   ```

3. **USB poort selecteren:**
   - Tool detecteert automatisch beschikbare poorten
   - Selecteer de juiste uit de lijst

4. **Data verzamelen:**
   - Kies optie [1]
   - Volg de instructies

### Belangrijke Tips Tijdens Verzameling

⚠️ **KRITISCH:**
- Printer moet AAN staan
- Printer moet STIL staan (geen beweging!)
- **RAAK DE PRINTER NIET AAN** tijdens verzameling
- Geen trillingen in de buurt (wasmachine, etc.)
- Ventilators mogen wel aanstaan

**Optimale condities:**
- Alle assen kunnen vrij bewegen
- Printbed leeg (geen obstructies)
- ADXL345 stevig gemonteerd
- USB kabel niet gespannen

### Output

Data wordt opgeslagen als:
```
adxl_data/resonance_test_YYYYMMDD_HHMMSS.csv
```

Formaat:
```csv
Timestamp,X_accel,Y_accel,Z_accel
0.000000,0.012000,0.008000,0.984000
0.000313,0.016000,0.012000,0.980000
...
```

---

## 🌐 Online Analyse

### Stap 1: Upload CSV

1. Ga naar: **[werkplaatsmarc.be/adxl345-analyzer.html](https://werkplaatsmarc.be/adxl345-analyzer.html)**
2. Sleep je CSV bestand naar de upload zone
3. Of klik "Selecteer Bestand" om te bladeren

### Stap 2: Bekijk Resultaten

De tool toont automatisch:

**Frequentie Grafieken:**
- X-as FFT analyse
- Y-as FFT analyse
- Dominante resonantie pieken gemarkeerd

**Aanbevolen Waarden:**
```
X-as: F = 42.5 Hz, Damping = 0.10
Y-as: F = 38.2 Hz, Damping = 0.10
```

**Marlin G-code:**
```gcode
; Input Shaping configuratie
M593 X F42.5 D0.10  ; X-as
M593 Y F38.2 D0.10  ; Y-as
M500                ; Opslaan
```

### Stap 3: Kopieer Waarden

Klik op "Kopieer G-code" om automatisch te kopiëren naar klembord.

---

## ⚙️ Marlin Configuratie

### Methode 1: Via Terminal (Aanbevolen)

1. **Open terminal verbinding:**
   - Pronterface
   - OctoPrint Terminal
   - Simplify3D Machine Control
   - Cura via USB

2. **Stuur configuratie commando's:**
   ```gcode
   M593 X F42.5 D0.10  ; Vervang met jouw X-as waarde
   M593 Y F38.2 D0.10  ; Vervang met jouw Y-as waarde
   M500                ; BELANGRIJK: Opslaan in EEPROM
   ```

3. **Verificatie:**
   ```gcode
   M593            ; Toon huidige Input Shaping instellingen
   ```

   Verwachte output:
   ```
   Input Shaping:
   X: freq=42.5 damping=0.10
   Y: freq=38.2 damping=0.10
   ```

### Methode 2: Via Firmware (Permanent)

Als je regelmatig firmware compileert:

1. **Open Configuration_adv.h**

2. **Zoek naar INPUT_SHAPING sectie:**
   ```cpp
   #define INPUT_SHAPING_X
   #define INPUT_SHAPING_Y
   ```

3. **Voeg je waarden toe:**
   ```cpp
   #define SHAPING_FREQ_X 42.5  // Jouw X-as frequentie
   #define SHAPING_FREQ_Y 38.2  // Jouw Y-as frequentie
   #define SHAPING_ZETA 0.10    // Damping factor
   ```

4. **Compileer en flash firmware**

### Damping Factor Finetuning

Start met **0.10**, pas aan indien nodig:

| Damping | Effect | Wanneer Gebruiken |
|---------|--------|-------------------|
| 0.05 | Agressief, minder demping | Voor zeer stijve frames |
| 0.10 | **Gebalanceerd (aanbevolen)** | Meeste printers |
| 0.15 | Conservatief, meer demping | Voor flexibele frames |

**Symptomen te lage damping:**
- Nog steeds ringing zichtbaar
- Oscillaties bij snelle richtingsveranderingen

**Symptomen te hoge damping:**
- Afgeronde hoeken
- Langzamere bewegingen

---

## ✅ Verificatie

### Stap 1: Print Test Object

**Optie A: Ringing Tower**
- Download: [ringing_tower.stl](../ringing_tower.stl)
- Print instellingen:
  - Snelheid: 100 mm/s
  - Acceleratie: 3000 mm/s²
  - Infill: 15%

**Optie B: Kalibratie Kubus**
- Simpele 20x20x20mm kubus
- Scherpe hoeken belangrijk
- Snelle print snelheid

### Stap 2: Test MET en ZONDER

1. **Print ZONDER Input Shaping:**
   ```gcode
   M593 X F0  ; Schakel X-as uit
   M593 Y F0  ; Schakel Y-as uit
   ```

2. **Print MET Input Shaping:**
   ```gcode
   M593 X F42.5 D0.10  ; Jouw waarden
   M593 Y F38.2 D0.10  ; Jouw waarden
   ```

### Stap 3: Vergelijk Resultaten

**Voor Input Shaping:**
- Zichtbare ringing (golfpatronen)
- Slechte hoek definitie
- Langere settling tijd

**Na Input Shaping:**
- Minimale of geen ringing
- Scherpe, cleane hoeken
- Snellere settling

**Verwacht resultaat: 50-80% minder ringing! 🎉**

---

## 🔧 Troubleshooting

### Tool Problemen

**"Python niet gevonden"**
- Windows: Run INSTALL.bat opnieuw
- Mac/Linux: Installeer Python 3: `brew install python3` (Mac) of `sudo apt install python3` (Linux)

**"Kan niet verbinden met COM3"**
- Verkeerde COM poort → Check Apparaatbeheer
- ADXL345 niet aangesloten → Check USB kabel
- Poort in gebruik → Sluit Pronterface/Cura

**"PySerial niet gevonden"**
```bash
python -m pip install pyserial
# of Mac/Linux:
python3 -m pip install pyserial --user
```

### Data Kwaliteit Problemen

**"Geen significante pieken gevonden"**
- ADXL345 zit los → Monteer strakker
- Te veel ruis → Kortere USB kabel gebruiken
- Verkeerde orientatie → Check X/Y as richting

**"Resultaten inconsistent"**
- Herhaal test meerdere keren
- Gemiddelde van 3 tests nemen
- Check montage tussen tests

### Marlin Problemen

**"Unknown command M593"**
- Marlin versie te oud
- Update naar Marlin 2.1.2 of nieuwer
- Check of INPUT_SHAPING enabled is in Configuration_adv.h

**"Input Shaping werkt niet"**
- Vergeet M500 niet na configuratie!
- Herstart printer na M500
- Verificeer met M593 of instellingen actief zijn

---

## 🎥 Video Tutorial

Volledige video tutorial komt binnenkort op:
📺 **[Werkplaats Marc YouTube](https://youtube.com/@werkplaatsmarc)**

Onderwerpen in de video:
- Hardware setup en montage
- Tool gebruik (Windows/Mac/Linux)
- Online analyse demonstratie
- Marlin configuratie
- Voor/na vergelijking

**Abonneer om de video niet te missen!**

---

## 📚 Aanvullende Informatie

### Marlin Input Shaping Documentatie

- [Marlin Input Shaping PR](https://github.com/MarlinFirmware/Marlin/pull/23797)
- [Marlin Configuration_adv.h Reference](https://marlinfw.org/docs/configuration/configuration_adv.html)

### ADXL345 Informatie

- [BigTreeTech ADXL345 v2.0 Product Page](https://biqu.equipment/products/bigtreetech-adxl345-v2-0)
- [ADXL345 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADXL345.pdf)

### Community

- 💬 Discord: [Werkplaats Marc Community](https://discord.gg/UfztVFcR7g)
- 🌐 Website: [werkplaatsmarc.be](https://werkplaatsmarc.be)
- 📺 YouTube: [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)

---

## ⭐ Success Stories

Heb je Input Shaping succesvol geconfigureerd? Deel je resultaten!

- Tag @werkplaatsmarc op sociale media
- Post voor/na foto's in de Discord
- Help andere makers in de community

---

**Veel succes met je Marlin Input Shaping kalibratie! 🚀**

← [Terug naar hoofdpagina](../README.md)