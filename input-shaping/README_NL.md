# 🔧 Input Shaping Kalibratie

**Werkplaats Marc - Nederlandse Input Shaping Tutorial**

Elimineer ghosting en ringing op je 3D printer met Marlin of Klipper firmware door gebruik te maken van automatische resonantie analyse met de BigTreeTech ADXL345 accelerometer.

---

## 📋 Inhoudsopgave

1. [Wat is Input Shaping?](#wat-is-input-shaping)
2. [Benodigde Hardware](#benodigde-hardware)
3. [Software Installatie](#software-installatie)
4. [Hardware Setup](#hardware-setup)
5. [Data Verzameling](#data-verzameling)
6. [Data Analyse](#data-analyse)
7. [Firmware Configuratie](#firmware-configuratie)
8. [Troubleshooting](#troubleshooting)
9. [Veelgestelde Vragen](#veelgestelde-vragen)

---

## 🎯 Wat is Input Shaping?

Input Shaping is een geavanceerde firmware techniek die trillingen en resonanties in je 3D printer compenseert. Door bewegingen aan te passen voordat ze uitgevoerd worden, worden vibraties die leiden tot **ghosting** en **ringing** drastisch verminderd.

### Voordelen:

- ✅ 50-80% minder ringing en ghosting
- ✅ 20-40% hogere betrouwbare print snelheden
- ✅ Betere oppervlakte kwaliteit
- ✅ Geen hardware modificaties nodig
- ✅ Werkt met Marlin en Klipper firmware

---

## 🛠️ Benodigde Hardware

### Verplicht:

- **3D Printer** met Marlin 2.1.x+ of Klipper firmware (met Input Shaping support)
- **BigTreeTech ADXL345 v2.0** accelerometer sensor (~€25)
- **USB-C kabel** voor directe verbinding met laptop
- **Windows/Linux/Mac laptop** met Python 3.8 of hoger

### Compatibele Printers:

- Ender 3 (alle varianten)
- Creality CR series
- Prusa i3 MK3/MK4
- Voron series
- Elke printer met Marlin 2.1+ of Klipper

---

## 💻 Software Installatie

### Stap 1: Python Installeren

1. Download Python 3.8 of hoger van [python.org](https://www.python.org/downloads/)
2. Tijdens installatie: **vink "Add Python to PATH" aan!**
3. Verificeer installatie in Command Prompt/Terminal:

```bash
python --version
```

### Stap 2: Repository Downloaden

Download deze repository of clone via Git:

```bash
git clone https://github.com/werkplaatsmarc/3d-printer-kalibratie.git
cd 3d-printer-kalibratie/input-shaping
```

### Stap 3: Dependencies Installeren

Open Command Prompt/Terminal in de `input-shaping` map en installeer alle benodigde libraries:

```bash
pip install -r requirements.txt
```

Dit installeert:

- `pyserial` - Communicatie met ADXL345
- `numpy` - Numerieke berekeningen
- `matplotlib` - Grafiek visualisatie
- `scipy` - FFT en signaal analyse

---

## 🔌 Hardware Setup

### ADXL345 Montage

2. **Monteer de ADXL345** op de nozzle mount met M3 schroeven of zip ties
3. **Verbind USB-C kabel** van ADXL345 naar je laptop

### COM Poort Vinden (Windows)

1. Open **Apparaatbeheer** in Windows
2. Vouw **Poorten (COM & LPT)** uit
3. Zoek naar **USB Serial Device** of **CH340**
4. Noteer het COM poort nummer (bijv. COM3, COM4, etc.)

### USB Device Vinden (Linux/Mac)

```bash
# Linux
ls /dev/ttyUSB*

# Mac
ls /dev/tty.usb*
```

### Script Configureren

Open `adxl_collect.py` en pas de COM poort/device aan:

```python
# Windows
COM_PORT = 'COM3'  # Wijzig naar jouw COM poort

# Linux
COM_PORT = '/dev/ttyUSB0'

# Mac
COM_PORT = '/dev/tty.usbserial-XXXX'
```

---

## 📊 Data Verzameling

### Voorbereiding

1. **Home de printer** (alle assen)
2. **Zorg dat de printer stil staat** tijdens data verzameling
3. **ADXL345 is stevig gemonteerd** op de nozzle
4. **USB-C kabel is aangesloten** op laptop

### Data Verzamelen

Run het collectie script:

```bash
python adxl_collect.py
```

**Wat gebeurt er:**

- Script initialiseert de ADXL345 sensor
- Verzamelt 30 seconden accelerometer data
- Slaat data op in `adxl_data/` directory
- Automatische sampling op 3200 Hz

**Tijdens verzameling:**

- Printer moet **volledig stil staan**
- Geen ventilator trillingen
- Geen externe trillingen (bijv. lopende wasmachine)

**Output:**

```
📊 START DATA VERZAMELING
⏱️  Duur: 30 seconden
📈 Sample rate: 3200 Hz
💾 Output: adxl_data/resonance_test_20250106_143022.csv

🚀 DATA VERZAMELING GESTART!

⏳ 1s / 30s (3%) - 3200 samples verzameld
⏳ 2s / 30s (7%) - 6400 samples verzameld
...
✅ DATA VERZAMELING VOLTOOID!
```

---

## 🔬 Data Analyse

### Automatische Analyse Draaien

Na succesvolle data verzameling, run het analyse script:

```bash
python analyze_data.py
```

**Wat gebeurt er:**

1. Laadt de meest recente data uit `adxl_data/`
2. Voert FFT (Fast Fourier Transform) analyse uit
3. Identificeert dominante resonantie frequenties
4. Berekent optimale Input Shaping parameters
5. Genereert visualisatie grafieken
6. Maakt firmware configuratie (Marlin of Klipper)

**Output:**

```
🔬 WERKPLAATS MARC - RESONANTIE ANALYSE

📁 Laden van: resonance_test_20250106_143022.csv
✅ 96000 samples geladen

📊 Sample rate: 3200.0 Hz
⏱️  Opname duur: 30.0 seconden

🔍 Analyseren van resonantie frequenties...

📈 X-AS RESONANTIES:
   1. 35.2 Hz (magnitude: 0.0842)
   2. 71.4 Hz (magnitude: 0.0234)
   3. 105.8 Hz (magnitude: 0.0156)

📈 Y-AS RESONANTIES:
   1. 29.8 Hz (magnitude: 0.0967)
   2. 59.6 Hz (magnitude: 0.0312)
   3. 89.4 Hz (magnitude: 0.0189)
```

### Resultaten Interpreteren

De analyse vindt **meerdere resonantie frequenties** per as:

- **Primaire resonantie** (hoogste magnitude) = belangrijkste frequentie om te compenseren
- **Secundaire resonanties** = harmonischen of additionele trillingen
- **Magnitude** = sterkte van de trilling (hoger = meer problematisch)

**Grafieken:**
Het script genereert 4 grafieken:

1. **X-as Tijdsdomein** - Ruwe acceleratie data over tijd
2. **Y-as Tijdsdomein** - Ruwe acceleratie data over tijd
3. **X-as Frequentie Spectrum** - FFT analyse met gedetecteerde pieken
4. **Y-as Frequentie Spectrum** - FFT analyse met gedetecteerde pieken

Grafieken worden opgeslagen in `analysis_results/` en automatisch getoond.

---

## ⚙️ Firmware Configuratie

### Voor Marlin Firmware

Het analyse script genereert direct bruikbare Marlin commando's:

```gcode
; Werkplaats Marc - Input Shaping Configuratie
; Gegenereerd op: 2025-01-06 14:35:47

; X-as Input Shaping
M593 X F35.2 D0.10  ; X-as: 35.2 Hz, Damping: 0.10

; Y-as Input Shaping
M593 Y F29.8 D0.10  ; Y-as: 29.8 Hz, Damping: 0.10

; Opslaan in EEPROM
M500

; Verificatie
M593
```

**Configuratie Toepassen:**

1. **Verbind** met je printer via terminal (Pronterface, OctoPrint, etc.)
2. **Kopieer en plak** de M593 commando's een voor een
3. **Run M500** om instellingen op te slaan in EEPROM
4. **Verificeer** met M593 commando

### Voor Klipper Firmware

Voeg de volgende configuratie toe aan je `printer.cfg`:

```ini
[input_shaper]
shaper_freq_x: 35.2
shaper_type_x: mzv
shaper_freq_y: 29.8
shaper_type_y: mzv
```

**Shaper Types:**

- `zv` - Zero Vibration (snelst, minste smoothing)
- `mzv` - Modified Zero Vibration (gebalanceerd)
- `ei` - Extra Insensitive (meeste smoothing)
- `2hump_ei` - Voor complexe resonanties
- `3hump_ei` - Voor zeer complexe resonanties

**Klipper Commando's:**

```gcode
SAVE_CONFIG        # Opslaan configuratie
RESTART            # Herstart Klipper
```

### Input Shaping Uitschakelen (voor vergelijking)

**Marlin:**

```gcode
M593 X F0  ; X-as Input Shaping UIT
M593 Y F0  ; Y-as Input Shaping UIT
```

**Klipper:**

```gcode
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
```

---

## 🧪 Resultaten Valideren

### Test Print Voor/Na Vergelijking

1. **Print een test object ZONDER Input Shaping:**

   - Schakel Input Shaping uit
   - Print een kubus of de ringing tower
   - Let op ringing patronen rondom hoeken

2. **Print hetzelfde object MET Input Shaping:**
   - Schakel Input Shaping in met jouw configuratie
   - Print exact hetzelfde object met dezelfde settings
   - Vergelijk resultaten

### Verwachte Resultaten

**Voor Input Shaping:**

- Zichtbare ringing (golfpatronen) rondom hoeken
- Langere settling tijd na richting wijzigingen
- Minder scherpe hoeken en details

**Na Input Shaping:**

- Minimale of geen ringing patronen
- Scherpe, cleane hoeken
- Betere overall oppervlakte kwaliteit
- Hogere snelheden mogelijk zonder kwaliteitsverlies

---

## 🔧 Troubleshooting

### Probleem: Script kan ADXL345 niet vinden

**Symptomen:**

```
❌ FOUT: Kan niet verbinden met COM3
```

**Oplossingen:**

1. Controleer of USB-C kabel correct is aangesloten
2. Verificeer COM poort/device in Apparaatbeheer (Windows) of via `ls /dev/tty*` (Linux/Mac)
3. Pas `COM_PORT` in `adxl_collect.py` aan
4. Installeer CH340 drivers indien nodig
5. Test een andere USB poort op je laptop

### Probleem: Geen significante resonanties gevonden

**Symptomen:**

```
⚠️  Geen significante resonanties gevonden
```

**Mogelijke oorzaken:**

1. **ADXL345 niet stevig gemonteerd** - sensor moet met nozzle mee trillen
2. **Data verzameld tijdens stilstand** - printer moet kleine bewegingen maken
3. **Sensitiviteit te laag** - verlaag `PEAK_THRESHOLD` in `analyze_data.py`

**Oplossing:**

- Controleer montage van sensor
- Herhaal data verzameling
- Pas analyse parameters aan indien nodig

### Probleem: Python package installatie mislukt

**Symptomen:**

```
ERROR: Could not find a version that satisfies the requirement...
```

**Oplossingen:**

1. Update pip: `python -m pip install --upgrade pip`
2. Installeer packages individueel:
   ```bash
   pip install pyserial
   pip install numpy
   pip install matplotlib
   pip install scipy
   ```
3. Controleer Python versie: `python --version` (moet 3.8+ zijn)

### Probleem: Input Shaping werkt niet op mijn printer

**Marlin Symptomen:**

```
Error: Unknown command M593
```

**Oplossing voor Marlin:**

1. Update naar Marlin 2.1.x of nieuwer
2. Zorg dat `INPUT_SHAPING_X` en `INPUT_SHAPING_Y` enabled zijn in Configuration_adv.h
3. Compileer en flash nieuwe firmware

**Klipper Oplossing:**

- Klipper heeft standaard Input Shaping support
- Voeg `[input_shaper]` sectie toe aan printer.cfg

---

## ❓ Veelgestelde Vragen

### Moet ik dit herhalen na elke print?

**Nee!** Input Shaping parameters worden opgeslagen in firmware configuratie. Ze blijven actief na herstart en power loss.

### Wanneer moet ik opnieuw kalibreren?

Herhaal kalibratie na:

- **Hardware modificaties** (nieuwe stepper motors, frame wijzigingen)
- **Belting aanpassingen** (nieuwe riemen, spanning wijzigingen)
- **Montage wijzigingen** (nieuwe hotend, direct drive conversie)
- **Merkbare print kwaliteit veranderingen**

### Kan ik hogere print snelheden gebruiken?

**Ja!** Input Shaping elimineert trillingen, waardoor je:

- 20-40% hogere snelheden kunt gebruiken
- Zonder kwaliteitsverlies
- Met betere hoek definitie

**Let op:** Start conservatief en verhoog snelheden geleidelijk.

### Werkt dit op mijn printer merk/model?

**Ja!** Input Shaping werkt op elke printer met:

- Marlin 2.1.x+ firmware, OF
- Klipper firmware

Printer merk maakt niet uit (Creality, Prusa, Voron, etc.)

### Wat is de optimale damping factor?

**Voor Marlin ZV shaper:**

- **Start:** 0.10 (gebalanceerd)
- **Meer demping:** 0.15 (conservatiever)
- **Minder demping:** 0.05 (agressiever)

**Voor Klipper:**
Gebruik verschillende shaper types (mzv, ei, etc.) in plaats van damping

### Mijn printer heeft al Klipper, is dit nog nuttig?

**Ja!** Deze scripts werken voor **beide** Marlin en Klipper. De ADXL345 data analyse is universeel bruikbaar.

Voor Klipper kun je ook de ingebouwde tools gebruiken:

```bash
~/klipper/scripts/calibrate_shaper.py
```

---

## 📚 Aanvullende Bronnen

### Werkplaats Marc Community

- **YouTube:** [Input Shaping Tutorial](https://youtube.com/@werkplaatsmarc) Komt binnenkort
- **Discord:** [discord.gg/werkplaatsmarc](https://discord.gg/UfztVFcR7g)
- **Website:** [werkplaatsmarc.be](https://werkplaatsmarc.be)

### Technische Documentatie

- **Marlin Input Shaping:** [marlinfw.org](https://marlinfw.org)
- **Klipper Input Shaping:** [klipper3d.org](https://www.klipper3d.org/Resonance_Compensation.html)
- **ADXL345 Datasheet:** [Analog Devices](https://www.analog.com/en/products/adxl345.html)

---

## 🤝 Bijdragen

Bijdragen zijn welkom! Als je verbeteringen hebt:

1. Fork deze repository
2. Maak een feature branch (`git checkout -b feature/verbeteringen`)
3. Commit je wijzigingen (`git commit -m 'Voeg functie X toe'`)
4. Push naar de branch (`git push origin feature/verbeteringen`)
5. Open een Pull Request

---

## 📄 Licentie

Dit project is open source en beschikbaar onder de MIT Licentie.

**Werkplaats Marc - Nederlandse 3D Print Community**

Gratis kalibratie tools en tutorials voor perfecte prints. Open source, Nederlands, en altijd up-to-date.

---

## 📞 Support

Heb je vragen of loop je vast?

- **YouTube:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)
- **Discord:** [discord.gg/werkplaatsmarc](https://discord.gg/UfztVFcR7g)
- **GitHub Issues:** [Open een issue](https://github.com/werkplaatsmarc/3d-printer-kalibratie/issues)

---

**Veel succes met je Input Shaping kalibratie! 🎉**

_Happy printing!_  
_- Marc, Werkplaats Marc_
