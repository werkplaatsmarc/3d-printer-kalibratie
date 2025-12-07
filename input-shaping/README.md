# 🔧 Input Shaping Kalibratie - Werkplaats Marc

**Nederlandse Input Shaping Tutorial voor 3D Printers**

Elimineer ghosting en ringing op je 3D printer met automatische resonantie analyse. Deze repository bevat tools en documentatie voor zowel **Marlin** als **Klipper** firmware.

![Input Shaping](https://img.shields.io/badge/Input%20Shaping-v2.0-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Mac%20%7C%20Linux-green)
![Firmware](https://img.shields.io/badge/Firmware-Marlin%20%7C%20Klipper-orange)

---

## 🎯 Welke Firmware Heb Je?

Input Shaping werkt anders op Marlin en Klipper. Kies hieronder:

| **Firmware**   | **Gebruik Deze Tools** | **Workflow**                                       |
| -------------- | ---------------------- | -------------------------------------------------- |
| 🔴 **Marlin**  | ✅ Tools in deze repo  | ADXL345 → USB → PC → Automatische analyse → G-code |
| 🟢 **Klipper** | ❌ Geen tools nodig    | ADXL345 → Raspberry Pi → Native Klipper commands   |

### Hoe weet ik welke firmware ik heb?

**Methode 1: M115 Command**

```gcode
M115
```

Response toont firmware type en versie.

**Methode 2: Interface**

- **Marlin:** LCD scherm, SD kaart, soms OctoPrint
- **Klipper:** Altijd Raspberry Pi + Mainsail/Fluidd web interface

**Methode 3: Raspberry Pi**

- **Heeft Raspberry Pi:** Waarschijnlijk Klipper
- **Geen Raspberry Pi:** Waarschijnlijk Marlin

---

## 📦 Repository Structuur

```
input-shaping/
├── README.md                          ← Je bent hier
├── ringing_tower.stl                  ← Test print model (beide firmware)
│
├── Marlin/                            ← Voor Marlin gebruikers
│   ├── README-MARLIN.md              ← Volledige Marlin guide
│   ├── Windows/
│   │   ├── adxl_verzameling.bat      ← Windows GUI tool
│   │   ├── INSTALL.bat               ← Windows installer
│   │   └── python/adxl_collect.py    ← Data verzamel + analyse script
│   └── Mac-Linux/
│       ├── adxl_verzameling.sh       ← Mac/Linux tool
│       ├── install.sh                ← Mac/Linux installer
│       └── python/adxl_collect.py    ← Data verzamel + analyse script
│
└── Klipper/                           ← Voor Klipper gebruikers
    └── README-KLIPPER.md             ← Link naar native Klipper tools
```

---

## 🚀 Quick Start

### Voor **Marlin** Gebruikers:

1. **Download de juiste tool:**

   - **Windows:** Download `Marlin/Windows/` map
   - **Mac/Linux:** Download `Marlin/Mac-Linux/` map

2. **Installeer (eerste keer):**

   - **Windows:** Dubbelklik `INSTALL.bat`
   - **Mac/Linux:** Run `./install.sh`

3. **Gebruik de tool:**

   - **Windows:** Dubbelklik `adxl_verzameling.bat`
   - **Mac/Linux:** Run `./adxl_verzameling.sh`

4. **Kies optie [1]** - Volledige kalibratie
5. **Wacht ~30 seconden** voor data verzameling

6. **Krijg direct resultaten!** ⚡

   ```
   📈 X-as resonantie: 35.2 Hz
   📈 Y-as resonantie: 29.8 Hz

   ⚙️ MARLIN G-CODE:
   M593 X F35.2 D0.1
   M593 Y F29.8 D0.1
   M500
   ```

7. **Kopieer G-code** naar je printer terminal

8. **Klaar!** Print en geniet van 50-80% minder ringing! 🎉

### Voor **Klipper** Gebruikers:

👉 Lees `Klipper/README-KLIPPER.md` voor native Klipper workflow.

**TL;DR:** Sluit ADXL345 aan op je Raspberry Pi en gebruik Klipper's eigen tools - deze repository tools zijn NIET nodig voor Klipper!

---

## 📊 Wat Doet Input Shaping?

**Voor Input Shaping:**

- 😞 Zichtbare ringing (golfpatronen) rondom hoeken
- 😞 Ghosting bij snelle bewegingen
- 😞 Beperkte print snelheden
- 😞 Kwaliteit vs snelheid trade-off

**Na Input Shaping:**

- 😊 50-80% reductie in ringing
- 😊 Gladde oppervlakken bij hoge snelheid
- 😊 20-40% hogere betrouwbare snelheden
- 😊 Professionele print kwaliteit

---

## 🔧 Benodigde Hardware

### Voor Marlin:

- BigTreeTech ADXL345 v2.0 (of compatibel)
- USB-C kabel
- Computer (Windows, Mac of Linux)
- 3D printer met Marlin 2.1.x+ firmware

### Voor Klipper:

- ADXL345 accelerometer
- Raspberry Pi met Klipper
- Jumper wires (voor GPIO verbinding)

---

## 📚 Volledige Documentatie

- **Marlin gebruikers:** Lees `Marlin/README-MARLIN.md`
- **Klipper gebruikers:** Lees `Klipper/README-KLIPPER.md`
- **Website:** [werkplaatsmarc.be/input-shaping.html](https://werkplaatsmarc.be/input-shaping.html)
- **YouTube:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)

---

## ❓ Veelgestelde Vragen

### Kan ik Input Shaping gebruiken met mijn printer?

**Marlin:**

- ✅ Marlin 2.1.x of nieuwer
- ✅ `INPUT_SHAPING_X` en `INPUT_SHAPING_Y` enabled in firmware
- ✅ Check met `M593` command (geen error = ondersteund)

**Klipper:**

- ✅ Alle Klipper versies ondersteunen Input Shaping
- ✅ Gewoon `[input_shaper]` toevoegen aan printer.cfg

### Hoe vaak moet ik kalibreren?

Herkalibreer wanneer je:

- 🔧 Mechanische wijzigingen maakt (nieuwe riemen, lagers, etc.)
- 🏗️ Printer verplaatst of herboouwt
- 📦 Grote hardware upgrades doet
- 📉 Verslechtering in print kwaliteit ziet

**Niet nodig bij:**

- ✅ Verschillende filament types
- ✅ Verschillende print snelheden
- ✅ Normale gebruik

### Werkt dit met alle slicers?

Ja! Input Shaping werkt op firmware niveau, dus het werkt met:

- ✅ Cura
- ✅ PrusaSlicer
- ✅ SuperSlicer
- ✅ Simplify3D
- ✅ Alle andere slicers

---

## 🆘 Hulp Nodig?

1. **Lees de README** voor jouw firmware (Marlin of Klipper)
2. **Check de troubleshooting** sectie in de README
3. **Bekijk de YouTube tutorials**
4. **Stel vragen** via GitHub Issues
5. **Join de Discord** community

---

## 🌐 Links & Resources

- **Website:** [werkplaatsmarc.be](https://werkplaatsmarc.be)
- **YouTube:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)
- **Discord:** [discord.gg/UfztVFcR7g](https://discord.gg/UfztVFcR7g)
- **GitHub:** [github.com/werkplaatsmarc](https://github.com/werkplaatsmarc)

---

## 📜 Changelog

### v2.0.0 (December 2025)

- 🎉 **GROTE UPDATE:** Geïntegreerde FFT analyse
- ✨ Direct G-code output na verzameling
- ✨ Geen web upload meer nodig
- ✨ Offline workflow
- ✨ Verbeterde gebruikerservaring
- 🐛 Diverse bug fixes

### v1.0.0 (Oktober 2025)

- 🎉 Eerste release
- ✅ Windows en Mac/Linux tools
- ✅ Online web analyzer
- ✅ Nederlandse documentatie

---

## 📄 Licentie

MIT License - Zie LICENSE bestand voor details.

Open source project voor de Nederlandse maker community! 🇳🇱

---

## 💖 Credits

**Ontwikkeld door:** Marc - Werkplaats Marc  
**Community:** Nederlandse 3D printing makers  
**Dank aan:** Alle testers en contributors!

---

**Veel succes met je Input Shaping kalibratie!** 🚀
