"""
ADXL345 Data Analyse Script
Werkplaats Marc - Input Shaping Kalibratie
GitHub: https://github.com/werkplaatsmarc/input-shaping-ender3

Dit script analyseert accelerometer data en berekent optimale
Input Shaping parameters voor Marlin firmware.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.fft import fft, fftfreq
import csv
import os
from datetime import datetime

# ============================================================================
# CONFIGURATIE
# ============================================================================

DATA_DIR = 'adxl_data'
OUTPUT_DIR = 'analysis_results'

# Analyse parameters
MIN_FREQUENCY = 10   # Hz - Minimum frequentie voor analyse
MAX_FREQUENCY = 150  # Hz - Maximum frequentie voor analyse
PEAK_THRESHOLD = 0.1 # Drempel voor resonantie pieken

# ============================================================================
# DATA INLEZEN
# ============================================================================

def load_latest_data():
    """Laad het meest recente data bestand"""
    
    if not os.path.exists(DATA_DIR):
        print(f"❌ FOUT: Directory '{DATA_DIR}' niet gevonden")
        print("   Run eerst: python adxl_collect.py")
        return None
    
    # Vind alle CSV bestanden
    csv_files = [f for f in os.listdir(DATA_DIR) if f.endswith('.csv')]
    
    if not csv_files:
        print(f"❌ FOUT: Geen data bestanden gevonden in '{DATA_DIR}'")
        print("   Run eerst: python adxl_collect.py")
        return None
    
    # Sorteer op datum (nieuwste eerst)
    csv_files.sort(reverse=True)
    latest_file = csv_files[0]
    
    print(f"📁 Laden van: {latest_file}")
    
    # Lees CSV data
    timestamps = []
    x_data = []
    y_data = []
    z_data = []
    
    filepath = os.path.join(DATA_DIR, latest_file)
    
    with open(filepath, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            timestamps.append(float(row['Timestamp']))
            x_data.append(float(row['X_accel']))
            y_data.append(float(row['Y_accel']))
            z_data.append(float(row['Z_accel']))
    
    print(f"✅ {len(timestamps)} samples geladen\n")
    
    return {
        'timestamps': np.array(timestamps),
        'x': np.array(x_data),
        'y': np.array(y_data),
        'z': np.array(z_data),
        'filename': latest_file
    }

# ============================================================================
# FFT ANALYSE
# ============================================================================

def perform_fft_analysis(data_array, sample_rate):
    """Voer FFT analyse uit op accelerometer data"""
    
    # Verwijder DC component (gemiddelde)
    data_centered = data_array - np.mean(data_array)
    
    # Apply Hanning window om spectral leakage te verminderen
    window = np.hanning(len(data_centered))
    data_windowed = data_centered * window
    
    # Bereken FFT
    n = len(data_windowed)
    fft_values = fft(data_windowed)
    fft_freq = fftfreq(n, 1/sample_rate)
    
    # Neem alleen positieve frequenties
    positive_freq_idx = fft_freq > 0
    frequencies = fft_freq[positive_freq_idx]
    magnitudes = np.abs(fft_values[positive_freq_idx])
    
    # Normaliseer magnitude
    magnitudes = magnitudes / n
    
    return frequencies, magnitudes

def find_resonance_peaks(frequencies, magnitudes):
    """Vind dominante resonantie frequenties"""
    
    # Filter frequentie bereik
    freq_mask = (frequencies >= MIN_FREQUENCY) & (frequencies <= MAX_FREQUENCY)
    freq_filtered = frequencies[freq_mask]
    mag_filtered = magnitudes[freq_mask]
    
    # Vind pieken
    peaks, properties = signal.find_peaks(
        mag_filtered,
        height=PEAK_THRESHOLD * np.max(mag_filtered),
        distance=20,
        prominence=0.05 * np.max(mag_filtered)
    )
    
    # Sorteer pieken op magnitude (sterkste eerst)
    peak_magnitudes = mag_filtered[peaks]
    sorted_indices = np.argsort(peak_magnitudes)[::-1]
    
    resonance_frequencies = freq_filtered[peaks[sorted_indices]]
    resonance_magnitudes = peak_magnitudes[sorted_indices]
    
    return resonance_frequencies, resonance_magnitudes

# ============================================================================
# MARLIN INPUT SHAPING PARAMETERS
# ============================================================================

def calculate_input_shaping_params(resonance_freq):
    """Bereken optimale Input Shaping parameters voor Marlin"""
    
    # Marlin Input Shaping gebruikt ZV (Zero Vibration) shaper
    # Optimale damping factor voor ZV shaper
    damping_factor = 0.1  # Typisch 0.05 - 0.15
    
    # Shaping frequentie = resonantie frequentie
    shaping_freq = resonance_freq
    
    return {
        'frequency': shaping_freq,
        'damping': damping_factor,
        'shaper_type': 'ZV'  # Marlin default
    }

# ============================================================================
# VISUALISATIE
# ============================================================================

def plot_analysis_results(data, x_params, y_params):
    """Maak analyse grafieken"""
    
    # Maak output directory
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
    
    # Bereken sample rate
    dt = np.mean(np.diff(data['timestamps']))
    sample_rate = 1.0 / dt
    
    # Bereken FFT voor X en Y as
    x_freq, x_mag = perform_fft_analysis(data['x'], sample_rate)
    y_freq, y_mag = perform_fft_analysis(data['y'], sample_rate)
    
    # Maak figuur met subplots
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(16, 12))
    fig.suptitle('ADXL345 Resonantie Analyse - Werkplaats Marc', fontsize=16, fontweight='bold')
    
    # Plot 1: X-as tijdsdomein
    ax1.plot(data['timestamps'], data['x'], 'b-', linewidth=0.5, alpha=0.7)
    ax1.set_xlabel('Tijd (s)')
    ax1.set_ylabel('Acceleratie (g)')
    ax1.set_title('X-as Acceleratie (Tijdsdomein)')
    ax1.grid(True, alpha=0.3)
    
    # Plot 2: Y-as tijdsdomein
    ax2.plot(data['timestamps'], data['y'], 'r-', linewidth=0.5, alpha=0.7)
    ax2.set_xlabel('Tijd (s)')
    ax2.set_ylabel('Acceleratie (g)')
    ax2.set_title('Y-as Acceleratie (Tijdsdomein)')
    ax2.grid(True, alpha=0.3)
    
    # Plot 3: X-as frequentiedomein
    freq_mask_x = (x_freq >= MIN_FREQUENCY) & (x_freq <= MAX_FREQUENCY)
    ax3.plot(x_freq[freq_mask_x], x_mag[freq_mask_x], 'b-', linewidth=1.5)
    ax3.axvline(x_params['frequency'], color='red', linestyle='--', linewidth=2, 
                label=f'Resonantie: {x_params["frequency"]:.1f} Hz')
    ax3.set_xlabel('Frequentie (Hz)')
    ax3.set_ylabel('Magnitude')
    ax3.set_title(f'X-as Frequentie Spectrum (Resonantie: {x_params["frequency"]:.1f} Hz)')
    ax3.legend()
    ax3.grid(True, alpha=0.3)
    
    # Plot 4: Y-as frequentiedomein
    freq_mask_y = (y_freq >= MIN_FREQUENCY) & (y_freq <= MAX_FREQUENCY)
    ax4.plot(y_freq[freq_mask_y], y_mag[freq_mask_y], 'r-', linewidth=1.5)
    ax4.axvline(y_params['frequency'], color='red', linestyle='--', linewidth=2,
                label=f'Resonantie: {y_params["frequency"]:.1f} Hz')
    ax4.set_xlabel('Frequentie (Hz)')
    ax4.set_ylabel('Magnitude')
    ax4.set_title(f'Y-as Frequentie Spectrum (Resonantie: {y_params["frequency"]:.1f} Hz)')
    ax4.legend()
    ax4.grid(True, alpha=0.3)
    
    plt.tight_layout()
    
    # Opslaan
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = os.path.join(OUTPUT_DIR, f'resonance_analysis_{timestamp}.png')
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"📊 Grafiek opgeslagen: {output_file}")
    
    # Toon grafiek
    plt.show()

# ============================================================================
# MARLIN CONFIGURATIE OUTPUT
# ============================================================================

def generate_marlin_config(x_params, y_params):
    """Genereer Marlin G-code commando's voor Input Shaping"""
    
    print("\n" + "="*70)
    print("🔧 MARLIN INPUT SHAPING CONFIGURATIE")
    print("="*70 + "\n")
    
    print("📋 Kopieer de volgende commando's naar je printer terminal:\n")
    print(";" + "-"*68)
    print("; Werkplaats Marc - Input Shaping Configuratie")
    print("; Gegenereerd op: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    print(";" + "-"*68 + "\n")
    
    print("; X-as Input Shaping")
    print(f"M593 X F{x_params['frequency']:.1f} D{x_params['damping']:.2f}  ; X-as: {x_params['frequency']:.1f} Hz, Damping: {x_params['damping']:.2f}\n")
    
    print("; Y-as Input Shaping")
    print(f"M593 Y F{y_params['frequency']:.1f} D{y_params['damping']:.2f}  ; Y-as: {y_params['frequency']:.1f} Hz, Damping: {y_params['damping']:.2f}\n")
    
    print("; Opslaan in EEPROM (instellingen blijven na herstart)")
    print("M500\n")
    
    print("; Verificatie (controleer of instellingen correct zijn)")
    print("M593\n")
    
    print(";" + "-"*68)
    print("\n💡 TIP: Run M593 om je huidige Input Shaping instellingen te zien")
    print("="*70 + "\n")
    
    # Sla configuratie ook op naar bestand
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    config_file = os.path.join(OUTPUT_DIR, f'marlin_config_{timestamp}.gcode')
    
    with open(config_file, 'w') as f:
        f.write("; Werkplaats Marc - Input Shaping Configuratie\n")
        f.write(f"; Gegenereerd op: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write(f"M593 X F{x_params['frequency']:.1f} D{x_params['damping']:.2f}\n")
        f.write(f"M593 Y F{y_params['frequency']:.1f} D{y_params['damping']:.2f}\n")
        f.write("M500\n")
    
    print(f"💾 Configuratie opgeslagen: {config_file}\n")

# ============================================================================
# MAIN ANALYSE FUNCTIE
# ============================================================================

def analyze_resonance():
    """Hoofdfunctie voor resonantie analyse"""
    
    print("\n" + "="*70)
    print("🔬 WERKPLAATS MARC - RESONANTIE ANALYSE")
    print("="*70 + "\n")
    
    # Laad data
    data = load_latest_data()
    if data is None:
        return
    
    # Bereken sample rate
    dt = np.mean(np.diff(data['timestamps']))
    sample_rate = 1.0 / dt
    
    print(f"📊 Sample rate: {sample_rate:.1f} Hz")
    print(f"⏱️  Opname duur: {data['timestamps'][-1]:.1f} seconden\n")
    
    print("🔍 Analyseren van resonantie frequenties...\n")
    
    # Analyseer X-as
    x_freq, x_mag = perform_fft_analysis(data['x'], sample_rate)
    x_resonances, x_mags = find_resonance_peaks(x_freq, x_mag)
    
    print("📈 X-AS RESONANTIES:")
    if len(x_resonances) > 0:
        for i, (freq, mag) in enumerate(zip(x_resonances[:3], x_mags[:3]), 1):
            print(f"   {i}. {freq:.1f} Hz (magnitude: {mag:.4f})")
        x_primary = x_resonances[0]
    else:
        print("   ⚠️  Geen significante resonanties gevonden")
        x_primary = 40.0  # Default waarde
    
    print()
    
    # Analyseer Y-as
    y_freq, y_mag = perform_fft_analysis(data['y'], sample_rate)
    y_resonances, y_mags = find_resonance_peaks(y_freq, y_mag)
    
    print("📈 Y-AS RESONANTIES:")
    if len(y_resonances) > 0:
        for i, (freq, mag) in enumerate(zip(y_resonances[:3], y_mags[:3]), 1):
            print(f"   {i}. {freq:.1f} Hz (magnitude: {mag:.4f})")
        y_primary = y_resonances[0]
    else:
        print("   ⚠️  Geen significante resonanties gevonden")
        y_primary = 40.0  # Default waarde
    
    print()
    
    # Bereken Input Shaping parameters
    x_params = calculate_input_shaping_params(x_primary)
    y_params = calculate_input_shaping_params(y_primary)
    
    # Genereer Marlin configuratie
    generate_marlin_config(x_params, y_params)
    
    # Maak visualisaties
    print("📊 Genereren van grafieken...\n")
    plot_analysis_results(data, x_params, y_params)
    
    print("\n" + "="*70)
    print("✅ ANALYSE VOLTOOID!")
    print("="*70 + "\n")
    print("🎯 VOLGENDE STAPPEN:")
    print("   1. Kopieer de M593 commando's naar je printer terminal")
    print("   2. Print een test object om Input Shaping te verifiëren")
    print("   3. Vergelijk met/zonder Input Shaping voor beste resultaten")
    print("="*70 + "\n")

# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    try:
        analyze_resonance()
    except KeyboardInterrupt:
        print("\n\n⚠️  Analyse gestopt door gebruiker")
    except Exception as e:
        print(f"\n❌ FOUT: {e}")
        import traceback
        traceback.print_exc()