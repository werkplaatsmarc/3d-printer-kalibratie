<<<<<<< HEAD
# 🔴 Input Shaping voor Marlin - Werkplaats Marc

**Volledige Nederlandse Guide voor Marlin Input Shaping met ADXL345**

Deze guide toont je hoe je Input Shaping configureert op Marlin firmware met de BigTreeTech ADXL345 v2.0 accelerometer.

---

## 📦 Wat Heb Je Nodig?

### Hardware:

- ✅ **BigTreeTech ADXL345 v2.0** accelerometer (of compatibel)
- ✅ **USB-C kabel** (voor verbinding met PC)
- ✅ **Computer** (Windows, Mac of Linux)
- ✅ **3D printer met Marlin 2.1.x+** firmware

### Software:

- ✅ **Python 3.8+** (wordt automatisch geïnstalleerd)
- ✅ **NumPy & SciPy** (voor FFT analyse - automatisch)
- ✅ **PySerial** (voor ADXL345 communicatie - automatisch)

### Firmware Vereisten:

- ✅ Marlin 2.1.x of nieuwer
- ✅ `INPUT_SHAPING_X` enabled in firmware
- ✅ `INPUT_SHAPING_Y` enabled in firmware

**Check of je printer dit ondersteunt:**

```gcode
M593
```

Als je **GEEN** error krijgt → Input Shaping is beschikbaar! ✅

---

## 🚀 Quick Start (5 minuten)

### Stap 1: Download de Tool

**Windows:**

```
Download: Marlin/Windows/
Bestanden:
  - adxl_verzameling.bat
  - INSTALL.bat
  - python/adxl_collect.py
```

**Mac/Linux:**

```
Download: Marlin/Mac-Linux/
Bestanden:
  - adxl_verzameling.sh
  - install.sh
  - python/adxl_collect.py
```

### Stap 2: Installeer (Eerste Keer)

**Windows:**

```
1. Dubbelklik INSTALL.bat
2. Wacht tot installatie voltooid is
3. Klaar!
```

**Mac/Linux:**

```bash
chmod +x install.sh
./install.sh
```

**Wat wordt er geïnstalleerd?**

- Python 3 (als nog niet aanwezig)
- PySerial (voor ADXL345 communicatie)
- NumPy (voor numerieke berekeningen)
- SciPy (voor FFT analyse)

### Stap 3: Hardware Setup

1. **Monteer ADXL345** stevig op de nozzle/printhead

   - Gebruik zip ties, schroeven of dubbelzijdig tape
   - Zorg dat het NIET los zit!

2. **Sluit USB-C kabel aan:**

   - ADXL345 → USB poort op je computer
   - NIET op de printer aansluiten!

3. **Check COM poort** (Windows):

   - Open Apparaatbeheer
   - Zoek "Poorten (COM & LPT)"
   - Noteer COM nummer (bijv. COM3)

4. **Check USB device** (Mac/Linux):

   ```bash
   # Mac
   ls /dev/tty.usb*

   # Linux
   ls /dev/ttyUSB*
   ```

### Stap 4: Volledige Kalibratie

**Windows:**

```
1. Dubbelklik adxl_verzameling.bat
2. Kies [1] Volledige kalibratie
3. Wacht ~30 seconden voor data verzameling
4. Analyse gebeurt automatisch!
5. Kopieer de G-code die op scherm verschijnt
```

**Mac/Linux:**

```bash
./adxl_verzameling.sh
# Kies [1] Volledige kalibratie
# Volg instructies op scherm
```

### Stap 5: Activeer Input Shaping

Kopieer de gegenereerde G-code naar je printer terminal:

```gcode
M593 X F35.2 D0.1
M593 Y F29.8 D0.1
M500
```

**Klaar!** Je printer heeft nu Input Shaping geactiveerd! 🎉

---

## 📋 Gedetailleerde Workflow

### Menu Opties Uitgelegd

De tool heeft 6 menu opties:

```
[1] ⚡ Volledige kalibratie (verzamel + analyse)
[2] 📊 Alleen data verzamelen
[3] 🔬 Analyseer bestaand bestand
[4] ⚙️  Configuratie wijzigen
[5] ❓ Help en instructies
[6] ❌ Afsluiten
```

#### Optie 1: Volledige Kalibratie (AANBEVOLEN)

**Wat gebeurt er:**

1. Tool verzamelt 30 seconden accelerometer data
2. FFT analyse wordt automatisch uitgevoerd
3. Resonantie frequenties worden gedetecteerd
4. G-code wordt gegenereerd en getoond
5. Klaar!

**Wanneer gebruiken:**

- ✅ Eerste keer Input Shaping instellen
- ✅ Na mechanische wijzigingen
- ✅ Als je snel resultaat wilt

**Output voorbeeld:**

```
════════════════════════════════════════════════════════════════════════
📊 RESONANTIE ANALYSE RESULTATEN
════════════════════════════════════════════════════════════════════════

📈 X-AS GEDETECTEERDE RESONANTIES:
   🔴 1. 35.2 Hz (magnitude: 0.0842)
      2. 70.4 Hz (magnitude: 0.0234)
      3. 105.6 Hz (magnitude: 0.0156)

📈 Y-AS GEDETECTEERDE RESONANTIES:
   🔴 1. 29.8 Hz (magnitude: 0.0967)
      2. 59.6 Hz (magnitude: 0.0312)
      3. 89.4 Hz (magnitude: 0.0178)

════════════════════════════════════════════════════════════════════════
⚙️  MARLIN G-CODE CONFIGURATIE
════════════════════════════════════════════════════════════════════════

; X-as Input Shaping
M593 X F35.2 D0.10

; Y-as Input Shaping
M593 Y F29.8 D0.10

; Opslaan in EEPROM (permanent)
M500

; Verificatie (optioneel)
M593
```

#### Optie 2: Alleen Data Verzamelen

**Wanneer gebruiken:**

- Gevorderde gebruikers
- Wilt data bewaren voor later
- Troubleshooting

**Output:**

- CSV bestand in `adxl_data/` directory
- Geen analyse

#### Optie 3: Analyseer Bestaand Bestand

**Wanneer gebruiken:**

- Data al verzameld met optie [2]
- Opnieuw analyseren met andere settings
- Troubleshooting

**Hoe:**

```
1. Kies [3]
2. Zie lijst van beschikbare CSV bestanden
3. Geef bestandsnaam op
4. Analyse wordt uitgevoerd
5. Resultaat op scherm
```

#### Optie 4: Configuratie

**Instelbare parameters:**

- **COM Poort/USB Device:** Waar ADXL345 is aangesloten
- **Duur:** Hoeveel seconden data verzamelen (standaard 30)
- **Sample Rate:** Target (3200 Hz - niet wijzigbaar)

**TIP:** De werkelijke sample rate is ~30-60 Hz door USB beperkingen. Dit is normaal en voldoende voor Input Shaping!

---

## 🔬 Hoe Werkt de Analyse?

### FFT (Fast Fourier Transform)

De tool gebruikt FFT om resonantie frequenties te detecteren:

1. **Data verzameling:** ADXL345 meet trillingen tijdens printer bewegingen
2. **Windowing:** Hanning window voor betere frequentie resolutie
3. **FFT:** Converteer tijdsdomein → frequentie domein
4. **Peak Detection:** Vind dominante resonanties (10-150 Hz range)
5. **G-code Generatie:** Configureer Marlin met gevonden frequenties

### Wat Betekenen de Pieken?

**Primaire piek (🔴):**

- De **grootste** resonantie frequentie
- Dit is de belangrijkste om te compenseren
- Wordt gebruikt in M593 commando

**Harmonischen (secundair):**

- Veelvouden van de primaire frequentie
- Normaal en verwacht
- Worden automatisch gedempt door Input Shaping

**Voorbeeld:**

```
X-as primair: 35 Hz
Harmonischen: 70 Hz (2x), 105 Hz (3x)
```

---

## ⚙️ Marlin Configuratie

### M593 Commando Uitleg

```gcode
M593 X F35.2 D0.1
```

**Parameters:**

- `X` of `Y` → Welke as
- `F35.2` → Frequentie in Hz (van analyse)
- `D0.1` → Damping factor (0.05-0.15)

### Damping Factor Tuning

**Standaard: 0.10** (aanbevolen voor de meeste printers)

**Als je nog steeds ringing ziet:**

- Verhoog naar `D0.12` of `D0.15`
- Test met print

**Als je layer shifts krijgt:**

- Verlaag naar `D0.08` of `D0.05`
- Marlin gebruikt aggressive compensation

**Experimenteer:**

```gcode
; Test verschillende damping waarden
M593 X F35.2 D0.08
M593 Y F29.8 D0.08
M500

; Print test object

; Probeer dan
M593 X F35.2 D0.12
M593 Y F29.8 D0.12
M500
```

### Verificatie

**Check huidige settings:**

```gcode
M593
```

**Output:**

```
echo: Input Shaping:
echo:  M593 X F35.20 D0.10 (ZV)
echo:  M593 Y F29.80 D0.10 (ZV)
```

**Uitschakelen (troubleshooting):**

```gcode
M593 X F0
M593 Y F0
M500
```

---

## 🧪 Testen & Validatie

### Test Print: Ringing Tower

Download `ringing_tower.stl` uit de repository.

**Print settings:**

- Layer height: 0.2mm
- Wall line count: 2
- Infill: 10%
- **Outer wall speed: 100-120 mm/s** ← Belangrijk!
- No supports
- No brim/raft

### Voor/Na Vergelijking

1. **Print ZONDER Input Shaping:**

   ```gcode
   M593 X F0
   M593 Y F0
   M500
   ; Print ringing tower
   ```

2. **Print MET Input Shaping:**

   ```gcode
   M593 X F35.2 D0.1
   M593 Y F29.8 D0.1
   M500
   ; Print ringing tower
   ```

3. **Vergelijk:**
   - Kijk naar hoeken en edges
   - Verwacht 50-80% minder ringing
   - Gebruik goede verlichting

### Verwachte Resultaten

**Voor Input Shaping:**

- 😞 Zichtbare golf-patronen na hoeken
- 😞 "Ghosting" effect
- 😞 Minder scherpe details

**Na Input Shaping:**

- 😊 Gladde oppervlakken
- 😊 Scherpe hoeken
- 😊 Professionele kwaliteit

---

## 🐛 Troubleshooting

### "FOUT: Kan niet verbinden met COM3"

**Oplossingen:**

1. Check of ADXL345 is aangesloten via USB
2. Verifieer COM poort in Apparaatbeheer (Windows)
3. Probeer andere USB poort
4. Installeer CH340 drivers (indien nodig)
5. Check USB kabel (sommige kabels zijn alleen voor laden)

### "Te weinig samples voor analyse"

**Oorzaken:**

- USB communicatie problemen
- ADXL345 niet correct geïnitialiseerd
- Verkeerde COM poort

**Oplossingen:**

1. Herprobeer data verzameling
2. Check USB verbinding
3. Verifieer COM poort configuratie
4. Probeer andere USB poort

### "Geen significante resonanties gevonden"

**Oorzaken:**

- ADXL345 niet stevig gemonteerd
- Data verzameld tijdens stilstand
- Sensor defect

**Oplossingen:**

1. **Controleer montage** - sensor moet met nozzle mee trillen
2. Zorg dat printer kleine bewegingen maakt tijdens verzameling
3. Test ADXL345 op andere printer
4. Verlaag threshold in script (gevorderd)

### "Python niet gevonden"

**Oplossing:**

1. Run `INSTALL.bat` of `install.sh` opnieuw
2. Download Python van python.org
3. **Belangrijk:** Vink "Add Python to PATH" aan tijdens installatie
4. Herstart computer na installatie

### "NumPy/SciPy niet geïnstalleerd"

**Oplossing:**

```bash
# Windows
python -m pip install numpy scipy --break-system-packages

# Mac/Linux
python3 -m pip install numpy scipy
```

### Layer Shifts na Input Shaping

**Dit is een bekend probleem met aggressieve damping!**

**Oplossingen:**

1. Verlaag damping factor:

   ```gcode
   M593 X F35.2 D0.05
   M593 Y F29.8 D0.05
   M500
   ```

2. Disable Input Shaping op één as:

   ```gcode
   M593 X F35.2 D0.08
   M593 Y F0  ; Y-as uit
   M500
   ```

3. Check riemspanning - te los kan layer shifts veroorzaken

---

## 💡 Tips & Tricks

### Optimale Montage van ADXL345

**DO:**

- ✅ Monteer direct op printhead/nozzle
- ✅ Gebruik stevige bevestiging (schroeven > zip ties > tape)
- ✅ Korte, stijve USB kabel
- ✅ Sensor plat tegen oppervlak

**DON'T:**

- ❌ Los of wiebelend gemonteerd
- ❌ Te ver van nozzle (via long chain)
- ❌ Sensor onder hoek
- ❌ Lange, flexibele USB kabel

### Beste Praktijken

1. **Warm de printer op** voordat je data verzamelt

   - Thermal expansion kan resonanties beïnvloeden
   - Verzamel data bij normale print temperatuur

2. **Herhaal meting** bij twijfel

   - Neem 2-3 metingen
   - Gemiddelde zou consistent moeten zijn (±2 Hz)

3. **Test incrementeel**

   - Start met standaard damping (0.10)
   - Tune alleen als nodig

4. **Documenteer je settings**
   - Bewaar G-code outputs
   - Noteer datum en printer configuratie

### Sample Rate Optimalisatie

De tool probeert 3200 Hz maar haalt ~30-60 Hz door USB limitaties.

**Dit is voldoende omdat:**

- Input Shaping frequenties zijn 10-150 Hz
- Nyquist theorem: sample rate > 2× hoogste frequentie
- 60 Hz sample rate detecteert tot 30 Hz perfect
- Harmonischen geven extra data punten

**Wil je hogere sample rate?**

- Gebruik Klipper met SPI verbinding (kan 3200 Hz halen)
- Voor Marlin is USB de enige optie

---

## 📚 Veelgestelde Vragen

### Moet ik dit herhalen na filament wissel?

**Nee!** Input Shaping compenseert mechanische resonanties, niet filament eigenschappen. Één keer kalibreren is genoeg.

### Werkt dit met bowden EN direct drive?

**Ja!** Input Shaping werkt met beide extruder types. De resonanties zijn mechanisch (frame, riemen, lagers), niet filament path gerelateerd.

### Kan ik sneller printen na Input Shaping?

**Ja!** Typisch kan je:

- 20-40% hogere snelheden gebruiken
- Zonder kwaliteitsverlies
- Vooral outer walls kunnen sneller

**Voorbeeld:**

- Outer walls: 60 mm/s → 80-100 mm/s
- Inner walls: 80 mm/s → 120 mm/s

### Moet ik per printer kalibreren?

**Ja, elke printer is uniek!** Zelfs twee identieke printers hebben verschillende resonanties door:

- Assemblage toleranties
- Riemspanning variaties
- Frame stijfheid verschillen
- Leeftijd en slijtage

### Wat als ik Marlin firmware update?

**Instellingen blijven behouden** als je:

- M500 hebt uitgevoerd (EEPROM save)
- EEPROM niet wist tijdens flash

**Als settings verdwenen zijn:**

- Voer G-code opnieuw in (je hebt het opgeslagen, toch? 😉)
- Of herhaal volledige kalibratie

---

## 🔗 Handige Links

- **Web Analyzer (optioneel):** [werkplaatsmarc.be/adxl345-analyzer.html](https://werkplaatsmarc.be/adxl345-analyzer.html)
- **Input Shaping Guide:** [werkplaatsmarc.be/input-shaping.html](https://werkplaatsmarc.be/input-shaping.html)
- **YouTube Tutorial:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)
- **Marlin Docs:** [marlinfw.org](https://marlinfw.org)

---

## 🆘 Support

**Hulp nodig?**

1. Check deze README
2. Bekijk YouTube tutorials
3. Open GitHub Issue
4. Join Discord community

**Discord:** [discord.gg/UfztVFcR7g](https://discord.gg/UfztVFcR7g)

---

**Veel succes met je Marlin Input Shaping kalibratie!** 🚀

_Gemaakt met ❤️ door Marc - Werkplaats Marc_
=======
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
>>>>>>> cf6473c415b34583da961cdf5fbd2fe95f503f53
