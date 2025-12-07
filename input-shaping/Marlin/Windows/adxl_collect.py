"""
ADXL345 Data Verzameling Script
Werkplaats Marc - Input Shaping Kalibratie
GitHub: https://github.com/werkplaatsmarc/3d-printer-kalibratie

Dit script verzamelt accelerometer data van de BigTreeTech ADXL345 v2.0
voor Input Shaping kalibratie op Ender 3 V2 met Marlin firmware.

Aangepast voor gebruik met batch launcher.
"""

import serial
import time
import csv
from datetime import datetime
import os
import sys

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
        try:
            response = self.serial.readline().decode().strip()
        except UnicodeDecodeError:
            return None, None, None
        
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
            except (ValueError, IndexError):
                return None, None, None
        
        return None, None, None

def collect_data(com_port, duration, sample_rate, output_file):
    """Verzamel accelerometer data voor resonantie analyse"""
    
    print("\n" + "="*70)
    print("🔧 WERKPLAATS MARC - ADXL345 DATA VERZAMELING")
    print("="*70 + "\n")
    
    # Verbind met ADXL345
    print(f"🔌 Verbinden met {com_port}...")
    
    try:
        ser = serial.Serial(com_port, 115200, timeout=1)
        time.sleep(2)  # Wacht op connectie
        print(f"✅ Verbonden met {com_port}\n")
    except serial.SerialException as e:
        print(f"❌ FOUT: Kan niet verbinden met {com_port}")
        print(f"   {e}")
        print("\n💡 TIP: Check COM poort in Windows Apparaatbeheer")
        sys.exit(1)
    
    # Initialiseer ADXL345
    adxl = ADXL345(ser)
    try:
        adxl.initialize()
    except Exception as e:
        print(f"❌ FOUT bij initialiseren: {e}")
        ser.close()
        sys.exit(1)
    
    print("\n" + "="*70)
    print("📊 START DATA VERZAMELING")
    print("="*70)
    print(f"\n⏱️  Duur: {duration} seconden")
    print(f"📈 Sample rate: {sample_rate} Hz")
    print(f"💾 Output: {output_file}")
    print("\n🎯 RAAK DE PRINTER NIET AAN!")
    print("   Data verzameling start in 3 seconden...\n")
    
    for i in range(3, 0, -1):
        print(f"   {i}...")
        time.sleep(1)
    
    print("\n🚀 DATA VERZAMELING ACTIEF!\n")
    
    # Open CSV bestand
    try:
        with open(output_file, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['Timestamp', 'X_accel', 'Y_accel', 'Z_accel'])
            
            start_time = time.time()
            sample_count = 0
            last_progress_time = start_time
            
            # Verzamel data
            while (time.time() - start_time) < duration:
                timestamp = time.time() - start_time
                x, y, z = adxl.read_acceleration()
                
                if x is not None:
                    writer.writerow([f"{timestamp:.6f}", f"{x:.6f}", f"{y:.6f}", f"{z:.6f}"])
                    sample_count += 1
                    
                    # Progress indicator elke seconde
                    if (time.time() - last_progress_time) >= 1.0:
                        elapsed = int(timestamp)
                        remaining = duration - elapsed
                        progress = (elapsed / duration) * 100
                        
                        # Progress bar
                        bar_length = 40
                        filled_length = int(bar_length * elapsed / duration)
                        bar = '█' * filled_length + '░' * (bar_length - filled_length)
                        
                        print(f"\r⏳ [{bar}] {progress:.0f}% | {elapsed}s / {duration}s | {sample_count} samples", end='', flush=True)
                        last_progress_time = time.time()
                
                # Controleer sample rate
                time.sleep(max(0, 1.0 / sample_rate))
        
        print("\n\n" + "="*70)
        print("✅ DATA VERZAMELING VOLTOOID!")
        print("="*70)
        print(f"\n📊 Totaal verzamelde samples: {sample_count}")
        print(f"💾 Data opgeslagen in: {output_file}")
        print("="*70 + "\n")
        
    except Exception as e:
        print(f"\n❌ FOUT bij schrijven naar bestand: {e}")
        ser.close()
        sys.exit(1)
    
    ser.close()

if __name__ == "__main__":
    # Parse command line argumenten
    if len(sys.argv) < 5:
        print("❌ FOUT: Onvoldoende argumenten")
        print("Gebruik: python adxl_collect.py <COM_PORT> <DURATION> <SAMPLE_RATE> <OUTPUT_FILE>")
        sys.exit(1)
    
    try:
        com_port = sys.argv[1]
        duration = int(sys.argv[2])
        sample_rate = int(sys.argv[3])
        output_file = sys.argv[4]
        
        collect_data(com_port, duration, sample_rate, output_file)
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Data verzameling gestopt door gebruiker")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ FOUT: {e}")
        import traceback
        traceback.print_exc()
