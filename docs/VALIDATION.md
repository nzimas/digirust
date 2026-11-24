# Validation, integrity and recovery limits

## Supported files

| File | SHA-256 |
| --- | --- |
| Official Digitone II OS 1.12 input | `7e5b8a733d4ab1fdf7e5d22757f7d8eddaa3cbf71d0858874a791844c02ceb35` |
| DigiRust generated `.syx` | `3a5931ab37cf8f177fd1f330aa495fe749c7916541f8c412bac373d2dd953ea4` |

The app checks input identity, resource integrity and complete output identity. It reconstructs unchanged content from the user input and additions from the bundled recipe. Package checks cover container integrity and unchanged protected sections. Hash equality establishes file identity, not safe operation on hardware.

## Recorded local tests

The JSON summaries in `validation/` record the DigiRust development checks and patcher delivery checks.

For this release (patcher 1.3.0), see `firmware-release-report.json`:

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

The developer reports that DigiRust modified firmware has been thoroughly tested on a real Elektron Digitone II and is currently running on that instrument without any observed issues. The report was supplied by the developer on **12 October 2026**, for an earlier build; the additions in patcher 1.3.0 were verified in the emulator, not in that report. It is not an independently witnessed certification or an exhaustive test of every seed, configuration or instrument.

This records the developer's experience on that instrument. It is a factual report, not encouragement to install, an endorsement, a guarantee of safety or compatibility, or a prediction of results on another instrument. The warranty and use-at-your-own-risk warnings remain applicable.

The author also previously confirmed stock reinstallation through startup recovery on a healthy Digitone II. That does not guarantee recovery after every possible failure.

The recorded DigiRust automated tests used synthetic peripherals/DSP behavior and instruction compatibility shims. Their JSON summaries describe those local development runs; fields such as `physical_audio_validated: false` are historical properties of that automated test campaign, not a denial of the developer's subsequent hardware report. A separate `developer-hardware-report.json` records the statement and its provenance.

No exhaustive hardware timing/cache analysis or coverage of every possible generated result is claimed. The local patcher test environment is Apple Silicon running **macOS 27.0 (build 26A428)**. The minimum compilation target is macOS 11; that is not a macOS 11 test result. Intel Macs and other macOS versions remain unverified. The app is ad-hoc signed and not notarized.

## Before deciding to transfer

The patcher stops at creating a local file. Obtain and retain your official firmware separately. Consult Elektron's current Digitone II manual and update/recovery instructions. Verify the appropriate physical recovery connection and procedure for your own instrument before installing modified firmware. Preserve any user data you need.

A working recovery path on a healthy instrument is useful evidence, but is not a guarantee against irreversible failure. This project provides no quantified failure probability and no promise that a modified image cannot disable normal startup or recovery. Transfer remains the user's separate decision.
