# Features and performance guide

DigiRust's musical focus is experimental electronic music: IDM, rhythmic noise / power noise, and electroacoustic music. Diversity and cohesion matter together. The tools are not designed around conventional beatmaking templates.

## Generator location and repeat workflow

The Digitone II SYSTEM menu gains **PATCH GENERATOR**, **PATTERN GENERATOR**, **KIT GENERATOR** and **PHRASE GENERATOR**.

Choose a generator and musical path. On a percentage-control screen, **YES generates and leaves that screen selected** for another YES. **DATA/LEVEL press** enters editing; turn it to change the selected percentage; press again to finish. **NO** cancels an active edit, or returns to the parent menu outside editing. DATA does not generate.

Leaves without percentage controls generate directly when selected and confirmed with YES; their selection remains available for repetition. Generation releases active DigiRust drone latches before updating content.

## Paths

- **Abstract:** evolving textures, drones, sound effects and electroacoustic material. No physical track is permanently assigned one abstract archetype.
- **Rhythmic → IDM:** articulated experimental percussion and glitches, with organized but varied structures.
- **Rhythmic → Rhythmic Noise:** harsher synthesis and effects, industrial intensity and rhythmically purposeful noise.
- **Melodic:** pitched experimental sound and sequence generation; melodic does not imply a conventional lead or organ preset.
- **Free:** guarded broad sound exploration. Available in Patch and Kit; not a Pattern or Phrase path in DigiRust.

Phrase Generator has Abstract, Rhythmic and Melodic leaves; its Rhythmic leaf has no IDM/Noise submenu in DigiRust.

## Scope and controls

| Generator | Replaced content | Adjustable controls |
| --- | --- | --- |
| Patch | Selected audio track sound only; selected MIDI tracks are refused | Brutality for Abstract, IDM and Rhythmic Noise |
| Kit | All 16 track sounds, including conversion of MIDI tracks to generated audio tracks | Independent Brutality for IDM and Rhythmic Noise |
| Pattern | Complete sequence content; compressor and tempo behavior are part of generation | Density on Abstract, IDM, Noise and Melodic; Brutality on IDM and Noise |
| Phrase | Selected track sequence; other track sequences preserved | No Density/Brutality editing screen in DigiRust |

Kit generation preserves the pattern and non-sound kit settings, including compressor settings. Pattern generation has its own compressor logic. Patch Brutality does not directly set the compressor.

### Density and Brutality

Density determines sequence population, including active-track participation and event density. Low-density patterns do not need all 16 tracks. Brutality changes the character of a rhythmic sequence or a generated sound according to its path.

For sounds, increasing Brutality influences source complexity, modulation, drive and bit/sample-rate reduction, with output gain compensation. Abstract, IDM and Noise use different treatments. Zero retains an experimental palette; it does not restore a stock preset. These bounds and compensation are not an audio limiter.

Controls run from **0–100%**. Pattern Density defaults to **30%**; exposed Brutality controls default to **35%**. Values are independent between tools and applicable paths, and reset on restart. The bar fills behind its label, with text contrast inverted over the fill. Selection and editing use different chevrons.

DigiRust adds kit Brutality to IDM and Noise. At 35%, the same seed produces byte-identical kits to the preceding development build. Abstract kits retain their fixed 35% sound treatment. Melodic and Free kits retain their prior behavior.

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

## PAGE shortcuts

Hold **PAGE** and press a second key. PAGE alone, and each key without PAGE, keep their stock behavior. With **FUNC** held first, the generator shortcuts are off. The key press and its release are withheld from the stock firmware when a shortcut fires. Generation releases DigiRust drone latches first, as menu generation does.

| PAGE + | Result |
| --- | --- |
| **TRIG** | New patch on the selected audio track (MIDI tracks refused) |
| **SYN** | New kit, after **NEW KIT? YES/NO** |
| **FILTER** | New phrase on the selected track, with its own length and clock |
| **AMP** | New pattern, after **NEW PATTERN? Y/N** |
| **Trig key 1–16** | Selects that track and rolls its locks, velocities and conditions |
| **FUNC** (held) | Pattern break while held |
| **KEYBOARD** (held) | Shuffle while held |
| **TRK** (held) | Gate while held |
| **MOD** | On the Compressor page only: copy the compressor to the bank |

### Generator shortcuts

Each press draws its path from **Abstract**, **IDM** and **Rhythmic Noise** (the phrase shortcut has its own engine, see [Phrase shortcut](#phrase-shortcut)). Every path appears once per round and a new round never opens with the path the previous one closed on, so consecutive presses change path. Density (15–65%) and Brutality (10–90%) are drawn per press where the path has them. The values on the SYSTEM generator screens are not read or changed.

The shortcuts give each track a sound by its zone, whatever path is drawn:

| Tracks | Sounds |
| --- | --- |
| **1** | Always a kick |
| **2–12** | Strike sounds: snares, claps, cracks, closed and open hats, rides, cymbals, toms, rims, clangs, slams, stamps, shakers, cowbells and short noises. A kit deals every kind at least once. |
| **13–16** | Textures, atmospheres, drones and pads (no leads, basses or plucks); at most two of a kind in a kit |

The path only colours the sounds: Noise is driven and reduced, IDM crisp and metallic, Abstract roomier and longer. Strike sounds come from the existing recipes or from new strike designs on FM DRUM, WAVETONE and FM TONE. Every strike has a fast attack, no sustain and a decay set by its kind. Pitch sweeps are kept short (a kick's drop, a tom's thump, nothing else) and no LFO reaches a pitch. Kicks stay in kick range; textures always sustain and release slowly.

Each sound is named after its role (RIVET CLANG, GLASS HAT, FOG WASH …), so the pattern, phrase and break generators treat every track as what it was made to be. **PAGE + AMP** treats tracks 1–12 as percussion, and textures and pads hold long notes (one or two bars). **PAGE + FILTER** writes a phrase in the sound's own role (see [Phrase shortcut](#phrase-shortcut)). The shortcut draws are stirred by a clock that runs from power-on, so a new session does not repeat the previous session's kits.

The SYSTEM menu generators keep the track roles described above.

The kit and pattern questions stay on screen until answered. **YES** generates; **NO** or any other key cancels. Patch and phrase shortcuts are immediate.

Every patch and kit generator, from the menus or shortcuts, sets the delay send to 0. Reverb and chorus sends remain; the pattern generator's delay throws are unchanged.

### Phrase shortcut

**PAGE + FILTER** writes a new phrase on the selected track only, in the role of its sound. It also sets that track's own **length, 2 to 32 steps**, and its own **clock**: 2x, 3/2x, 1x, 3/4x, 1/2x, 1/4x or 1/8x. The SYSTEM menu Phrase Generator is unchanged.

Some phrases stay locked to the bar while changing the feel: 24 steps at 3/2x (triplets over a bar), 32 at 2x (32nd notes), 12 at 3/4x (a dotted feel), 8 or 16 at 1/2x. Others drift as polymeter, at lengths such as 5, 7, 10, 11, 13, 21, 22, 26 or 31. The kick and snare always lock to the pattern's own meter (16 or 32; 12 or 24 in a 3/4 set). The bar is read from the kick track, or from the most common loop.

| Role | Length and clock |
| --- | --- |
| Kick | One or two bars at 1x, or two bars at 2x |
| Snare, clap | One or two bars, 1x or 2x |
| Hats, shakers | Straight, triplet (3/2x) or 32nd (2x); or 6, 10, 12, 14, 20 or 22 steps |
| Open hats, rides, cymbals | Longer odd loops, or 3/4x |
| Toms, rims, perc | Odd loops, groups of 2 and 3 |
| Clangs, slams, stamps | 20 to 32 steps, sometimes at 1/2x; sparse |
| Textures, drones, pads | 3 to 16 steps at 1/2x, 1/4x or 1/8x, with held notes; a pair of notes may alternate by cycle |

A strike sound draws one of twelve rhythm families: a Euclidean spread with an accent layer; aksak (the loop split into 2s and 3s); ghost-weighted placement by position in the beat; Thue-Morse and Fibonacci-word placement; an elementary cellular automaton, its generations played as cycle conditions; tresillo, clave and bembé timelines; power-noise hammering with an accent contour and gaps; industrial stomp (heavy displaced hits); broken IDM figures with flams; and four-on-the-floor and backbeats (kick and snare only).

Then modifiers: ghost notes, rolls, groove (swing, drag, push), cycle variation and a turnaround every fourth cycle, a few locks (shorter decay on ghosts, a brighter filter on accents, filter and reverb on textures) and tom pitches. Phrases have no pitch movement apart from a small fixed tom note set. Density is capped per role, the kick keeps step 1, textures get no retrigs, and ghosts stay off the kick.

Everything is ordinary step data: accent, normal and ghost velocities, micro timing, probability (ghost notes only), cycle conditions (1:2 … 4:4, and A:N for automaton generations), retrigs and locks. Edit any step afterwards as usual.

If the pattern is in one-length mode, the phrase switches it to per-track mode first. Every other track keeps playing exactly as before: its length is set to the length it was playing, its clock to the master scale, the master length becomes INF and the pattern still changes after the old length.

### Lock roll

PAGE + trig key N selects track N (no note is played) and rolls its sequence:

- **Parameter locks** on every triggered step, from the sound processing only, never the source: filter frequency, resonance and envelope, amp decay/sustain/release and pan, overdrive and bit/sample-rate reduction (leading most rolls, as grit on some steps), LFO speed/fade/phase/depth for LFOs with a non-pitch destination, and reverb/chorus/delay sends, with occasional 1–3-step delay throws. SYN machine parameters, pitch, envelope attacks and amp hold and volume are never locked.
- **Velocity** per trig.
- **Cycle conditions** (1:2 … 4:4), no probability. The first trig stays unconditional.
- **Note lengths** in about one roll in three, never on sustained material, always within the gap to the next trig.

Each press replaces that track's previous roll; it does not accumulate. Steps, notes and other tracks are never changed. MIDI tracks are refused.

### Break

Hold **PAGE**, then hold **FUNC**. The whole pattern breaks for as long as FUNC is held; release either key and it returns exactly as it was. Each press draws a character, never the same twice in a row: **STUTTER**, **HALF**, **DOUBLE**, **REVERSE**, **CHOP**, **ROLL** or **SLAM**. Drum tracks add their own ratchets and flams (real Elektron retrigs); the kick keeps each bar's first step; melodic tracks follow the time feel; drones are left alone. The kit is untouched and latched drones keep playing. **FUNC first, then PAGE** keeps its stock meaning.

The break uses the loop's own bars (see [Meter](#meter)): in a 12-step loop, chop shuffles three beats, reverse works in beats, the second slam lands on beat 3 or the and of beat 2, and rolls, bursts and gaps fall in the last beat. Patterns in 4/4 break exactly as before.

### Shuffle

Hold **PAGE**, then hold **KEYBOARD**. While both are held, the tracks trade their sequencing: each track with notes plays another track's trigs (which steps fire, velocity, length, micro timing, trig condition, retrig and locks) on its own sound and at its own pitches. On a step where it has no note of its own, it plays its last earlier notes. The trade is redrawn in half beats, beats or half bars (whole bars when a 3/4 loop has more than one), always on the grid, so a piece never crosses a beat. Tracks of the same length and clock trade together, and no stretch leaves every track on its own steps. A track of another length follows its own loop; a step it borrows keeps its place in the source's bar instead of wrapping. Each press draws a new shuffle.

Release either key and the original pattern is put back exactly; nothing is saved. Tracks with no notes, MIDI tracks and empty tracks are left alone. A lock moved to a track on another machine is kept within that machine's range, or dropped if it has no such parameter. Break and shuffle never stack. KEYBOARD alone, or before PAGE, works as before.

The Digitone II sequencer is stock, so a shuffled pattern is swapped in while the keys are held: a 16-step pattern repeats its shuffle each time round until you press again.

### Gate

Hold **PAGE**, then hold **TRK**. While both are held, the tracks with notes are muted and opened rhythmically. The pattern is cut into slices on one timeline shared by all tracks, so the gating stays in time with the tempo. In each slice some tracks play and some are silent; every slice keeps at least one track playing and, with two or more tracks, silences at least one.

Slices are a step, half a beat or a beat long and never cross a beat; they are shared by the tracks of the same length and clock, and every slice keeps one of them open and mutes another. Each press draws a new gating and its feel: all sixteenths, sixteenths and eighths, or a broken mix up to quarter notes, and how often the tracks are open (40–65% of the time).

A silenced step plays nothing: no trig, no note, no parameter lock. A step that plays is unchanged. A note that started before a silenced step rings on through it, so note releases and delay and reverb tails are kept. A sustained track whose only trig falls on a silenced step is silent for the whole hold.

Release either key and the original pattern is put back exactly; nothing is saved. Tracks with no notes, MIDI tracks and empty tracks are left alone. While the gate is on, trig keys do nothing. Break, shuffle and gate never stack. TRK alone, or before PAGE, works as before.

As with the shuffle, a gated pattern is swapped in while the keys are held: a 16-step pattern repeats its gating each time round until you press again.

### Meter

Break, shuffle and gate work from the length each track actually plays: in one-length mode the pattern's LENGTH (not each track's stored length, which the Digitone keeps but does not play); in per-track mode each track's own length, cut short by a master length below it. The beat and bar come from that length: a loop of 16, 32 or 64 steps is 4/4 with bars of 16; a loop of 12, 24 or 36 steps is 3/4 with bars of 12, three beats of four; other lengths get the nearest even grouping. Steps past the played length are never touched.

### Compressor to bank

Open the Compressor page (**FUNC + MOD**, titled "Compressor (1/5)"), hold **PAGE** and press **MOD**. The nine compressor controls (THR, ATK, REL, MUP, VOL, RAT, SCS, SCF, MIX) are copied to every other pattern in the current bank of 16 that has at least one note. The screen confirms **COMP APPLIED: n PATTERNS**, or **NO OTHER PATTERNS**.

Empty patterns, other banks and every other kit setting are untouched. Each pattern's compressor can still be adjusted afterwards. The copies are ordinary unsaved edits until the project is saved. On any other page, including mixer pages 2/5–5/5, PAGE + MOD behaves like MOD. While a Perform kit is active it does nothing and shows **EXIT PERFORM FIRST**.

## Note audition

In grid recording, hold a trig and turn **NOTE** on the TRIG page. Each new pitch sounds at once, on the track's sound at the step's velocity; the previous pitch is cut, so each detent plays one clean note (the whole chord if the step holds one). Releasing a trig stops the audition. The note edit itself is stock, and the audition writes nothing to the pattern or kit. NOTE turned with no trig held, and trigs outside grid recording, behave as before.

## Practical limits

Firmware parameter and input tests are described in [VALIDATION.md](VALIDATION.md). The developer's real-instrument report was made on an earlier DigiRust build; the PAGE shortcuts (including the gate, the meter rules, the shortcut zones and the phrase engine), delay-send change and note audition were verified in the emulator. See [VALIDATION.md](VALIDATION.md). Individual results still require listening to judge seed quality, gain and performance behavior. Neither style names nor parameter diversity prove that every seed will be musically useful or unique.
