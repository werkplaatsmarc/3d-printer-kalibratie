# 🛠️ Werkplaats Marc - 3D Printer Kalibratie

**Gratis Nederlandse kalibratie bestanden en tutorials voor perfecte 3D prints**

<a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
<a href="https://youtube.com/@werkplaatsmarc" target="_blank"><img src="https://img.shields.io/badge/YouTube-Werkplaats_Marc-red?logo=youtube" alt="YouTube"></a>
<a href="https://werkplaatsmarc.be" target="_blank"><img src="https://img.shields.io/badge/Website-werkplaatsmarc.be-blue" alt="Website"></a>
<a href="https://discord.gg/UfztVFcR7g" target="_blank"><img src="https://img.shields.io/badge/Discord-Community-purple?logo=discord" alt="Discord"></a>

## 🎯 Complete kalibratie serie

Deze repository bevat **4 van de 10 essentiële kalibratie tests** voor je 3D printer. Alle tests (inclusief Bed Nivellering, Z-Afstand, E-Steps, PID Tuning, Flow Rate en Input Shaping) zijn te vinden op **<a href="https://werkplaatsmarc.be" target="_blank">werkplaatsmarc.be</a>** met complete Nederlandse tutorials.

## 📦 Wat zit er in deze repository?

Deze repository bevat **kant-en-klare kalibratie bestanden** voor je 3D printer, allemaal met **Nederlandse instructies**. Geen gedoe met zelf towers maken - download, print, kalibreer.

### 🌡️ Temperatuur Towers

- **PLA** (180-220°C) - Vind de perfecte print temperatuur
- **PETG** (220-250°C) - Test layer adhesie en transparantie
- **ABS** (210-250°C) - Optimaal voor gesloten printers
- **TPU** (210-230°C) - Speciaal voor flexibel filament

### 🔄 Retraction Towers

- **Direct Drive** (1-6mm) - Korte filament pad optimalisatie
- **Bowden** (4-9mm) - Lange tube compensatie
- **TPU Flexibel** (7-12mm) - Voorkomt jamming bij flexibel materiaal

### 🌉 Bridging Test

- **Universeel bridging test** - Optimaliseer cooling en speed voor perfecte overspanningen

### 🎯 Linear Advance Test

- **Universeel pattern** - Werkt voor Marlin K-Factor én Klipper Pressure Advance
- Elimineer blobs en krijg CNC-scherpe hoeken

### 📚 Nederlandse Instructies

Elke test komt met een **complete setup gids** in het Nederlands:

- Hoe te printen
- Hoe te evalueren
- Hoe waarden toe te passen in je firmware
- Troubleshooting tips

## 🔟 Volledige kalibratie roadmap

Voor de **complete 10-stappen kalibratie** (van bed nivellering tot input shaping), bezoek:
👉 **<a href="https://werkplaatsmarc.be" target="_blank">werkplaatsmarc.be</a>**

Daar vind je:

1. Bed Nivellering
2. Z-Afstand
3. E-Steps
4. Temperatuur ⬅️ _in deze repo_
5. PID Tuning
6. Retraction ⬅️ _in deze repo_
7. Linear Advance ⬅️ _in deze repo_
8. Flow Rate
9. Bridging ⬅️ _in deze repo_
10. Input Shaping

## 🚀 Hoe te gebruiken?

### Optie 1: Download via website (makkelijkst)

Bezoek **<a href="https://werkplaatsmarc.be" target="_blank">werkplaatsmarc.be</a>** en download de bestanden die je nodig hebt. Elke downloadknop geeft je automatisch het STL/3MF bestand + Nederlandse setup gids.

### Optie 2: Clone deze repository

```bash
git clone https://github.com/werkplaatsmarc/3d-printer-kalibratie.git
cd 3d-printer-kalibratie
```

## 📁 Repository structuur

```
3d-printer-kalibratie/
├── retraction-towers/
│   ├── retractie-toren-direct-drive-afstand-1-6.3mf
│   ├── retractie-toren-bowden-afstand-4-9.3mf
│   └── retractie-toren-tpu-flexibel-afstand-7-12.3mf
│
├── temperatuur-towers/
│   ├── temperatuur-toren-PLA-180-220.stl
│   ├── temperatuur-toren-PETG-220-250.stl
│   ├── temperatuur-toren-ABS-210-250.stl
│   └── temperatuur-toren-TPU-210-230.stl
│
├── bridging-tests/
│   └── bridging-test-universeel.stl
│
├── linear-advance-tests/
│   └── linear-advance-test-pattern.stl
│
└── instructies/
    ├── retraction-setup-gids.txt
    ├── temperatuur-tower-setup.txt
    ├── bridging-setup-gids.txt
    └── linear-advance-setup.txt
```

## 🎥 Video tutorials

Alle kalibratie stappen worden uitgelegd in de **Werkplaats Marc YouTube serie**:

- <a href="https://youtube.com/@werkplaatsmarc" target="_blank">Basis Kalibratie Deel 1</a> - Temperatuur towers
- <a href="https://youtube.com/@werkplaatsmarc" target="_blank">Geavanceerde Kalibratie Deel 2</a> - Retraction & Linear Advance

## 🤝 Bijdragen

Verbeteringen zijn welkom! Open een issue of pull request als je:

- Betere test models hebt
- Fouten vindt in de instructies
- Nieuwe kalibratie tests wilt toevoegen

## 📝 Licentie

MIT License - Gebruik vrijelijk, ook commercieel. Attributie gewaardeerd maar niet verplicht.

## 🔗 Links

- **Website:** <a href="https://werkplaatsmarc.be" target="_blank">werkplaatsmarc.be</a>
- **YouTube:** <a href="https://youtube.com/@werkplaatsmarc" target="_blank">@werkplaatsmarc</a>
- **Discord:** <a href="https://discord.gg/UfztVFcR7g" target="_blank">Community chat</a>

## ❓ Veelgestelde vragen

**Q: Werken deze bestanden met mijn slicer?**  
A: Ja! STL bestanden werken met Cura, PrusaSlicer, Simplify3D, en alle andere slicers. 3MF bestanden hebben extra metadata maar werken ook overal.

**Q: Moet ik iets aanpassen in mijn slicer?**  
A: Voor temperatuur towers: ja, volg de meegeleverde instructies om temperatuur te wijzigen per laag. Voor bridging en linear advance: nee, gewoon printen.

**Q: Ik heb een probleem met een test, waar kan ik hulp krijgen?**  
A: Join de <a href="https://discord.gg/UfztVFcR7g" target="_blank">Discord community</a> of stel een vraag onder de YouTube video's. De community helpt graag!

**Q: Waar zijn de andere 6 kalibratie tests?**  
A: Bezoek <a href="https://werkplaatsmarc.be" target="_blank">werkplaatsmarc.be</a> voor de complete 10-stappen kalibratie roadmap met alle tutorials en downloads.

---

**Made with ❤️ for the Dutch 3D printing community**

_Laatste update: 2025 - Alle bestanden getest met Marlin, Klipper, Cura en PrusaSlicer_

## 📦 Wat zit er in deze repository?

Deze repository bevat **kant-en-klare kalibratie bestanden** voor je 3D printer, allemaal met **Nederlandse instructies**. Geen gedoe met zelf towers maken - download, print, kalibreer.

### 🌡️ Temperatuur Towers

- **PLA** (180-220°C) - Vind de perfecte print temperatuur
- **PETG** (220-250°C) - Test layer adhesie en transparantie
- **ABS** (210-250°C) - Optimaal voor gesloten printers
- **TPU** (210-230°C) - Speciaal voor flexibel filament

### 🔄 Retraction Towers

- **Direct Drive** (1-6mm) - Korte filament pad optimalisatie
- **Bowden** (4-9mm) - Lange tube compensatie
- **TPU Flexibel** (7-12mm) - Voorkomt jamming bij flexibel materiaal

### 🌉 Bridging Test

- **Universeel bridging test** - Optimaliseer cooling en speed voor perfecte overspanningen

### 🎯 Linear Advance Test

- **Universeel pattern** - Werkt voor Marlin K-Factor én Klipper Pressure Advance
- Elimineer blobs en krijg CNC-scherpe hoeken

### 📚 Nederlandse Instructies

Elke test komt met een **complete setup gids** in het Nederlands:

- Hoe te printen
- Hoe te evalueren
- Hoe waarden toe te passen in je firmware
- Troubleshooting tips

## 🔟 Volledige kalibratie roadmap

Voor de **complete 10-stappen kalibratie** (van bed nivellering tot input shaping), bezoek:
👉 **[werkplaatsmarc.be](https://werkplaatsmarc.be)**

Daar vind je:

1. Bed Nivellering
2. Z-Afstand
3. E-Steps
4. Temperatuur ⬅️ _in deze repo_
5. PID Tuning
6. Retraction ⬅️ _in deze repo_
7. Linear Advance ⬅️ _in deze repo_
8. Flow Rate
9. Bridging ⬅️ _in deze repo_
10. Input Shaping

## 🚀 Hoe te gebruiken?

### Optie 1: Download via website (makkelijkst)

Bezoek **[werkplaatsmarc.be](https://werkplaatsmarc.be)** en download de bestanden die je nodig hebt. Elke downloadknop geeft je automatisch het STL/3MF bestand + Nederlandse setup gids.

### Optie 2: Clone deze repository

```bash
git clone https://github.com/werkplaatsmarc/3d-printer-kalibratie.git
cd 3d-printer-kalibratie
```

## 📁 Repository structuur

```
3d-printer-kalibratie/
├── retraction-towers/
│   ├── retractie-toren-direct-drive-afstand-1-6.3mf
│   ├── retractie-toren-bowden-afstand-4-9.3mf
│   └── retractie-toren-tpu-flexibel-afstand-7-12.3mf
│
├── temperatuur-towers/
│   ├── temperatuur-toren-PLA-180-220.stl
│   ├── temperatuur-toren-PETG-220-250.stl
│   ├── temperatuur-toren-ABS-210-250.stl
│   └── temperatuur-toren-TPU-210-230.stl
│
├── bridging-tests/
│   └── bridging-test-universeel.stl
│
├── linear-advance-tests/
│   └── linear-advance-test-pattern.stl
│
└── instructies/
    ├── retraction-setup-gids.txt
    ├── temperatuur-tower-setup.txt
    ├── bridging-setup-gids.txt
    └── linear-advance-setup.txt
```

## 🎥 Video tutorials

Alle kalibratie stappen worden uitgelegd in de **Werkplaats Marc YouTube serie**:

- [Basis Kalibratie Deel 1](https://youtube.com/@werkplaatsmarc) - Temperatuur towers
- [Geavanceerde Kalibratie Deel 2](https://youtube.com/@werkplaatsmarc) - Retraction & Linear Advance

## 🤝 Bijdragen

Verbeteringen zijn welkom! Open een issue of pull request als je:

- Betere test models hebt
- Fouten vindt in de instructies
- Nieuwe kalibratie tests wilt toevoegen

## 📝 Licentie

MIT License - Gebruik vrijelijk, ook commercieel. Attributie gewaardeerd maar niet verplicht.

## 🔗 Links

- **Website:** [werkplaatsmarc.be](https://werkplaatsmarc.be)
- **YouTube:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)
- **Discord:** [Community chat](https://discord.gg/UfztVFcR7g)

## ❓ Veelgestelde vragen

**Q: Werken deze bestanden met mijn slicer?**  
A: Ja! STL bestanden werken met Cura, PrusaSlicer, Simplify3D, en alle andere slicers. 3MF bestanden hebben extra metadata maar werken ook overal.

**Q: Moet ik iets aanpassen in mijn slicer?**  
A: Voor temperatuur towers: ja, volg de meegeleverde instructies om temperatuur te wijzigen per laag. Voor bridging en linear advance: nee, gewoon printen.

**Q: Ik heb een probleem met een test, waar kan ik hulp krijgen?**  
A: Join de [Discord community](https://discord.gg/UfztVFcR7g) of stel een vraag onder de YouTube video's. De community helpt graag!

**Q: Waar zijn de andere 6 kalibratie tests?**  
A: Bezoek [werkplaatsmarc.be](https://werkplaatsmarc.be) voor de complete 10-stappen kalibratie roadmap met alle tutorials en downloads.

---

**Made with ❤️ for the Dutch 3D printing community**

_Laatste update: 2025 - Alle bestanden getest met Marlin, Klipper, Cura en PrusaSlicer_

### 🌡️ Temperatuur Towers

- **PLA** (180-220°C) - Vind de perfecte print temperatuur
- **PETG** (220-250°C) - Test layer adhesie en transparantie
- **ABS** (210-250°C) - Optimaal voor gesloten printers
- **TPU** (210-230°C) - Speciaal voor flexibel filament

### 🔄 Retraction Towers

- **Direct Drive** (1-6mm) - Korte filament pad optimalisatie
- **Bowden** (4-9mm) - Lange tube compensatie
- **TPU Flexibel** (7-12mm) - Voorkomt jamming bij flexibel materiaal

### 🌉 Bridging Test

- **Universeel bridging test** - Optimaliseer cooling en speed voor perfecte overspanningen

### 🎯 Linear Advance Test

- **Universeel pattern** - Werkt voor Marlin K-Factor én Klipper Pressure Advance
- Elimineer blobs en krijg CNC-scherpe hoeken

### 📚 Nederlandse Instructies

Elke test komt met een **complete setup gids** in het Nederlands:

- Hoe te printen
- Hoe te evalueren
- Hoe waarden toe te passen in je firmware
- Troubleshooting tips

## 🚀 Hoe te gebruiken?

### Optie 1: Download via website (makkelijkst)

Bezoek **[werkplaatsmarc.be](https://werkplaatsmarc.be)** en download de bestanden die je nodig hebt. Elke downloadknop geeft je automatisch het STL/3MF bestand + Nederlandse setup gids.

### Optie 2: Clone deze repository

```bash
git clone https://github.com/werkplaatsmarc/3d-printer-kalibratie.git
cd 3d-printer-kalibratie
```

## 📁 Repository structuur

```
3d-printer-kalibratie/
├── retraction-towers/
│   ├── retractie-toren-direct-drive-afstand-1-6.3mf
│   ├── retractie-toren-bowden-afstand-4-9.3mf
│   └── retractie-toren-tpu-flexibel-afstand-7-12.3mf
│
├── temperatuur-towers/
│   ├── temperatuur-toren-PLA-180-220.stl
│   ├── temperatuur-toren-PETG-220-250.stl
│   ├── temperatuur-toren-ABS-210-250.stl
│   └── temperatuur-toren-TPU-210-230.stl
│
├── bridging-tests/
│   └── bridging-test-universeel.stl
│
├── linear-advance-tests/
│   └── linear-advance-test-pattern.stl
│
└── instructies/
    ├── retraction-setup-gids.txt
    ├── temperatuur-tower-setup.txt
    ├── bridging-setup-gids.txt
    └── linear-advance-setup.txt
```

## 🎥 Video tutorials

Alle kalibratie stappen worden uitgelegd in de **Werkplaats Marc YouTube serie**:

- [Basis Kalibratie Deel 1](https://youtube.com/@werkplaatsmarc) - Temperatuur towers
- [Geavanceerde Kalibratie Deel 2](https://youtube.com/@werkplaatsmarc) - Retraction & Linear Advance

## 🤝 Bijdragen

Verbeteringen zijn welkom! Open een issue of pull request als je:

- Betere test models hebt
- Fouten vindt in de instructies
- Nieuwe kalibratie tests wilt toevoegen

## 📝 Licentie

MIT License - Gebruik vrijelijk, ook commercieel. Attributie gewaardeerd maar niet verplicht.

## 🔗 Links

- **Website:** [werkplaatsmarc.be](https://werkplaatsmarc.be)
- **YouTube:** [@werkplaatsmarc](https://youtube.com/@werkplaatsmarc)
- **Discord:** [Community chat](https://discord.gg/UfztVFcR7g)

## ❓ Veelgestelde vragen

**Q: Werken deze bestanden met mijn slicer?**  
A: Ja! STL bestanden werken met Cura, PrusaSlicer, Simplify3D, en alle andere slicers. 3MF bestanden hebben extra metadata maar werken ook overal.

**Q: Moet ik iets aanpassen in mijn slicer?**  
A: Voor temperatuur towers: ja, volg de meegeleverde instructies om temperatuur te wijzigen per laag. Voor bridging en linear advance: nee, gewoon printen.

**Q: Ik heb een probleem met een test, waar kan ik hulp krijgen?**  
A: Join de [Discord community](https://discord.gg/UfztVFcR7g) of stel een vraag onder de YouTube video's. De community helpt graag!

---

**Made with ❤️ for the Dutch 3D printing community**

_Laatste update: 2025 - Alle bestanden getest met Marlin, Klipper, Cura en PrusaSlicer_
