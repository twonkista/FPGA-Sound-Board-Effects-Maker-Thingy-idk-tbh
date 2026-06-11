import wave
import sys
import os

def wav_to_coe(wav_path, coe_path):
    try:
        # Open the WAV file
        wav_file = wave.open(wav_path, 'r')
    except FileNotFoundError:
        print(f"Error: File '{wav_path}' not found.")
        return

    # Extract WAV parameters
    params = wav_file.getparams()
    nchannels, sampwidth, framerate, nframes = params[:4]

    # Enforce constraints for standard BRAM initialization
    if nchannels != 1:
        print("Error: Only mono (1 channel) WAV files are supported. Please convert your file.")
        wav_file.close()
        return
        
    if sampwidth != 2:
        print("Error: Only 16-bit PCM format is supported.")
        wav_file.close()
        return

    print(f"Processing '{wav_path}':")
    print(f"  Sample Rate: {framerate} Hz")
    print(f"  Total Frames: {nframes}")

    # Read all frames and convert to integer values
    frames = wav_file.readframes(nframes)
    wav_file.close()
    
    # Calculate how many bytes per sample (we already checked sampwidth == 2 -> 'h')
    import struct
    fmt = f"<{nframes}h"
    samples = struct.unpack(fmt, frames)

    # Generate COE file
    with open(coe_path, 'w') as coe_file:
        # Write COE Header (required by Xilinx)
        coe_file.write("memory_initialization_radix=16;\n")
        coe_file.write("memory_initialization_vector=\n")
        
        # Write data with comma separation and a semicolon at the end
        for i, sample in enumerate(samples):
            # Convert 16-bit signed integer to 4-character Hex string
            hex_val = f"{sample & 0xFFFF:04X}" 
            
            if i == len(samples) - 1:
                coe_file.write(f"{hex_val};\n")
            else:
                coe_file.write(f"{hex_val},\n")

    print(f"Success! COE file generated at '{coe_path}'")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python wav_to_coe.py <input.wav> <output.coe>")
    else:
        wav_to_coe(sys.argv[1], sys.argv[2])