```
 ██████  ██████   █████  ██████  ███████ ███████ 
██      ██    ██ ██   ██ ██   ██ ██      ██      
██      ██    ██ ███████ ██████  ███████ █████   
██      ██    ██ ██   ██ ██   ██      ██ ██      
 ██████  ██████  ██   ██ ██   ██ ███████ ███████ 
                                                

```

# Coarse MIDI Console

A polyphonic MIDI synthesizer built with ChucK, featuring multiple oscillator types, ADSR envelope control, and real-time audio effects processing.

## Features

- **Polyphonic Voice Architecture**: 128-voice polyphonic synthesizer with per-note voice management
- **Multiple Oscillator Types**: Sine, Triangle, and Square wave oscillators
- **MIDI Input**: Real-time MIDI message handling with velocity sensitivity
- **Audio Effects Chain**:
  - Low-pass filter with LFO modulation
  - Dynamic range compression/limiting
  - Reverb effect
- **ADSR Envelope**: Attack-Decay-Sustain-Release envelope shaping per voice

## Prerequisites

- [ChucK](https://chuck.cs.princeton.edu/) programming language (latest version)
- A MIDI controller or virtual MIDI device

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/coarse-midi-console.git
cd coarse-midi-console
```

2. Ensure ChucK is installed and available in your PATH:
```bash
chuck --version
```

## Usage

### Basic Usage

Run the synthesizer with your default MIDI device (device 0):

```bash
chuck src/main.ck
```

### Specify MIDI Device

To use a different MIDI device, pass the device number as an argument:

```bash
chuck src/main.ck:1  # Use MIDI device 1
```

### List Available MIDI Devices

To see available MIDI devices:

```bash
chuck --probe
```

## Architecture

### Project Structure

```
src/
├── main.ck                          # Entry point, MIDI input handling
└── console/
    ├── baseInstrument.ck            # Main instrument class
    ├── customChain.ck               # Audio effects chain
    └── instruments/
        ├── polyInstrument.ck        # Polyphonic voice management
        └── voices/
            └── graphs.ck            # Voice synthesis graph
```

### Signal Flow

```
MIDI Input → BaseInstrument → PolyVoices → Voice[128] → Chain → DAC
                                                           ├─ LPF (w/ LFO)
                                                           ├─ Limiter
                                                           └─ Reverb
```

### Components

#### Voice (`graphs.ck`)
- Individual voice synthesis unit
- Selectable oscillator types (Sine/Triangle/Square)
- ADSR envelope with 1-second release
- Velocity-sensitive gain control
- Frequency range: Full MIDI note range

#### PolyVoices (`polyInstrument.ck`)
- Manages 128 simultaneous voices (one per MIDI note)
- Handles MIDI Note On/Off messages (0x90/0x80)
- Converts MIDI note numbers to frequencies
- Routes velocity data to individual voices

#### Chain (`customChain.ck`)
- **Low-Pass Filter**: Cutoff at 10kHz with LFO modulation
  - LFO centered at 500Hz with 100Hz offset
  - Sine wave LFO at π Hz
- **Limiter**: 100ms attack time, 0.8 threshold
- **Reverb**: 10% wet mix

#### BaseInstrument (`baseInstrument.ck`)
- Top-level instrument interface
- Routes MIDI data to voice manager
- Connects voice output to effects chain

## Customization

### Change Oscillator Type

In `src/console/instruments/polyInstrument.ck`, modify line 10:

```chuck
Voice v(TRI_OSC)[KEYBOARD_SIZE] => outlet;  // Current: Triangle wave
// Options: SIN_OSC (0), TRI_OSC (1), SQR_OSC (2)
```

### Adjust Effects

In `src/console/customChain.ck`:

```chuck
// Low-pass filter cutoff
10000 => lpf.freq;

// Limiter settings
100::ms => limiter.attackTime;
0.8 => limiter.thresh;

// Reverb mix (0.0 - 1.0)
0.1 => rev.mix;
```

### Modify Envelope

In `src/console/instruments/voices/graphs.ck`:

```chuck
1000::ms => env.releaseTime;  // Adjust release time
```

## MIDI Implementation

The synthesizer responds to:

- **Note On** (0x90): Triggers voice with velocity
- **Note Off** (0x80): Releases voice envelope

MIDI channels are currently not differentiated (omni mode).

## Known Current limitations

- No pitch bend support
- No CC (Control Change) support
- Monophonic per-note (last note priority within same note number)
- Fixed attack/decay/sustain times
- No preset system

## Acknowledgments

Built with [ChucK](https://chuck.cs.princeton.edu/), a strongly-timed audio programming language developed at Princeton University.

## Troubleshooting

### No Sound Output

1. Check MIDI device connection: `chuck --probe`
2. Verify audio output device in ChucK
3. Ensure MIDI controller is sending on channel 1
4. Check system volume and audio routing

### High CPU Usage

- Reduce number of active voices (modify `KEYBOARD_SIZE` in `polyInstrument.ck`)
- Disable or reduce reverb mix
- Simplify LFO calculation frequency

### MIDI Device Not Found

- Connect MIDI device before running ChucK
- Use correct device number as argument
- Check device permissions (especially on Linux/macOS)
