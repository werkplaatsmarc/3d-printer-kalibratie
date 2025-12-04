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