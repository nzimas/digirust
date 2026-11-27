# Validation, integrity and recovery limits

## Supported files

| File | SHA-256 |
| --- | --- |
| Official Digitone II OS 1.12 input | `7e5b8a733d4ab1fdf7e5d22757f7d8eddaa3cbf71d0858874a791844c02ceb35` |
| DigiRust generated `.syx` | `161249fa0144d4c69a288f08698ac061a987b424a9841bd7bb035c64698fac41` |

The app checks input identity, resource integrity and complete output identity. It reconstructs unchanged content from the user input and additions from the bundled recipe. Package checks cover container integrity and unchanged protected sections. Hash equality establishes file identity, not safe operation on hardware.

## Recorded local tests

The JSON summaries in `validation/` record the DigiRust development checks and patcher delivery checks.

For this release (patcher 1.6.0), see `firmware-release-report.json`:

- Phrase engine: 5,760 host phrases on 4/4, 12-step one-length and polymeter/mixed-clock set-ups; other tracks' notes, length and clock unchanged, nothing past the loop, the kick on step 1, density limits kept, conditions and retrigs valid. The full host suite passes.
- 2,400 gates and 1,800 shuffles matching independent models, including a mixed-clock set-up.
- Byte-exact host/ColdFire comparisons: 27 phrase cases with 15 stock decode/encode round trips keeping steps, length and clock; 27 shuffle, 27 gate and 21 shortcut cases.
- A fresh boot of the exact firmware package in the emulator with real front-panel input: a zone kit and pattern, then PAGE + FILTER on tracks 1, 2, 5, 9, 11 and 14 (the live pattern plays the new length and clock, other tracks untouched); shuffle and gate on the phrased pattern matched the host and restored exactly; a 12-step one-length pattern switched to per-track with the other tracks still 12 steps; 0 fault pages.
- 24 browser patcher tests including exact output from the official file, and 18 macOS patcher integration tests.
- Not played on the instrument; the rhythms were checked as data, not by ear.

Checks for patcher 1.5.0:

- Meter: 1,500 host shuffles on 25 set-ups, 2,000 gates and 2,800 breaks; 4/4 breaks byte-identical to the previous release in 210 of 210 cases.
- Shortcut zones: 23,040 shortcut sounds, all distinct; a kick in 120 of 120 rhythmic shortcut patterns.
- Byte-exact host/ColdFire comparisons: 42 break, 27 shuffle, 27 gate and 21 shortcut cases.
- A fresh boot of the exact firmware package in the emulator with real front-panel input: a zone kit and pattern from the shortcuts, the clock advancing, shuffle and gate restoring exactly; on a live pattern set to 12 steps, shuffle, gate and break matched the host, nothing past step 12 changed and the pattern was restored exactly; 0 fault pages.
- 24 browser patcher tests including exact output from the official file, and 18 macOS patcher integration tests.
- Not played on the instrument; the sounds were checked by their parameters, not by ear.

Checks for patcher 1.4.0:

- Gate: 400 host gates matching an independent model byte for byte; 18 byte-exact host/ColdFire comparisons with 6 stock pattern decode/encode round trips.
- A fresh boot of the exact firmware package in the emulator with real front-panel input: two gates matching the host generator and restoring the pattern byte for byte in either release order; a trig key while gated changed nothing; TRK alone stock; the shuffle still restores exactly.
- 24 browser patcher tests including exact output from the official file, and the macOS patcher producing the same output.

Checks for patcher 1.3.0:

- Host tests and byte-exact host/ColdFire comparisons for the generator shortcuts, lock roll, break and shuffle, with stock pattern decode/encode round trips.
- Fresh boots of the exact firmware package in the emulator with real front-panel input: kit/pattern questions answered and cancelled; lock rolls, breaks and shuffles matching the host generator and restoring the pattern byte for byte; compressor copied only to the bank's patterns with notes; note audition with balanced note-on/off.
- 24 browser patcher tests including exact output from the official file, and 18 macOS patcher integration tests.

Earlier checks, recorded for the kit Brutality release:

- 256 rhythmic kits / 4,096 sounds in host tests, including default-35% RC16 parity.
- 32 host/ColdFire kit parity cases and 512 stock sound-codec round trips.
- 28 kit-control raster cases, plus retained patch and pattern controls.
- Installed kit publication and mutation-isolation checks.
- Retained patch/pattern, tempo, Control All/Perform and live restoration checks.
- A fresh exact-package emulated OS boot and nine front-panel stages, including repeated kit generation and edit cancellation.
- 18 patcher integration tests: exact output, invalid input, corrupted resources, overwrite prevention, exclusive concurrent saving and unchanged stock input.
- Exact output through the native graphical interface and an extracted macOS release archive, with signature verification.

These summaries are historical evidence, not a claim that the private full emulation suite can be rerun from this patcher-only repository. The publication audit and local reconstruction check are reproducible here.

## Hardware evidence and limits

The developer reports that DigiRust modified firmware has been thoroughly tested on a real Elektron Digitone II and is currently running on that instrument without any observed issues. The report was supplied by the developer on **12 October 2026**, for an earlier build; the additions in patchers 1.3.0, 1.4.0, 1.5.0 and 1.6.0 were verified in the emulator, not in that report. It is not an independently witnessed certification or an exhaustive test of every seed, configuration or instrument.

This records the developer's experience on that instrument. It is a factual report, not encouragement to install, an endorsement, a guarantee of safety or compatibility, or a prediction of results on another instrument. The warranty and use-at-your-own-risk warnings remain applicable.

The author also previously confirmed stock reinstallation through startup recovery on a healthy Digitone II. That does not guarantee recovery after every possible failure.

The recorded DigiRust automated tests used synthetic peripherals/DSP behavior and instruction compatibility shims. Their JSON summaries describe those local development runs; fields such as `physical_audio_validated: false` are historical properties of that automated test campaign, not a denial of the developer's subsequent hardware report. A separate `developer-hardware-report.json` records the statement and its provenance.

No exhaustive hardware timing/cache analysis or coverage of every possible generated result is claimed. The local patcher test environment is Apple Silicon running **macOS 27.0 (build 26A428)**. The minimum compilation target is macOS 11; that is not a macOS 11 test result. Intel Macs and other macOS versions remain unverified. The app is ad-hoc signed and not notarized.

## Before deciding to transfer

The patcher stops at creating a local file. Obtain and retain your official firmware separately. Consult Elektron's current Digitone II manual and update/recovery instructions. Verify the appropriate physical recovery connection and procedure for your own instrument before installing modified firmware. Preserve any user data you need.

A working recovery path on a healthy instrument is useful evidence, but is not a guarantee against irreversible failure. This project provides no quantified failure probability and no promise that a modified image cannot disable normal startup or recovery. Transfer remains the user's separate decision.
