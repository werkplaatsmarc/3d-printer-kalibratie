<<<<<<< HEAD
# 🟢 Input Shaping voor Klipper - Werkplaats Marc

**Klipper Native Input Shaping Guide**

⚠️ **BELANGRIJK:** Als je Klipper firmware gebruikt, heb je de tools in deze repository **NIET** nodig!

Klipper heeft **native Input Shaping support** die superieur is aan externe tools. Gebruik Klipper's eigen workflow voor de beste resultaten.

---

## 🤔 Waarom Geen Externe Tools voor Klipper?

### Klipper Native Tools zijn Beter:

| Feature          | Klipper Native                                      | Deze Repo Tools |
| ---------------- | --------------------------------------------------- | --------------- |
| **Sample Rate**  | 3200+ Hz (SPI)                                      | ~30-60 Hz (USB) |
| **Verbinding**   | Direct GPIO/SPI                                     | USB naar PC     |
| **Analyse**      | Op Raspberry Pi                                     | Op PC           |
| **Shaper Types** | 7 types (ZV, MZV, EI, 2HUMP_EI, 3HUMP_EI, ZVD, MZV) | Alleen ZV       |
| **Configuratie** | Automatisch                                         | Handmatig       |
| **Real-time**    | Ja                                                  | Nee             |

**Conclusie:** Klipper's native tools zijn **sneller, nauwkeuriger en gemakkelijker!**

---

## 🚀 Klipper Input Shaping Workflow

### Hardware Aansluiting

**Optie 1: SPI Verbinding (AANBEVOLEN)**

```
ADXL345 → Raspberry Pi GPIO pins
  VCC  → 3.3V (pin 1)
  GND  → Ground (pin 6)
  SCL  → GPIO 11 / SCLK (pin 23)
  SDA  → GPIO 10 / MOSI (pin 19)
  SDO  → GPIO 9 / MISO (pin 21)
  CS   → GPIO 8 / CE0 (pin 24)
```

**Optie 2: USB Verbinding (Simpeler)**

```
ADXL345 → USB poort Raspberry Pi
```

Beide methodes werken, maar **SPI is sneller** (3200 Hz vs 100 Hz).

---

## ⚙️ Klipper Configuratie

### 1. printer.cfg Aanpassen

**Voor SPI verbinding:**

```ini
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None
spi_bus: spidev0.0

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # Pas aan voor jouw printer (X, Y, Z)
```

**Voor USB verbinding:**

```ini
[mcu adxl]
serial: /dev/serial/by-id/usb-DEVICE-ID-HERE

[adxl345]
cs_pin: adxl:PA4

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # Pas aan voor jouw printer
```

### 2. Klipper Herstarten

Via Mainsail/Fluidd interface:

- Klik "FIRMWARE RESTART"
- Of via console: `FIRMWARE_RESTART`

### 3. Test ADXL345 Verbinding

```gcode
ACCELEROMETER_QUERY
```

**Verwacht output:**

```
adxl345 values (x, y, z): 470.719200, 470.719200, 9728.196800
```

Als je errors krijgt, check je bedrading/configuratie.

---

## 📊 Resonantie Meting

### Automatische Resonantie Test

**Voor beide assen tegelijk:**

```gcode
SHAPER_CALIBRATE
```

Dit doet:

1. Test bewegingen op X-as
2. Test bewegingen op Y-as
3. Analyseert resonanties
4. Berekent optimale shaper types
5. Slaat configuratie op

**Proces duurt:** ~2-5 minuten

**Output voorbeeld:**

```
Calculating the best input shaper parameters for x axis
Fitted shaper 'zv' frequency = 35.2 Hz (vibrations = 8.2%, smoothing ~= 0.102)
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.1%, smoothing ~= 0.134)
Fitted shaper 'ei' frequency = 39.8 Hz (vibrations = 1.8%, smoothing ~= 0.158)
Fitted shaper '2hump_ei' frequency = 47.4 Hz (vibrations = 0.3%, smoothing ~= 0.188)
Fitted shaper '3hump_ei' frequency = 56.6 Hz (vibrations = 0.1%, smoothing ~= 0.222)
Recommended shaper is ei @ 39.8 Hz
```

### Handmatige Tests (Per As)

**Test alleen X-as:**

```gcode
TEST_RESONANCES AXIS=X
```

**Test alleen Y-as:**

```gcode
TEST_RESONANCES AXIS=Y
```

---

## 🎯 Configuratie Toepassen

### Automatisch (AANBEVOLEN)

Na `SHAPER_CALIBRATE` voer uit:

```gcode
SAVE_CONFIG
```

Dit update automatisch je `printer.cfg` met optimale settings!

### Handmatig

Als je handmatig wilt configureren, voeg toe aan `printer.cfg`:

```ini
[input_shaper]
shaper_freq_x: 35.2
shaper_type_x: ei
shaper_freq_y: 29.8
shaper_type_y: mzv
```

Dan:

```gcode
FIRMWARE_RESTART
```

---

## 📈 Grafieken Genereren (Optioneel)

Voor visuele analyse (advanced):

### 1. Installeer matplotlib op Raspberry Pi

```bash
~/klippy-env/bin/pip install -v matplotlib
```

### 2. Genereer Grafieken

```bash
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

### 3. Download Grafieken

Via SSH of Mainsail/Fluidd file browser.

**Grafieken tonen:**

- Resonantie frequenties
- Shaper vergelijking
- Vibration scores

---

## 🔧 Shaper Types Uitgelegd

Klipper ondersteunt **7 shaper types**:

| Shaper       | Smoothing   | Vibration Reduction | Use Case                            |
| ------------ | ----------- | ------------------- | ----------------------------------- |
| **ZV**       | Laagste     | Matig               | Simpele frames, snelheid prioriteit |
| **MZV**      | Laag        | Goed                | Balans snelheid/kwaliteit           |
| **EI**       | Medium      | Heel goed           | Meeste printers (aanbevolen)        |
| **2HUMP_EI** | Hoog        | Excellent           | Meerdere resonanties                |
| **3HUMP_EI** | Hoogste     | Best                | Complexe resonanties                |
| **ZVD**      | Laag-medium | Zeer goed           | Alternative voor EI                 |
| **MZV**      | Medium      | Zeer goed           | Gevoelige frames                    |

**Standaard aanbeveling:** `EI` of `MZV`

Klipper kiest automatisch de beste voor jouw printer!

---

## ✅ Verificatie & Testen

### Test Print: Ringing Tower

Download `ringing_tower.stl` uit deze repository.

**Print settings:**

- Layer height: 0.2mm
- Walls: 2
- Infill: 10%
- **Outer wall speed: 100-150 mm/s** ← Belangrijk!

### Voor/Na Vergelijking

**Zonder Input Shaping:**

```gcode
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
; Print ringing tower
```

**Met Input Shaping:**

```gcode
; Gebruik auto-configured settings (na SAVE_CONFIG)
; Print ringing tower
```

**Vergelijk:**

- Verwacht 70-95% reductie in ringing (beter dan Marlin!)
- Scherpe hoeken zelfs bij hoge snelheid
- Minimale smoothing

---

## 🐛 Troubleshooting

### "adxl345: Invalid adxl345 id"

**Oorzaak:** ADXL345 niet correct aangesloten of defect

**Oplossingen:**

1. Check bedrading (SPI pins)
2. Verifieer 3.3V power (NIET 5V!)
3. Test met `ACCELEROMETER_QUERY`
4. Probeer andere ADXL345 sensor

### "Unable to read adxl345 data"

**Oorzaak:** SPI communicatie probleem

**Oplossingen:**

1. Enable SPI op Raspberry Pi:
   ```bash
   sudo raspi-config
   # Interfacing Options → SPI → Enable
   ```
2. Check kabel lengte (max 30cm voor SPI)
3. Gebruik shielded cable voor langere afstanden

### Grafieken zijn "noisy"

**Oorzaak:** Slechte montage of mechanische problemen

**Oplossingen:**

1. **Controleer montage** - ADXL345 moet STEVIG zitten
2. Gebruik kortere, stijvere kabels
3. Check riemspanning
4. Verify frame stijfheid

### "recommended shaper exceeds maximum smoothing"

**Betekenis:** Printer heeft sterke resonanties

**Oplossingen:**

1. Accepteer de aanbeveling (Klipper weet wat het doet)
2. Of fix mechanische problemen:
   - Riemspanning check
   - Lagers controleren
   - Frame verstevigen
3. Re-calibrate na fixes

---

## 💡 Advanced Tips

### Meerdere ADXL345 Sensors

Voor ultra-precise kalibratie kan je 2 sensors gebruiken:

- Eén op toolhead (X + Y resonanties)
- Eén op bed (Y + bed resonanties)

**Config:**

```ini
[adxl345 hotend]
cs_pin: rpi:None
spi_bus: spidev0.0

[adxl345 bed]
cs_pin: rpi:None
spi_bus: spidev0.1

[resonance_tester]
accel_chip: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: 100, 100, 20
```

### Real-time Tuning

Klipper kan Input Shaping **tijdens print** aanpassen:

```gcode
SET_INPUT_SHAPER SHAPER_TYPE_X=2HUMP_EI SHAPER_FREQ_X=37.0
; Print test
; Evalueer
SET_INPUT_SHAPER SHAPER_TYPE_X=EI SHAPER_FREQ_X=39.0
; Print test
```

Ideaal voor fine-tuning!

### Per-extruder Calibration (Multi-extruder)

Klipper kan verschillende shapers per extruder:

```ini
[input_shaper]
shaper_freq_x: 35.2
shaper_type_x: ei

# T0 (extruder 0)
[extruder]
# ... config ...

# T1 (extruder 1) - andere shaper
[extruder1]
# ... config ...
```

---

## 🔗 Officiele Klipper Documentatie

**Volledige Klipper Input Shaping Guide:**
https://www.klipper3d.org/Resonance_Compensation.html

**ADXL345 Setup:**
https://www.klipper3d.org/Measuring_Resonances.html

**Klipper Command Reference:**
https://www.klipper3d.org/G-Codes.html#input-shaper

---

## ❓ Veelgestelde Vragen

### Moet ik v2.0 tools gebruiken met Klipper?

**NEE!** Gebruik Klipper's native tools. Deze zijn:

- Sneller (SPI vs USB)
- Nauwkeuriger (3200 Hz vs 60 Hz)
- Automatischer (geen handmatige G-code)
- Beter geïntegreerd

### Kan ik v2.0 tools als backup gebruiken?

Ja, maar het heeft **geen voordelen**. Klipper's tools zijn superieur in elk aspect.

**Enige reden om v2.0 tools te gebruiken:**

- Je wilt data delen met Marlin gebruikers
- Academic interest in FFT analyse
- Debugging doeleinden

### Werkt Klipper Input Shaping met elke printer?

**Ja!** Klipper ondersteunt:

- CoreXY
- Cartesian (Prusa-style)
- Delta
- Polar
- SCARA
- Alle andere kinematica types

### Hoe vaak moet ik re-calibreren?

**Herkalibreer na:**

- Mechanische wijzigingen (riemen, lagers, frame)
- Firmware updates (soms)
- Als print kwaliteit verslechtert

**Niet nodig na:**

- Filament wissel
- Slicer settings wijziging
- Normale gebruik

---

## 📊 Klipper vs Marlin Input Shaping

| Feature               | Klipper         | Marlin          |
| --------------------- | --------------- | --------------- |
| **Shaper Types**      | 7 types         | 1 type (ZV)     |
| **Sample Rate**       | 3200+ Hz        | 30-60 Hz        |
| **Configuratie**      | Auto            | Handmatig       |
| **Real-time Tuning**  | Ja              | Nee             |
| **Grafische Analyse** | Ja              | Via web tool    |
| **Ease of Use**       | ⭐⭐⭐⭐⭐      | ⭐⭐⭐          |
| **Effectiviteit**     | 70-95% reductie | 50-80% reductie |

**Winnaar:** 🟢 **Klipper!**

---

## 🌐 Links & Resources

- **Klipper Docs:** [klipper3d.org](https://www.klipper3d.org)
- **Klipper Discord:** [discord.klipper3d.org](https://discord.klipper3d.org)
- **Werkplaats Marc:** [werkplaatsmarc.be](https://werkplaatsmarc.be)
- **YouTube:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)

---

## 🎉 Conclusie

Als Klipper gebruiker:

1. ✅ Gebruik Klipper's native Input Shaping
2. ✅ Volg de officiele Klipper documentatie
3. ✅ Geniet van superieure resultaten!

**Geen externe tools nodig!** Klipper heeft alles ingebouwd. 🚀

---

**Happy Printing!**

_Deze guide is onderdeel van Werkplaats Marc - Nederlandse 3D Printing Community_
=======
# 🟢 Input Shaping voor KLIPPER - Werkplaats Marc

**Gids voor Input Shaping kalibratie op Klipper firmware**

Voor Klipper printers gebruik je de **native Klipper tools** die direct op je Raspberry Pi draaien. De tools in deze repository zijn **specifiek voor Marlin** en niet nodig voor Klipper.

---

## ⚠️ Belangrijke Mededeling

**Deze repository bevat GEEN Klipper tools.**

Klipper heeft zijn eigen ingebouwde Input Shaping kalibratie systeem dat:
- ✅ Direct op de Raspberry Pi draait
- ✅ ADXL345 rechtstreeks aan Pi verbindt
- ✅ Automatisch alles analyseert en configureert
- ✅ Veel geavanceerder is dan Marlin's systeem

**Workflow verschil:**

| Marlin (deze repo) | Klipper (native) |
|-------------------|------------------|
| ADXL345 → USB → PC | ADXL345 → GPIO/USB → Raspberry Pi |
| Data verzamelen op PC | Data verzamelen op Pi |
| Upload naar website | Alles lokaal op Pi |
| Handmatig configureren | Automatisch configureren |

---

## 🎯 Klipper Input Shaping: De Juiste Weg

### Vereisten

**Hardware:**
- 3D printer met Klipper firmware
- Raspberry Pi (met Klipper geïnstalleerd)
- BigTreeTech ADXL345 v2.0 accelerometer
- **Verbinding:** ADXL345 → Raspberry Pi (GPIO of USB)

**Software:**
- Klipper firmware (al aanwezig op je Pi)
- SSH toegang tot je Raspberry Pi
- Mainsail of Fluidd web interface

### Stap 1: ADXL345 Aansluiten

**Optie A: Via SPI (GPIO pins) - Aanbevolen**

Verbind ADXL345 met Raspberry Pi GPIO:
```
ADXL345    →    Raspberry Pi
VCC        →    3.3V (pin 1)
GND        →    GND (pin 6)
CS         →    GPIO8 (pin 24)
SDO        →    GPIO9 (pin 21)
SDA        →    GPIO10 (pin 19)
SCL        →    GPIO11 (pin 23)
```

**Optie B: Via USB**
- Sluit ADXL345 USB-C kabel aan op Raspberry Pi
- Makkelijker, maar iets hogere latency

### Stap 2: Klipper Configuratie

**SSH naar je Raspberry Pi:**
```bash
ssh pi@mainsailos.local
# of
ssh pi@<IP-adres>
```

**Edit printer.cfg:**
```bash
nano ~/printer_data/config/printer.cfg
```

**Voeg toe (voor SPI verbinding):**
```ini
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None
spi_bus: spidev0.0

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # Pas aan naar jouw bed center
```

**Of voor USB verbinding:**
```ini
[mcu adxl]
serial: /dev/serial/by-id/usb-Klipper_rp2040_xxx  # Check met ls /dev/serial/by-id/

[adxl345]
cs_pin: adxl:gpio1
spi_bus: spi0a

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # Pas aan naar jouw bed center
```

**Herstart Klipper:**
```bash
sudo systemctl restart klipper
```

### Stap 3: ADXL345 Monteren

Monteer de ADXL345 **stevig** op de printhead:
- Direct op hotend mount of toolhead
- Gebruik 3D geprinte bracket of zip-ties
- Zorg dat X/Y assen correct georiënteerd zijn
- **Moet stevig zitten - geen beweging!**

### Stap 4: Test ADXL345

**Via Mainsail/Fluidd console:**
```gcode
ACCELEROMETER_QUERY
```

Verwachte output:
```
adxl345: x:0.012 y:-0.004 z:9.806
```

Als je dit ziet, werkt de ADXL345! ✅

### Stap 5: Data Verzameling

**Test X-as:**
```gcode
TEST_RESONANCES AXIS=X
```

**Test Y-as:**
```gcode
TEST_RESONANCES AXIS=Y
```

Dit duurt elk ~1-2 minuten. De printer beweegt automatisch en meet resonanties.

**Output:**
```
Calculating the best input shaper parameters for x axis
Recommended shaper is mzv @ 57.8 Hz
```

### Stap 6: Grafieken Genereren

**SSH naar Pi:**
```bash
ssh pi@mainsailos.local
cd ~/printer_data/config
```

**Genereer grafieken:**
```bash
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

**Download grafieken:**
- Via Mainsail/Fluidd: Machine tab → View logs
- Of met SCP:
```bash
scp pi@mainsailos.local:/tmp/shaper_calibrate_*.png ~/Downloads/
```

### Stap 7: Input Shaper Configureren

**Voeg toe aan printer.cfg:**
```ini
[input_shaper]
shaper_freq_x: 57.8  # Jouw X-as frequentie
shaper_type_x: mzv   # Jouw X-as type
shaper_freq_y: 52.4  # Jouw Y-as frequentie
shaper_type_y: mzv   # Jouw Y-as type
```

**Herstart Klipper:**
```bash
sudo systemctl restart klipper
```

### Stap 8: Verificatie

**Print test object:**
- Ringing tower
- Snelle kubus met scherpe hoeken
- Vergelijk voor/na

**Verwacht resultaat: 50-80% minder ringing!** 🎉

---

## 📊 Klipper Shaper Types

Klipper heeft meerdere shaper types (Marlin heeft alleen ZV):

| Type | Beschrijving | Beste Voor |
|------|-------------|-----------|
| **ZV** | Zero Vibration | Snelste, minste smoothing |
| **MZV** | Modified ZV | Balans tussen snelheid en kwaliteit |
| **EI** | Extra Insensitive | Goede tolerantie voor variatie |
| **2HUMP_EI** | 2-Hump EI | Breed frequentie bereik |
| **3HUMP_EI** | 3-Hump EI | Zeer breed bereik, meer smoothing |

**Aanbeveling:** Start met **MZV** (meest gebruikt)

---

## 🎥 Video Tutorial (Komt Binnenkort)

Aparte Klipper Input Shaping video op:
📺 **[Werkplaats Marc YouTube](https://youtube.com/@werkplaatsmarc)**

**Onderwerpen:**
- Hardware aansluiting (GPIO vs USB)
- Klipper configuratie
- Data verzameling en analyse
- Shaper type vergelijking
- Voor/na resultaten

**Abonneer om notificatie te krijgen!**

---

## 📚 Officiale Klipper Documentatie

**Verplichte lectuur:**

1. **[Measuring Resonances](https://www.klipper3d.org/Measuring_Resonances.html)**
   - Complete ADXL345 setup
   - GPIO pinout diagrammen
   - Troubleshooting

2. **[Resonance Compensation](https://www.klipper3d.org/Resonance_Compensation.html)**
   - Input Shaper configuratie
   - Shaper type uitleg
   - Tuning tips

3. **[RPi Microcontroller](https://www.klipper3d.org/RPi_microcontroller.html)**
   - Raspberry Pi MCU setup
   - SPI configuratie

---

## 🔧 Troubleshooting

### "ACCELEROMETER_QUERY" geeft geen response

**Oorzaken:**
- ADXL345 niet correct aangesloten
- Verkeerde pins in config
- SPI niet enabled op Pi

**Oplossing:**
```bash
# Check of SPI enabled is
ls /dev/spidev*
# Moet laten zien: /dev/spidev0.0

# Als niet, enable SPI:
sudo raspi-config
# Interface Options → SPI → Enable
```

### "Timer too close" errors

**Oorzaken:**
- Raspberry Pi overbelast
- USB problemen
- Verkeerde baudrate

**Oplossing:**
- Stop ongebruikte services
- Gebruik dedicated Pi voor Klipper
- Check USB kabel kwaliteit

### Inconsistente resultaten

**Oorzaken:**
- ADXL345 zit los
- Trillingen tijdens test
- Versleten riemen/lagers

**Oplossing:**
- Monteer ADXL345 strakker
- Test op verschillende tijden
- Check mechanische staat printer

---

## ❓ Veelgestelde Vragen

### Kan ik de Marlin tools uit deze repo gebruiken?

**Nee.** De Marlin tools in deze repository:
- Werken niet met Klipper
- Zijn niet nodig voor Klipper
- Geven slechtere resultaten dan native Klipper tools

Gebruik altijd de native Klipper tools!

### Moet ik ADXL345 aan PC of Pi aansluiten?

**Aan de Raspberry Pi!** Dit geeft:
- Lagere latency
- Betere integratie
- Automatische analyse
- Geen extra software nodig

### Kan ik ADXL345 permanent gemonteerd laten?

**Technisch wel, maar niet aanbevolen:**
- Extra gewicht op printhead
- Risico op beschadiging
- Extra bekabeling

**Beste praktijk:**
- Monteer voor kalibratie
- Verwijder na kalibratie
- Bewaar veilig voor volgende keer

### Hoe vaak moet ik opnieuw kalibreren?

**Herkalibreer na:**
- Hardware modificaties
- Riemen vervangen
- Lager vervangen
- Frame wijzigingen
- Als ringing plots terugkomt

**Normaal: 1-2x per jaar is voldoende.**

### Welke shaper type is het beste?

**Start met MZV** voor de meeste printers.

Experimenteer indien nodig:
- **Te veel smoothing?** → Probeer ZV
- **Ringing blijft?** → Probeer EI of 2HUMP_EI
- **Breed frequentie bereik?** → 3HUMP_EI

---

## 🔗 Nuttige Links

### Klipper Resources
- [Klipper GitHub](https://github.com/Klipper3d/klipper)
- [Klipper Discourse](https://klipper.discourse.group/)
- [Klipper Discord](https://discord.klipper3d.org/)

### ADXL345 Info
- [BigTreeTech ADXL345 v2.0](https://biqu.equipment/products/bigtreetech-adxl345-v2-0)
- [ADXL345 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADXL345.pdf)

### Werkplaats Marc
- 💬 Discord: [Community Server](https://discord.gg/UfztVFcR7g)
- 🌐 Website: [werkplaatsmarc.be](https://werkplaatsmarc.be)
- 📺 YouTube: [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)

---

## 🎓 Extra: Geavanceerde Klipper Features

### Automatische Shaper Kalibratie

Klipper kan automatisch de beste shaper kiezen:

```gcode
SHAPER_CALIBRATE
```

Dit test alle shaper types en kiest automatisch de beste!

### Per-as Maximum Acceleratie

Na Input Shaping kun je vaak hogere acceleraties gebruiken:

```ini
[printer]
max_accel: 5000  # Verhoog van 3000
max_accel_to_decel: 2500
```

Start conservatief en verhoog geleidelijk!

### Advanced Tuning

Voor perfecte resultaten, experimenteer met:
- `square_corner_velocity`
- `max_accel_to_decel` ratio
- Per-print acceleratie overrides

---

## 💡 Waarom Klipper Native Tools Beter Zijn

**Marlin werkwijze (handmatig):**
1. Data verzamelen op PC
2. Handmatig uploaden naar website
3. Handmatig configureren
4. Beperkt tot ZV shaper

**Klipper werkwijze (automatisch):**
1. Alles gebeurt op de Pi
2. Automatische analyse
3. Automatische configuratie
4. Keuze uit 6 shaper types
5. Real-time preview

**Resultaat: Klipper's systeem is objectief superieur!**

---

**Veel succes met je Klipper Input Shaping kalibratie! 🚀**

← [Terug naar hoofdpagina](../README.md) | [Naar Marlin instructies](../Marlin/README-MARLIN.md)
>>>>>>> cf6473c415b34583da961cdf5fbd2fe95f503f53
