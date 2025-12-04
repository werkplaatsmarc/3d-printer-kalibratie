# 🔧 Input Shaping Kalibratie - Werkplaats Marc

**Nederlandse Input Shaping Tutorial voor 3D Printers**

Elimineer ghosting en ringing op je 3D printer met automatische resonantie analyse. Deze repository bevat tools en documentatie voor zowel **Marlin** als **Klipper** firmware.

![Input Shaping](https://werkplaatsmarc.be/images/input-shaping-banner.png)

---

## 🎯 Welke Firmware Heb Je?

Voordat je begint, bepaal welke firmware je printer gebruikt:

<table>
<tr>
<td width="50%" align="center">

### 🔷 MARLIN FIRMWARE

**Voor printers met Marlin 2.1.x+**

- Ender 3 (stock)
- Creality CR series
- Prusa i3 MK3/MK4 (stock)
- Meeste consumer printers

**→ [Ga naar Marlin Instructies](Marlin/README-MARLIN.md)**

Gebruikt:
- Windows/Mac/Linux tools
- ADXL345 op USB naar PC
- Online analyse tool

</td>
<td width="50%" align="center">

### 🟢 KLIPPER FIRMWARE

**Voor printers met Klipper**

- Voron series
- Custom builds met Raspberry Pi
- Gemodificeerde Ender 3/CR series
- Printers met Mainsail/Fluidd

**→ [Ga naar Klipper Instructies](Klipper/README-KLIPPER.md)**

Gebruikt:
- Direct op Raspberry Pi
- SSH commando's
- Ingebouwde Klipper tools

</td>
</tr>
</table>

---

## ❓ Weet Je Niet Welke Firmware Je Hebt?

### Snelle Check:

1. **Kijk naar je interface:**
   - **LCD scherm** op de printer = waarschijnlijk Marlin
   - **Webbrowser** interface (Mainsail/Fluidd) = Klipper
   - **OctoPrint/Pronterface** = kan beide zijn

2. **Check via terminal/console:**
   ```
   M115
   ```
   - Antwoord bevat "Marlin" → Marlin firmware
   - Antwoord bevat "Klipper" → Klipper firmware

3. **Raspberry Pi aanwezig?**
   - **Geen Raspberry Pi** = bijna zeker Marlin
   - **Raspberry Pi** = waarschijnlijk Klipper (maar kan ook OctoPrint met Marlin zijn)

---

## 📋 Wat is Input Shaping?

Input Shaping is een firmware techniek die trillingen en resonanties in je 3D printer compenseert. Het resultaat:

- ✅ **50-80% minder ringing** (golfpatronen rondom hoeken)
- ✅ **20-40% hogere print snelheden** zonder kwaliteitsverlies
- ✅ **Betere oppervlakte kwaliteit** en scherpere details
- ✅ **Geen hardware modificaties** nodig
- ✅ **Werkt op alle printer types**

### Wat Heb Je Nodig?

**Hardware:**
- BigTreeTech ADXL345 v2.0 accelerometer (~€25)
- USB-C kabel voor ADXL345
- 3D printer met Input Shaping support

**Software:**
- **Marlin:** Windows/Mac/Linux computer + deze tools
- **Klipper:** SSH toegang tot Raspberry Pi (tools al aanwezig)

---

## 🎬 Video Tutorials

### Marlin Input Shaping (Komt Binnenkort)
Volledige tutorial voor Marlin printers met de tools uit deze repository.

**Onderwerpen:**
- ADXL345 installatie en aansluiting
- Data verzameling met Windows/Mac/Linux tools
- Online analyse op werkplaatsmarc.be
- Configuratie in Marlin firmware
- Test prints en verificatie

📺 **[Abonneer op Werkplaats Marc](https://youtube.com/@werkplaatsmarc)** voor updates!

### Klipper Input Shaping (Separaat)
Tutorial specifiek voor Klipper gebruikers met native Klipper tools.

---

## 📁 Repository Structuur

```
input-shaping/
│
├── README.md                          ← Je bent hier
│
├── Marlin/                            
│   ├── README-MARLIN.md              ← Volledige Marlin instructies
│   ├── Windows/                       ← Windows tools
│   │   ├── adxl_verzameling.bat      
│   │   ├── INSTALL.bat
│   │   ├── SNELSTART.md
│   │   └── python/
│   └── Mac-Linux/                     ← Mac/Linux tools
│       ├── adxl_verzameling.sh
│       ├── install.sh
│       └── python/
│
├── Klipper/
│   └── README-KLIPPER.md             ← Klipper documentatie links
│
└── ringing_tower.stl                  ← Test print voor beide
```

---

## 🚀 Snelstart

### Voor Marlin Gebruikers:
1. Download de [Marlin tools](Marlin/)
2. Volg de [Marlin README](Marlin/README-MARLIN.md)
3. Kies je platform (Windows/Mac/Linux)
4. Installeer en start data verzameling
5. Upload naar [werkplaatsmarc.be/adxl345-analyzer.html](https://werkplaatsmarc.be/adxl345-analyzer.html)

### Voor Klipper Gebruikers:
1. Lees de [Klipper README](Klipper/README-KLIPPER.md)
2. SSH naar je Raspberry Pi
3. Gebruik native Klipper commando's
4. Volg de [officiële Klipper documentatie](https://www.klipper3d.org/Resonance_Compensation.html)

---

## 💬 Community & Ondersteuning

### Hulp Nodig?

- 💬 **Discord:** [Werkplaats Marc Community](https://discord.gg/UfztVFcR7g)
- 📺 **YouTube:** [Werkplaats Marc](https://youtube.com/@werkplaatsmarc)
- 🌐 **Website:** [werkplaatsmarc.be](https://werkplaatsmarc.be)
- 🐛 **Bug Report:** [GitHub Issues](https://github.com/werkplaatsmarc/3d-printer-kalibratie/issues)

### Veelgestelde Vragen

**Q: Kan ik Marlin tools gebruiken met Klipper?**
A: Nee, gebruik de native Klipper tools voor beste resultaten.

**Q: Werkt dit op mijn printer merk?**
A: Ja! Zolang je Marlin 2.1.x+ of Klipper hebt, werkt het op elk merk.

**Q: Moet ik dit opnieuw doen na elke print?**
A: Nee, Input Shaping instellingen blijven bewaard in de firmware.

**Q: Kan ik sneller printen na kalibratie?**
A: Ja! Typisch 20-40% hogere snelheden zonder kwaliteitsverlies.

---

## 🤝 Bijdragen

Bijdragen zijn welkom! 

1. Fork deze repository
2. Maak een feature branch (`git checkout -b feature/verbetering`)
3. Commit je wijzigingen (`git commit -m 'Voeg feature X toe'`)
4. Push naar de branch (`git push origin feature/verbetering`)
5. Open een Pull Request

---

## 📄 Licentie

Dit project is open source en beschikbaar onder de **MIT Licentie**.

---

## 🙏 Credits

**Ontwikkeld door:** Marc (Werkplaats Marc)
- 🌐 Website: [werkplaatsmarc.be](https://werkplaatsmarc.be)
- 📺 YouTube: [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)
- 💬 Discord: [Community Server](https://discord.gg/UfztVFcR7g)

**Special thanks:**
- BigTreeTech voor ADXL345 documentatie
- Marlin & Klipper ontwikkelaars
- Nederlandse 3D printing community

---

## ⭐ Support Dit Project

Vind je deze tools waardevol? Overweeg dan:

- ⭐ **Star** deze repository op GitHub
- 📺 **Abonneer** op het [YouTube kanaal](https://youtube.com/@werkplaatsmarc)
- 💬 **Deel** met andere makers in de community
- ☕ **Buy me a coffee** via [de website](https://werkplaatsmarc.be)

---

**Veel succes met je Input Shaping kalibratie! 🚀**

*Voor vragen of problemen, open een [GitHub Issue](https://github.com/werkplaatsmarc/3d-printer-kalibratie/issues) of vraag het in onze [Discord community](https://discord.gg/UfztVFcR7g).*