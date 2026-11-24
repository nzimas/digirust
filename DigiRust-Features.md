# DigiRust — PAGE performance shortcuts

Firmware based on official Digitone II OS **1.12**; the internal OS version remains **1.12**. Created by DigiRust patcher **1.3.0** (browser and macOS). Output SHA-256 `3a5931ab37cf8f177fd1f330aa495fe749c7916541f8c412bac373d2dd953ea4`. Everything in the previous release is kept.

## New in this release

- **PAGE + TRIG / SYN / FILTER / AMP:** generate a patch, kit, phrase or pattern without opening a menu. Each press draws its path and controls. Kit and pattern ask **YES/NO** first, and the question stays until answered.
- **PAGE + trig key:** select that track and roll its parameter locks, velocities and cycle conditions, from the sound processing only, never pitch.
- **PAGE + FUNC (held):** a pattern break (stutter, half, double, reverse, chop, roll, slam) for as long as FUNC is held; the pattern returns exactly on release.
- **PAGE + KEYBOARD (held):** shuffle. Tracks trade their sequencing, keeping their own sounds and pitches, for as long as both keys are held.
- **PAGE + MOD on the Compressor page:** copy this pattern's compressor to every pattern with notes in the current bank of 16.
- **Note audition:** in grid recording, hold a trig and turn NOTE; each new pitch is heard at once.
- **Generated sounds have no delay send.** Reverb and chorus sends remain.

See the [feature guide](docs/FEATURES.md#page-shortcuts) for every rule and limit.

## Validation limits

Each addition passed host tests and byte-exact host/ColdFire comparisons, stock pattern-codec round trips where it writes patterns, and a fresh boot of the exact firmware package in the emulator driven by real front-panel input: generator questions, lock rolls, breaks and shuffles matched the host generator and restored the pattern byte for byte; the compressor copy reached only the bank's patterns with notes; the audition played one note per pitch with balanced note-on/off. The emulator uses synthetic DSP and peripherals: it cannot judge sound, timing or cache behavior. The developer's real-instrument report (see [VALIDATION.md](docs/VALIDATION.md)) was made on an earlier build. Saving and reloading a project after a compressor copy has not been exercised on the instrument.

## Kit Brutality (earlier release)

### Kit Generator workflow

Choose **Kit Generator → Rhythmic → IDM** or **Rhythmic Noise**. Each opens a single **BRUTALITY** percentage row with a proportional, dynamically contrasting bar.

Press **DATA/LEVEL** to edit; turn the encoder to set **0–100%**; press it again to finish. **NO** cancels an in-progress edit. **YES** generates a complete 16-track kit and keeps the screen selected, so repeated YES presses generate more kits. DATA never generates a kit. NO outside editing returns to the parent menu.

IDM and Rhythmic Noise each remember an independent value while the instrument is running, initially **35%**. Values reset to 35% on restart. Kit values are independent of Patch Generator and Pattern Generator values. At 35%, the same seed produces exactly the previous rhythmic kit, preserving the existing default palette.

### Effect on generated sounds

The selected percentage feeds the existing path-specific experimental sound stage for **every sound in the kit**. Higher values increase source colour/complexity, modulation depth, overdrive and bit/sample-rate reduction, with output gain compensation. IDM retains articulated experimental percussion; Rhythmic Noise uses harsher source and effects treatment. Upper abstract and melodic zones receive the same percentage through their sound-role treatment.

Tracks **1–8** retain their existing percussion assignments, including kick on 1. Tracks **9–12** independently draw abstract roles/families; tracks **13–16** independently draw melodic roles/families. Brutality does not replace these allocations. Kit generation replaces all sixteen track sounds while preserving the current pattern and other kit settings, including the compressor. Pattern Generator retains its own separate compressor-generation logic.

Abstract, Melodic and Free kit paths retain their existing immediate YES workflow. Abstract kits retain their previous fixed 35% sound colour; Melodic and Free behavior is unchanged. This release adds no Kit Density setting.

### Validation limits (kit Brutality)

Local host and ColdFire CPU tests check all-track control, parameter bounds, gain compensation, same-seed parity at 35%, stock sound-codec roundtrips, actual menu editing/cancel and framebuffer contrast, installed atomic publication, retained performance behavior and exact-package emulated boot/panel operations. Synthetic hardware cannot establish physical sound quality, DSP timing or cache behavior. The automated development runs did not access or deploy to an instrument. The developer subsequently reports thorough testing and issue-free current operation on a real Digitone II; see docs/VALIDATION.md. That report is not an installation endorsement or a guarantee. The percentage is a synthesis control, not an audio limiter.
