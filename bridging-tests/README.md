# Bridging Test Generator - Gebruikershandleiding

## 📋 Overzicht

Deze generator helpt je de optimale fan speed of bridge speed te vinden door **3 verschillende instellingen te testen in één print**. De test is verdeeld in 3 hoogtes, zodat je visueel direct kunt zien welke instelling het beste werkt.

## 🎯 Hoe het werkt

### De 3 Test Secties:
- **Sectie 1** (0-20mm hoogte): Onderste deel - Eerste test waarde
- **Sectie 2** (20-40mm hoogte): Middelste deel - Tweede test waarde  
- **Sectie 3** (40-60mm hoogte): Bovenste deel - Derde test waarde

### Waarom dit beter is dan layer-based:
✅ **Visueel duidelijk** - Je ziet direct welk deel beter print  
✅ **Geen verwarring** - Geen layers tellen, gewoon kijken naar onder/midden/boven  
✅ **Flexibel** - Test elke waarde combinatie die je wilt (50-75-100, of 70-80-90, etc.)

---

## 🚀 Stap-voor-Stap Instructies

### STAP 1: Download STL van GitHub

Kies een bridging test STL op basis van wat je wilt testen:

**GitHub locatie:** `github.com/werkplaatsmarc/3d-printer-kalibratie/bridging-tests/`

**Beschikbare STL files:**
- `bridging-test-10mm.stl` - Voor korte bridges (makkelijk)
- `bridging-test-20mm.stl` - Voor normale bridges (standaard)
- `bridging-test-30mm.stl` - Voor langere bridges (uitdagend)
- `bridging-test-40mm.stl` - Voor zeer lange bridges (moeilijk)
- `bridging-test-50mm.stl` - Voor extreme bridges (expert)

**💡 Tip:** Begin met 20mm als je niet zeker bent welke afstand relevant is voor jouw prints.

---

### STAP 2: Slice de STL in je Slicer

**In Cura / PrusaSlicer:**

1. Importeer de STL
2. Gebruik je **normale print instellingen**:
   - Layer hoogte: 0.2mm (aanbevolen)
   - Infill: 20%
   - Nozzle temp: Jouw normale PLA temp (bijv. 200°C)
   - Bed temp: Jouw normale bed temp (bijv. 60°C)
   - **Belangrijk**: Gebruik je HUIDIGE fan speed en bridge speed instellingen

3. Slice het model
4. **Exporteer de G-code**

**⚠️ Belangrijk:** Gebruik geen "Modifier Meshes" of "Height Range" instellingen. Laat de generator dit automatisch regelen!

---

### STAP 3: Open de Generator

Open `bridging-generator.html` in je webbrowser (Chrome, Firefox, Edge)

---

### STAP 4: Kies Test Type

**Optie A: Fan Speed Test** 💨
- Test verschillende cooling percentages
- Gebruik wanneer: Je bridging heeft last van drooping/sagging
-Voorbeeld waardes: 50%, 75%, 100%

**Optie B: Bridge Speed Test** 🚀
- Test verschillende print speeds voor bridges
- Gebruik wanneer: Je wilt sneller printen zonder kwaliteitsverlies
- Voorbeeld waardes: 20mm/s, 30mm/s, 40mm/s

**💡 Tip:** Begin ALTIJD met een Fan Speed Test. Bridge speed pas je pas aan als je optimale fan speed gevonden hebt.

---

### STAP 5: Configureer Test Waardes

#### Voor Fan Speed Test:

**Conservatieve test** (grote stappen):
- Sectie 1: 50%
- Sectie 2: 75%
- Sectie 3: 100%

**Fijnafstemming** (kleine stappen):
- Sectie 1: 70%
- Sectie 2: 80%
- Sectie 3: 90%

**Specifieke vergelijking:**
- Sectie 1: 60%
- Sectie 2: 100%
- Sectie 3: 100%
(Test of 60% al voldoende is)

#### Voor Bridge Speed Test:

**Conservatieve test:**
- Sectie 1: 15mm/s (langzaam, veilig)
- Sectie 2: 25mm/s (normaal)
- Sectie 3: 35mm/s (snel)

**Snelheidstest:**
- Sectie 1: 25mm/s
- Sectie 2: 40mm/s
- Sectie 3: 55mm/s

---

### STAP 6: Upload je G-Code

1. **Klik op het upload veld** of sleep je .gcode bestand ernaartoe
2. Wacht tot het bestand is geladen
3. Je ziet een groene bevestiging met de max Z-hoogte

**Verwachte max Z-hoogte:** Ongeveer 60-65mm (3 secties van elk ~20mm)

---

### STAP 7: Controleer Temperaturen

De generator haalt automatisch je slicer temperaturen over, maar je kunt ze nog aanpassen:

- **Nozzle temp:** Pas aan als je een andere temperatuur wilt testen
- **Bed temp:** Pas aan als je een andere bed temperatuur wilt testen

**💡 Tip:** Test maar één parameter tegelijk. Als je fan speed test, houd dan temperaturen constant!

---

### STAP 8: Genereer G-Code

1. Klik op **"Genereer Bridging Test G-Code"**
2. De aangepaste G-code wordt automatisch gedownload
3. Bestandsnaam: `bridging-fan-test-2024-12-08.gcode` (met datum)

---

### STAP 9: Preview de G-Code (BELANGRIJK!)

**Voor je gaat printen, controleer ALTIJD:**

#### In PrusaSlicer Preview:
1. Open PrusaSlicer
2. File → Import → Import G-code
3. Bekijk de preview
4. **Controleer:** Zie je 3 duidelijke secties?

#### In Tekstbestand (optioneel):
1. Open de .gcode in Kladblok
2. Zoek naar (Ctrl+F): `SECTIE 1`
3. Check of je de juiste waardes ziet:
```gcode
;==========================================
; SECTIE 1: 50%
; Z-hoogte 0-20mm
;==========================================
M106 S127 ; Set fan to 50%
```

4. Zoek naar `SECTIE 2` en `SECTIE 3` voor de andere waardes

---

### STAP 10: Print de Test

1. Kopieer de .gcode naar je SD kaart
2. Start de print
3. **Let op tijdens printen:**
   - Sectie 1 (onderste 20mm): Eerste instelling
   - Sectie 2 (middelste 20mm): Tweede instelling
   - Sectie 3 (bovenste 20mm): Derde instelling

**Print tijd:** Ongeveer 30-40 minuten (afhankelijk van bridge lengte)

---

### STAP 11: Evalueer het Resultaat

#### Bridging Kwaliteit Checklist:

**1. Onderkant (Bottom Surface)**
- ✅ **Perfect:** Glad, geen draden zichtbaar
- ⚠️ **Matig:** Lichte textuur, maar geen doorhang
- ❌ **Slecht:** Losse draden, doorhang, gaten

**2. Spanning**
- ✅ **Perfect:** Strak gespannen, geen doorhang in het midden
- ⚠️ **Matig:** Lichte doorhang (<1mm)
- ❌ **Slecht:** Duidelijke doorhang (>2mm)

**3. Bovenkant (Top Surface)**
- ✅ **Perfect:** Glad oppervlak, goed closed
- ⚠️ **Matig:** Kleine gaten maar geen openings
- ❌ **Slecht:** Grote gaten, slechte layer adhesie

#### Visuele Inspectie Tips:

**Met zaklamp:**
1. Houd een zaklamp onder de bridge
2. Kijk door de print heen
3. **Beste sectie:** Minste licht doorlaat = beste bridging

**Met schuifmaat (optioneel):**
1. Meet de doorhang in het midden van elke sectie
2. **Beste sectie:** Minste doorhang

---

### STAP 12: Pas Instellingen Toe

Zodra je de beste sectie hebt gevonden:

#### Voor Fan Speed Test:

**In Cura:**
1. Preferences → Printers → Machine Settings → Extruder
2. Zoek "Cooling" instellingen
3. Pas "Fan Speed" aan naar je winnende percentage

**In PrusaSlicer:**
1. Print Settings → Cooling
2. Pas "Max fan speed" aan naar je winnende percentage

#### Voor Bridge Speed Test:

**In Cura:**
1. Print Settings → Speed
2. Zoek "Bridge Speed"
3. Pas aan naar je winnende waarde

**In PrusaSlicer:**
1. Print Settings → Speed
2. Zoek "Bridges"
3. Pas aan naar je winnende waarde

---

## 🎓 Voorbeelden & Scenario's

### Scenario 1: Fan Speed te laag

**Symptomen:**
- Sectie 1 (50% fan): Grote doorhang, losse draden
- Sectie 2 (75% fan): Beter, maar nog steeds wat sag
- Sectie 3 (100% fan): Perfect!

**Conclusie:** Gebruik 100% fan voor bridging  
**Actie:** Pas fan speed aan in slicer naar 100%

---

### Scenario 2: Fan Speed optimaliseren

**Symptomen:**
- Sectie 1 (60% fan): Te veel doorhang
- Sectie 2 (80% fan): Perfect bridging!
- Sectie 3 (100% fan): Ook goed, maar geen verbetering

**Conclusie:** 80% fan is sweet spot  
**Actie:** Pas fan speed aan naar 80% (bespaart printtijd & lawaai)

---

### Scenario 3: Bridge Speed te snel

**Symptomen:**
- Sectie 1 (15mm/s): Perfect bridging
- Sectie 2 (25mm/s): Goed bridging
- Sectie 3 (35mm/s): Doorhang, slechte kwaliteit

**Conclusie:** 25mm/s is maximale veilige speed  
**Actie:** Gebruik max 25mm/s voor bridges

---

## ⚙️ Geavanceerde Tips

### Combinatie Testen

**Na je eerste fan test:**
1. Doe een fan speed test → Vind optimale fan speed (bijv. 85%)
2. Pas slicer aan naar 85% fan
3. Slice opnieuw met nieuwe fan setting
4. Doe een bridge speed test → Vind optimale speed
5. Pas beide instellingen toe in je profiel

### Materiaal-Specifieke Profielen

**PLA:**
- Fan: Meestal 75-100%
- Speed: 20-40mm/s

**PETG:**
- Fan: Meestal 30-60% (minder dan PLA!)
- Speed: 15-25mm/s (langzamer dan PLA!)

**ABS:**
- Fan: Meestal 0-30% (zeer weinig!)
- Speed: 20-30mm/s

**TPU:**
- Fan: 50-100%
- Speed: 10-20mm/s (zeer langzaam!)

### Multi-Material Testen

Als je met verschillende materialen werkt:
1. Maak een test voor elk materiaal
2. Label je SD kaart: "PLA-Bridging-Test.gcode", "PETG-Bridging-Test.gcode"
3. Bewaar resultaten in een notitie

---

## 🔧 Troubleshooting

### "Upload eerst een G-code bestand"
**Probleem:** Je probeert te genereren zonder G-code  
**Oplossing:** Upload eerst een geslicete .gcode file

### "Max Z-hoogte: 0mm"
**Probleem:** G-code bevat geen Z-bewegingen  
**Oplossing:** Check of je de juiste file hebt geüpload, slice opnieuw

### Download werkt niet
**Probleem:** Browser blokkeert download  
**Oplossing:** 
- Check browser download instellingen
- Probeer een andere browser (Chrome/Firefox)
- Rechtermuisknop → "Opslaan als..."

### Gcode ziet er raar uit in preview
**Probleem:** Speed test past te veel aan  
**Oplossing:** 
- Gebruik conservatievere speed waardes
- Check baseline speed in generator (standaard 25mm/s)

### Secties niet zichtbaar in print
**Probleem:** Z-detectie mislukt  
**Oplossing:** 
- Check of STL precies 60mm hoog is (3x 20mm)
- Slice met 0.2mm layers
- Check of slicer Z-hop niet interfereert

### Fan changes niet zichtbaar
**Probleem:** Originele M106 commando's overschrijven generator settings  
**Oplossing:** Generator verwijdert automatisch originele M106 commando's, maar check of er geen M107 (fan off) commando's in zitten

---

## 📊 Wat gebeurt er technisch?

### Fan Speed Test:

**Originele G-code:**
```gcode
M106 S255 ; Fan 100% (van slicer)
...
G1 Z5.0
...
```

**Aangepaste G-code:**
```gcode
;==========================================
; SECTIE 1: 50%
; Z-hoogte 0-20mm
;==========================================
M106 S127 ; Set fan to 50%

... printing moves tot Z=20 ...

;==========================================
; SECTIE 2: 75%
; Z-hoogte 20-40mm
;==========================================
M106 S191 ; Set fan to 75%

... printing moves tot Z=40 ...

;==========================================
; SECTIE 3: 100%
; Z-hoogte 40-60mm
;==========================================
M106 S255 ; Set fan to 100%

... printing moves tot Z=60 ...
```

### Bridge Speed Test:

**Originele move:**
```gcode
G1 F1500 X100 Y100 E5.0
```

**Aangepaste move (30mm/s target, baseline 25mm/s):**
```gcode
G1 F1800 X100 Y100 E5.0
```
(1500 * (30/25) = 1800)

---

## 🎯 Veelgestelde Vragen (FAQ)

**Q: Kan ik meer dan 3 secties testen?**  
A: Nee, de generator is ontworpen voor 3 secties. Voor meer granulariteit doe je meerdere tests met verschillende ranges.

**Q: Moet ik altijd bij 0-20-40mm splitsen?**  
A: Ja, dit is hard-coded voor consistentie. Je STL moet dus 60mm hoog zijn.

**Q: Kan ik zowel fan speed als bridge speed tegelijk testen?**  
A: Nee, test één parameter tegelijk voor duidelijke resultaten.

**Q: Werkt dit met elke slicer?**  
A: Ja, zolang de slicer G-code output met Z-coördinaten produceert (alle moderne slicers).

**Q: Moet ik de STL van GitHub gebruiken?**  
A: Niet per se, maar de generator verwacht wel 3 secties van elk 20mm (totaal 60mm).

**Q: Kan ik de secties groter/kleiner maken?**  
A: Niet zonder de generator code aan te passen. 20mm per sectie is optimaal voor duidelijke resultaten.

---

## 📝 Workflow Samenvatting

```
1. Download STL (10/20/30/40/50mm) van GitHub
   ↓
2. Slice in Cura/PrusaSlicer (normale settings)
   ↓
3. Open bridging-generator.html
   ↓
4. Kies: Fan Speed Test OF Bridge Speed Test
   ↓
5. Vul 3 test waardes in
   ↓
6. Upload geslicete G-code
   ↓
7. Genereer aangepaste G-code
   ↓
8. Preview in slicer (optioneel maar aanbevolen)
   ↓
9. Print test (~30-40 min)
   ↓
10. Evalueer: Welke sectie is beste?
   ↓
11. Pas winnende waarde toe in slicer profiel
   ↓
12. Klaar! 🎉
```

---

## 📞 Support

**Website:** werkplaatsmarc.be  
**YouTube:** @werkplaatsmarc  
**GitHub:** github.com/werkplaatsmarc/3d-printer-kalibratie

Heb je vragen of suggesties? Laat een comment achter op YouTube of open een issue op GitHub!

---

**Versie:** 2.0 (Z-hoogte based)  
**Laatst bijgewerkt:** December 2024  
**Auteur:** Marc - Werkplaats Marc

Veel success met je bridging kalibratie! 🌉