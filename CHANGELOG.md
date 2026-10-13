# Changes

## Browser website — 13 October 2026

- GitHub Pages site with browser patcher, demo, manual and disclaimer.
- JavaScript port of the existing firmware-format tool and level-0 compressor; exact RC17 output verified.
- Local worker processing, pinned resources, explicit download and cancellation. No firmware upload, MIDI access or installation.
- Native/browser codec parity tests and automated static publication/deployment checks.
- RC17 firmware behavior and DigiRust 1.2.0 macOS target remain unchanged.

## DigiRust 1.2.0 — RC17 target

- First patcher-only GitHub publication.
- Native macOS patcher for official Digitone II OS 1.12 → DigiRust RC17.
- RC17 adds independent 0–100% Kit Brutality controls for IDM and Rhythmic Noise, with contrasting bars, DATA editing/cancel and repeat YES generation.
- Retains patch, kit, pattern and phrase generators, pattern controls, experimental sound palettes, tempo/structure variation, compressor generation, Control All macros, live latch and Perform restoration.
- Pinned input, recipe/additions and complete output integrity checks; exclusive atomic saving and no automatic instrument connection.

## Numbering

Patcher version **1.2.0** identifies the macOS application. **RC17** identifies the generated modification. The internal vendor OS version remains **1.12**. Earlier development releases are not included in this repository. New stock versions require a separately validated recipe; they cannot be supported by renaming files.
