"""
ADXL345 Data Verzameling Script
Werkplaats Marc - Input Shaping Kalibratie
GitHub: https://github.com/werkplaatsmarc/input-shaping-ender3

Dit script verzamelt accelerometer data van de BigTreeTech ADXL345 v2.0
voor Input Shaping kalibratie op Ender 3 V2 met Marlin firmware.
"""

import serial
import time
import csv
from datetime import datetime
import os

# ============================================================================
# CONFIGURATIE - PAS DIT AAN VOOR JOUW SETUP
# ============================================================================

# COM poort van de ADXL345 (check in Windows Apparaatbeheer)
COM_PORT = 'COM3'  # Wijzig naar jouw COM poort (bijv. COM3, COM4, etc.)
BAUD_RATE = 115200

# Data verzameling instellingen
SAMPLE_DURATION = 30  # Seconden data verzamelen
SAMPLE_RATE = 3200    # Hz - ADXL345 maximum sample rate

# Output bestand
OUTPUT_DIR = 'adxl_data'
OUTPUT_FILE = f'resonance_test_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'

# ============================================================================
# ADXL345 CONFIGURATIE
# ============================================================================

class ADXL345:
    """ADXL345 accelerometer interface klasse"""
    
    # ADXL345 Register adressen
    POWER_CTL = 0x2D
    DATA_FORMAT = 0x31
    BW_RATE = 0x2C
    DATAX0 = 0x32
    
    # Instellingen
    MEASURE_MODE = 0x08
    FULL_RESOLUTION = 0x08
    RANGE_16G = 0x03
    RATE_3200HZ = 0x0F
    
    def __init__(self, serial_port):
        self.serial = serial_port
        self.scale = 0.004  # 4mg per LSB in full resolution mode
        
    def initialize(self):
        """Initialiseer ADXL345 voor hoge snelheid data acquisitie"""
        print("⚙️  ADXL345 initialiseren...")
        
        # Standby mode
        self.write_register(self.POWER_CTL, 0x00)
        time.sleep(0.1)
        
        # Data format: Full resolution, ±16g
        self.write_register(self.DATA_FORMAT, self.FULL_RESOLUTION | self.RANGE_16G)
        
        # Bandwidth rate: 3200 Hz
        self.write_register(self.BW_RATE, self.RATE_3200HZ)
        
        # Measurement mode
        self.write_register(self.POWER_CTL, self.MEASURE_MODE)
        time.sleep(0.1)
        
        print("✅ ADXL345 gereed voor data acquisitie")
        
    def write_register(self, register, value):
        """Schrijf naar ADXL345 register via I2C"""
        cmd = f"W{register:02X}{value:02X}\n"
        self.serial.write(cmd.encode())
        time.sleep(0.01)
        
    def read_acceleration(self):
        """Lees X, Y, Z acceleratie data"""
        # Request data
        cmd = f"R{self.DATAX0:02X}06\n"
        self.serial.write(cmd.encode())
        
        # Lees response
        response = self.serial.readline().decode().strip()
        
        if len(response) >= 12:
            try:
                # Parse hex data naar raw waarden
                x_raw = int(response[0:4], 16)
                y_raw = int(response[4:8], 16)
                z_raw = int(response[8:12], 16)
                
                # Converteer naar signed integers
                if x_raw > 32767:
                    x_raw -= 65536
                if y_raw > 32767:
                    y_raw -= 65536
                if z_raw > 32767:
                    z_raw -= 65536
                
                # Schaal naar g waarden
                x = x_raw * self.scale
                y = y_raw * self.scale
                z = z_raw * self.scale
                
                return x, y, z
            except ValueError:
                return None, None, None
        
        return None, None, None

# ============================================================================
# DATA VERZAMELING
# ============================================================================

def collect_data():
    """Verzamel accelerometer data voor resonantie analyse"""
    
    print("\n" + "="*70)
    print("🔧 WERKPLAATS MARC - ADXL345 DATA VERZAMELING")
    print("="*70 + "\n")
    
    # Maak output directory
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"📁 Output directory aangemaakt: {OUTPUT_DIR}")
    
    # Verbind met ADXL345
    print(f"🔌 Verbinden met {COM_PORT}...")
    
    try:
        ser = serial.Serial(COM_PORT, BAUD_RATE, timeout=1)
        time.sleep(2)  # Wacht op connectie
        print(f"✅ Verbonden met {COM_PORT}\n")
    except serial.SerialException as e:
        print(f"❌ FOUT: Kan niet verbinden met {COM_PORT}")
        print(f"   {e}")
        print("\n💡 TIP: Check COM poort in Windows Apparaatbeheer")
        return
    
    # Initialiseer ADXL345
    adxl = ADXL345(ser)
    adxl.initialize()
    
    print("\n" + "="*70)
    print("📊 START DATA VERZAMELING")
    print("="*70)
    print(f"\n⏱️  Duur: {SAMPLE_DURATION} seconden")
    print(f"📈 Sample rate: {SAMPLE_RATE} Hz")
    print(f"💾 Output: {os.path.join(OUTPUT_DIR, OUTPUT_FILE)}")
    print("\n🎯 INSTRUCTIES:")
    print("   1. Zorg dat de printer stil staat")
    print("   2. ADXL345 is gemonteerd op de nozzle")
    print("   3. Start over 5 seconden...")
    
    for i in range(5, 0, -1):
        print(f"   {i}...")
        time.sleep(1)
    
    print("\n🚀 DATA VERZAMELING GESTART!\n")
    
    # Open CSV bestand
    output_path = os.path.join(OUTPUT_DIR, OUTPUT_FILE)
    
    with open(output_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Timestamp', 'X_accel', 'Y_accel', 'Z_accel'])
        
        start_time = time.time()
        sample_count = 0
        
        # Verzamel data
        while (time.time() - start_time) < SAMPLE_DURATION:
            timestamp = time.time() - start_time
            x, y, z = adxl.read_acceleration()
            
            if x is not None:
                writer.writerow([f"{timestamp:.6f}", f"{x:.6f}", f"{y:.6f}", f"{z:.6f}"])
                sample_count += 1
                
                # Progress indicator elke seconde
                if sample_count % SAMPLE_RATE == 0:
                    elapsed = int(timestamp)
                    remaining = SAMPLE_DURATION - elapsed
                    progress = (elapsed / SAMPLE_DURATION) * 100
                    print(f"⏳ {elapsed}s / {SAMPLE_DURATION}s ({progress:.0f}%) - {sample_count} samples verzameld")
            
            # Controleer sample rate
            time.sleep(1.0 / SAMPLE_RATE)
    
    ser.close()
    
    print("\n" + "="*70)
    print("✅ DATA VERZAMELING VOLTOOID!")
    print("="*70)
    print(f"\n📊 Totaal verzamelde samples: {sample_count}")
    print(f"💾 Data opgeslagen in: {output_path}")
    print(f"\n🔬 VOLGENDE STAP:")
    print(f"   Run: python analyze_data.py")
    print("="*70 + "\n")

# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    try:
        collect_data()
    except KeyboardInterrupt:
        print("\n\n⚠️  Data verzameling gestopt door gebruiker")
    except Exception as e:
        print(f"\n❌ FOUT: {e}")
        import traceback
        traceback.print_exc()