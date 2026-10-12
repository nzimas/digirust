# DigiRust RC17 — rhythmic kit Brutality

Separate firmware release based on official Digitone II OS **1.12**. Internal OS version remains **1.12**. Previous firmware releases and DigiRust RC16 patcher archives are preserved.

## Kit Generator workflow

Choose **Kit Generator → Rhythmic → IDM** or **Rhythmic Noise**. Each opens a single **BRUTALITY** percentage row with a proportional, dynamically contrasting bar.

Press **DATA/LEVEL** to edit; turn the encoder to set **0–100%**; press it again to finish. **NO** cancels an in-progress edit. **YES** generates a complete 16-track kit and keeps the screen selected, so repeated YES presses generate more kits. DATA never generates a kit. NO outside editing returns to the parent menu.

IDM and Rhythmic Noise each remember an independent value while the instrument is running, initially **35%**. Values reset to 35% on restart. Kit values are independent of Patch Generator and Pattern Generator values. At 35%, the same seed produces exactly the previous RC16 rhythmic kit, preserving the existing default palette.

## Effect on generated sounds

The selected percentage feeds the existing path-specific experimental sound stage for **every sound in the kit**. Higher values increase source colour/complexity, modulation depth, overdrive and bit/sample-rate reduction, with output gain compensation. IDM retains articulated experimental percussion; Rhythmic Noise uses harsher source and effects treatment. Upper abstract and melodic zones receive the same percentage through their sound-role treatment.

Tracks **1–8** retain their existing percussion assignments, including kick on 1. Tracks **9–12** independently draw abstract roles/families; tracks **13–16** independently draw melodic roles/families. Brutality does not replace these allocations. Kit generation replaces all sixteen track sounds while preserving the current pattern and other kit settings, including the compressor. Pattern Generator retains its own separate compressor-generation logic.

Abstract, Melodic and Free kit paths retain their existing immediate YES workflow. Abstract kits retain their previous fixed 35% sound colour; Melodic and Free behavior is unchanged. This release adds no Kit Density setting.

## Validation limits

Local host and ColdFire CPU tests check all-track control, parameter bounds, gain compensation, same-seed parity at 35%, stock sound-codec roundtrips, actual menu editing/cancel and framebuffer contrast, installed atomic publication, retained performance behavior and exact-package emulated boot/panel operations. Synthetic hardware cannot establish physical sound quality, DSP timing or cache behavior. The automated development runs did not access or deploy to an instrument. The developer subsequently reports thorough testing and issue-free current operation on a real Digitone II; see docs/VALIDATION.md. That report is not an installation endorsement or a guarantee. The percentage is a synthesis control, not an audio limiter.
