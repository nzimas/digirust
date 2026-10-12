# Features and performance guide

DigiRust's musical focus is experimental electronic music: IDM, rhythmic noise, industrial sound design, electroacoustic gestures, acousmatic textures and unusual pitched material. Diversity and cohesion matter together. The tools are not designed around conventional beatmaking templates.

## Generator location and repeat workflow

The Digitone II SYSTEM menu gains **PATCH GENERATOR**, **PATTERN GENERATOR**, **KIT GENERATOR** and **PHRASE GENERATOR**.

Choose a generator and musical path. On a percentage-control screen, **YES generates and leaves that screen selected** for another YES. **DATA/LEVEL press** enters editing; turn it to change the selected percentage; press again to finish. **NO** cancels an active edit, or returns to the parent menu outside editing. DATA does not generate.

Leaves without percentage controls generate directly when selected and confirmed with YES; their selection remains available for repetition. Generation releases active DigiRust drone latches before updating content.

## Paths

- **Abstract:** evolving textures, drones, sound effects and electroacoustic material. No physical track is permanently assigned one abstract archetype.
- **Rhythmic → IDM:** articulated experimental percussion and glitches, with organized but varied structures.
- **Rhythmic → Rhythmic Noise:** harsher synthesis and effects, industrial intensity and rhythmically purposeful noise.
- **Melodic:** pitched experimental sound and sequence generation; melodic does not imply a conventional lead or organ preset.
- **Free:** guarded broad sound exploration. Available in Patch and Kit; not a Pattern or Phrase path in RC17.

Phrase Generator has Abstract, Rhythmic and Melodic leaves; its Rhythmic leaf has no IDM/Noise submenu in RC17.

## Scope and controls

| Generator | Replaced content | Adjustable controls |
| --- | --- | --- |
| Patch | Selected audio track sound only; selected MIDI tracks are refused | Brutality for Abstract, IDM and Rhythmic Noise |
| Kit | All 16 track sounds, including conversion of MIDI tracks to generated audio tracks | Independent Brutality for IDM and Rhythmic Noise |
| Pattern | Complete sequence content; compressor and tempo behavior are part of generation | Density on Abstract, IDM, Noise and Melodic; Brutality on IDM and Noise |
| Phrase | Selected track sequence; other track sequences preserved | No Density/Brutality editing screen in RC17 |

Kit generation preserves the pattern and non-sound kit settings, including compressor settings. Pattern generation has its own compressor logic. Patch Brutality does not directly set the compressor.

### Density and Brutality

Density determines sequence population, including active-track participation and event density. Low-density patterns do not need all 16 tracks. Brutality changes the character of a rhythmic sequence or a generated sound according to its path.

For sounds, increasing Brutality influences source complexity, modulation, drive and bit/sample-rate reduction, with output gain compensation. Abstract, IDM and Noise use different treatments. Zero retains an experimental palette; it does not restore a stock preset. These bounds and compensation are not an audio limiter.

Controls run from **0–100%**. Pattern Density defaults to **30%**; exposed Brutality controls default to **35%**. Values are independent between tools and applicable paths, and reset on restart. The bar fills behind its label, with text contrast inverted over the fill. Selection and editing use different chevrons.

RC17 adds kit Brutality to IDM and Noise. At 35%, the same seed produces byte-identical kits to RC16. Abstract kits retain their fixed 35% sound treatment. Melodic and Free kits retain their prior behavior.

### Track roles

Rhythmic sound generation retains tracks **1–8** as percussion roles, including kick on track 1. Tracks **9–12** independently draw abstract roles and timbral families; tracks **13–16** independently draw melodic roles and families. There is no permanent bass/lead assignment in the upper zone.

Abstract and Melodic patch generation work independently of the selected physical track position. Kit palettes follow the documented role treatment; choosing a kit path is not a guarantee of a fixed instrumentation list.

## Control All macros

Hold **TRACK** and turn an encoder. DigiRust extends the gesture across corresponding parameter positions on **every subpage of SYN, FILTER, AMP and FX**. This can change many parameters at once. The macro feature does not itself create a separate reversible mode.

Releasing TRACK leaves edits in place. The stock **TRACK + NO** undo remains available. Use **Perform Kit** for the documented non-destructive performance workflow.

## Live drone latch and Perform Kit

With Grid Recording disabled, hold an audio track's live trig first, then tap **FUNC**. Release both: the note remains gated. Repeat that gesture to unlatch the track; **STOP** releases all latches. Several audio tracks can be latched. FUNC-first gestures retain their stock meaning; MIDI tracks are excluded.

The later latch implementation retains the existing live note rather than introducing another note-on at latch activation. A retained gate is not a guarantee that every envelope or sound will remain audibly constant: independently decaying elements can fade.

Enable **Perform Kit** with **FUNC + PRESET/KIT**, sculpt the sounds, then exit with the same gesture. DigiRust reapplies the restored parameter state to latched voices without another note-on/off. It does not rewind oscillator phase, envelopes or effect tails to a previous instant.

## Practical limits

Firmware parameter and input tests are described in [VALIDATION.md](VALIDATION.md). Physical listening remains necessary to judge seed quality, gain and performance behavior. Neither style names nor parameter diversity prove that every seed will be musically useful or unique.
