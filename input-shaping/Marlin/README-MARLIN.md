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
