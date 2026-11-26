# Changes

## DigiRust 1.4.0 — 26 November 2026

- Firmware: PAGE + TRK gate. Hold PAGE, then TRK: the tracks with notes are muted and opened rhythmically, in time, with a new gating on each press; the pattern returns exactly on release.
- Patcher: new recipe and additions for this firmware (output SHA-256 `a382efeb19f23b9a295753b9b2cd450e7f5c4c45184331f740581e220207144e`); browser and macOS patchers produce it byte for byte. Input remains official OS 1.12.

## DigiRust 1.3.0 — 24 November 2026

- Firmware: PAGE shortcuts for patch, kit, phrase and pattern generation (kit and pattern ask YES/NO, and the question stays until answered).
- Firmware: PAGE + trig key lock roll; PAGE + FUNC breaks; PAGE + KEYBOARD shuffle; PAGE + MOD copies the compressor to the bank's patterns with notes.
- Firmware: note audition while turning NOTE on a held trig in grid recording.
- Firmware: generated patches and kits have no delay send.
- Patcher: new recipe and additions for this firmware (output SHA-256 `3a5931ab37cf8f177fd1f330aa495fe749c7916541f8c412bac373d2dd953ea4`); browser and macOS patchers produce it byte for byte. Input remains official OS 1.12.

## Flat logo and custom lettering

- Replaced the faceted emblem with single-colour planar geometry.
- Drew custom stencil lettering as vector paths, without a system-font dependency.
- Applied the full wordmark to the website header and homepage; retained blue on black.

## Logo and colour revision

- Replaced the D/R monogram with a detailed interlocking geometric emblem.
- Changed the website accent to light blue against a near-black background.
- No waveform or audio-symbol imagery is used in the logo.
- The macOS icon and app header use the same emblem and blue accent.

## Website presentation

- Reduced homepage text and replaced promotional copy with technical descriptions.
- Removed decorative pre-titles from every page.
- Added a geometric D/R logo and wordmark; changed the website accent to cyan.
- Firmware, patch resources and patching behavior are unchanged.

## Browser website — 13 October 2026

- GitHub Pages site with browser patcher, demo, manual and disclaimer.
- JavaScript port of the existing firmware-format tool and level-0 compressor; exact DigiRust output verified.
- Local worker processing, pinned resources, explicit download and cancellation. No firmware upload, MIDI access or installation.
- Native/browser codec parity tests and automated static publication/deployment checks.
- DigiRust firmware behavior and DigiRust 1.2.0 macOS target remain unchanged.

## DigiRust 1.2.0

- First patcher-only GitHub publication.
- Native macOS patcher for official Digitone II OS 1.12 → DigiRust.
- DigiRust adds independent 0–100% Kit Brutality controls for IDM and Rhythmic Noise, with contrasting bars, DATA editing/cancel and repeat YES generation.
- Retains patch, kit, pattern and phrase generators, pattern controls, experimental sound palettes, tempo/structure variation, compressor generation, Control All macros, live latch and Perform restoration.
- Pinned input, recipe/additions and complete output integrity checks; exclusive atomic saving and no automatic instrument connection.

## Numbering

Patcher version **1.4.0** identifies the macOS application. **DigiRust** is the public name of the generated firmware. The internal vendor OS version remains **1.12**. Earlier development releases are not included in this repository. New stock versions require a separately validated recipe; they cannot be supported by renaming files.
