# Distribution, attribution and licensing

DigiRust is distributed as a macOS patcher and patcher source. Users supply their own exact official Digitone II OS 1.12. Neither the repository nor release archives provide complete stock or modified firmware.

The shipped recipe and modification additions are necessary for local patching. This is not a source distribution of the full generator firmware development environment. Known stock-derived sound templates and displaced instruction blocks are sourced from the user's input rather than bundled as complete templates; see `Resources/provenance-audit.json`.

The bundled firmware-format tool is an independent implementation attributed to Marcel Bierling, with its own MIT license and provenance statement under `Vendor/elektron-firmware-tool/`. Those statements describe that component, not the provenance of every firmware modification byte.

The additions include GCC support routines. GPLv3 and GCC Runtime Library Exception 3.1 texts are retained in `Resources/`; see `NOTICE.md` for scope. Third-party licenses apply to their respective components. This repository does not grant an additional blanket open-source license over the author's own files or the generated vendor firmware.

Patcher-only distribution avoids supplying complete firmware but does not, by itself, establish legal permission for adaptation or redistribution of every addition. See the retained notices. No claim of legal clearance is made.

The project's musical direction is the author's: tools for edgier experimental electronic music, including IDM, rhythmic noise, industrial, electroacoustic and acousmatic practice. Conventional groovebox beatmaking is outside its design scope.

## Publication boundary

Included: patcher source, recipe/additions, artwork, required notices, documentation, selected JSON validation summaries and a compiled patcher release.

Excluded: official or generated `.syx` files, decrypted firmware sections, complete MAIN images, firmware research sources and dumps, instrument data, local test fixtures, temporary directories, credentials and full private emulator evidence.
