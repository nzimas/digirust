# Build and command-line use

## Build the patcher

On macOS with Apple's Xcode command-line tools installed:

```sh
git clone https://github.com/nzimas/digirust.git
cd digirust
./build.sh
```

The build creates `dist/DigiRust.app`, compiles Apple Silicon and Intel executables, renders the application icon and applies ad-hoc signatures. It regenerates `Sources/BackendPin.swift` to match the signed bundled backend. Differences in that generated file after a local build are expected.

The recorded local patcher testing used Apple Silicon and **macOS 27.0 (build 26A428)**. The build flags target macOS 11 as a minimum deployment version; this does not establish compatibility testing on macOS 11 or every later release.

The runtime app needs no Python or development tools. Building from source needs Swift, Clang, lipo, sips, iconutil and codesign supplied by macOS/Xcode tools.

This is the **patcher source**, not a complete firmware source tree. Its resources target the exact official OS 1.12 and RC17 output. Renaming the input or editing a version string cannot support a different OS.

## Command-line patching

```sh
"dist/DigiRust.app/Contents/MacOS/DigiRust" --patch \
  /path/to/official/Digitone_II_OS1.12.syx \
  /path/to/new/Digitone_II_OS1.12_DigiRust_rc17.syx
```

Exit zero means the output was created and verified against the pinned RC17 SHA-256. Existing output files, aliases to the input, invalid input and tampered resources are rejected. Output is published only after verification. No instrument transfer occurs.

## Validate publication contents

```sh
python3 tools/audit_distribution.py
python3 tools/package_release.py
```

The audit checks tracked/publication files and resource pins, rejects firmware image extensions and complete known firmware hashes, and checks bundled license files. The packaging script includes only the built patcher, user documentation and required notices. Outputs go into ignored `dist/`.

To test reconstruction locally, use your own supported official firmware and compare the generated hash with [VALIDATION.md](VALIDATION.md). Do not commit that input, generated output, decrypted sections or temporary test fixtures.

## Repository layout

| Path | Contents |
| --- | --- |
| `Sources/` | Native AppKit interface and patch engine |
| `Resources/` | COPY/ADD recipe, additions, hashes and license texts |
| `Vendor/` | Bundled firmware-format tool source, license and provenance |
| `Artwork/` | Source code for the app icon |
| `docs/` | User, build, validation and distribution documentation |
| `validation/` | JSON summaries from local RC17 and patcher tests |
| `tools/` | Publication audit and release packager |

No firmware download, MIDI access, telemetry or automatic deployment is implemented.
