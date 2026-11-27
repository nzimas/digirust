# DigiRust — phrase engine

Firmware based on official Digitone II OS **1.12**; the internal OS version remains **1.12**. Created by DigiRust patcher **1.6.0** (browser and macOS). Output SHA-256 `161249fa0144d4c69a288f08698ac061a987b424a9841bd7bb035c64698fac41`. Everything in the previous release is kept.

## New in this release

- **PAGE + FILTER phrase engine:** a phrase on the selected track sets its own **length (2–32 steps)** and **clock (2x, 3/2x, 1x, 3/4x, 1/2x, 1/4x, 1/8x)**. Some phrases stay locked to the bar while changing the feel (24 steps at 3/2x for triplets, 32 at 2x, 12 at 3/4x); others drift as polymeter at lengths such as 5, 7, 10, 13, 21, 22 or 31. Kick and snare always lock to the pattern's meter.
- **Twelve rhythm families** for strike sounds: Euclidean, aksak (2s and 3s), ghost-weighted, Thue-Morse and Fibonacci, a cellular automaton played as cycle conditions, tresillo/clave/bembé timelines, power-noise hammering, industrial stomp, broken IDM with flams, four-on-the-floor and backbeats. Then ghosts, rolls, swing/drag/push, cycle variation, a turnaround, locks and tom pitches. Textures, drones and pads are held on slow clocks.
- Everything is ordinary step data: velocities, micro timing, conditions, retrigs and locks can be edited afterwards.
- A phrase on a one-length pattern switches it to per-track mode; every other track keeps the length and clock it was playing.
- Shuffle and gate group tracks by length and clock, so a track on another clock trades and gates within its own timeline.
- The SYSTEM menu generators are unchanged. PAGE + FILTER no longer draws Abstract.

See the [feature guide](docs/FEATURES.md#phrase-shortcut) for every rule and limit.

### Validation limits

On the host: 5,760 phrases on 4/4, 12-step one-length and polymeter/mixed-clock set-ups; other tracks' notes, length and clock unchanged, nothing past the loop, the kick on step 1, density limits kept, conditions and retrigs valid; the full host suite passes; 2,400 gates and 1,800 shuffles match independent models, including a mixed-clock set-up. Byte-exact host/ColdFire comparisons: 27 phrase cases with 15 stock decode/encode round trips keeping steps, length and clock; 27 shuffle, 27 gate and 21 shortcut cases. A fresh boot of the exact firmware package in the emulator with real front-panel input: a zone kit and pattern, then PAGE + FILTER on tracks 1, 2, 5, 9, 11 and 14 (the live pattern plays the new length and clock, other tracks untouched); shuffle and gate on the phrased pattern matched the host and restored exactly; a 12-step one-length pattern switched to per-track with the other tracks still 12 steps; 0 fault pages. Not played on the instrument; the rhythms were checked as data, not by ear.

## Meter and shortcut zones (patcher 1.5.0)

- **Break, shuffle and gate follow the length that plays:** the pattern LENGTH in one-length mode, each track's own length in per-track mode. A 12-step loop is three beats of four. Shuffle pieces and gate slices never cross a beat, and the break uses the loop's own bars. A track of another length follows its own loop. Steps past the played length are never touched. Patterns in 4/4 break exactly as before.
- **PAGE generator shortcuts by track zone:** track 1 is always a kick; tracks 2–12 are strike sounds (snares, claps, hats, rides, cymbals, toms, rims, clangs, slams, shakers, short noises); tracks 13–16 are textures, atmospheres, drones and pads. The drawn path (Abstract, IDM, Noise) only colours the sounds.
- **New strike designs:** fast attack, no sustain, no LFO on pitch, pitch sweeps kept short. Each sound is named after its role, so the pattern, phrase and break generators read every track correctly.
- **PAGE + AMP** gives textures and pads long held notes; **PAGE + FILTER** can write a phrase in the sound's own role. A clock running from power-on stirs the shortcut draws, so a new session gives new kits.
- The SYSTEM menu generators are unchanged.

See the [feature guide](docs/FEATURES.md#page-shortcuts) for every rule and limit.

### Meter and shortcut-zone validation limits

On the host: 1,500 shuffles on 25 set-ups, 2,000 gates and 2,800 breaks, with 4/4 breaks byte-identical to the previous release in 210 of 210 cases; 23,040 shortcut sounds, all distinct; a kick in 120 of 120 rhythmic shortcut patterns. Byte-exact host/ColdFire comparisons: 42 break, 27 shuffle, 27 gate and 21 shortcut cases. A fresh boot of the exact firmware package in the emulator with real front-panel input: a zone kit and pattern from the shortcuts, the clock advancing, shuffle and gate restoring exactly; on a live pattern set to 12 steps, shuffle, gate and break matched the host, nothing past step 12 changed and the pattern was restored exactly; 0 fault pages. Not played on the instrument; the sounds were checked by their parameters, not by ear.

## Gate (patcher 1.4.0)

- **PAGE + TRK (held):** gate. The tracks with notes are muted and opened rhythmically, in slices of sixteenths, eighths or quarters that all tracks share, so the gating stays in time. Every slice keeps at least one track playing and silences at least one. Each press draws a new gating and feel. Tails and releases ring on; the pattern returns exactly on release.

See the [feature guide](docs/FEATURES.md#gate) for every rule and limit.

### Gate validation limits

The gate passed 400 host gates matching an independent model byte for byte, 18 byte-exact host/ColdFire comparisons with stock pattern-codec round trips, and a fresh boot of the exact firmware package in the emulator with real front-panel input: two gates matched the host generator and restored the pattern byte for byte in either release order, a trig key pressed while gated did nothing, TRK alone kept its stock behavior and the shuffle still worked. The emulator cannot judge sound or timing; the gate has not been played on the instrument.

## PAGE performance shortcuts (patcher 1.3.0)

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
