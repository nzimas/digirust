# Browser patcher and GitHub Pages

Website: https://nzimas.github.io/digirust/

Patcher: https://nzimas.github.io/digirust/patcher.html

## Architecture and privacy

The site is static HTML/CSS/JavaScript with no application server and no npm runtime dependencies. `web/core/patcher.mjs` ports the existing bundled MIT-licensed format tool's Digitone II transport, ELE3 reconstruction and aPLib level-0 packing. It applies the same COPY/ADD recipe and additions as the macOS app. The port is intentionally restricted to the exact supported official Digitone II OS 1.12; it is not a general firmware editor.

`web/core/worker.mjs` handles validation and patching off the UI thread. Web Crypto supplies SHA-256 and HMAC. The input file is read into browser memory, not uploaded or placed in browser storage. Only static site assets and patch resources are fetched. The site has no MIDI or instrument connection, telemetry, service worker or automatic installation.

The optional demo loads YouTube's privacy-enhanced player only after the visitor presses play. GitHub serves the site; normal hosting request handling still applies. Local file processing does not mean the whole website is offline.

## Integrity and saving

Input, recipe, additions, stock MAIN, modified MAIN and final `.syx` hashes are checked. Compression is round-tripped. Protected sections are preserved byte for byte. Only a verified complete output becomes a downloadable Blob. Cancellation terminates the worker; choosing another file invalidates old output. The browser controls download naming and save dialogs; the native app's exclusive filesystem-save behavior is not claimed for browsers.

The complete generated firmware is not a website asset. It is reconstructed only in memory from the user's input and downloaded by the user's explicit action.

## Prepare and preview

```sh
python3 tools/build_web.py
python3 tools/check_web.py
python3 tools/audit_distribution.py
python3 -m http.server 8000 --directory web --bind 127.0.0.1
```

Open `http://127.0.0.1:8000/`. Production requires HTTPS; loopback is accepted as a secure context by browsers. Use a current browser with Web Crypto and module Web Workers enabled. Mobile layout support is not a claim of firmware transfer support from a phone.

`build_web.py` copies only pinned patch resources and license texts. Source files, private test fixtures, generated firmware and development dumps are never staged for Pages.

## Tests

Node 24 and a C compiler:

```sh
node tests/web_core.mjs
```

This compiles the existing native C codec as an independent oracle for seven datasets, then tests browser codec parity and input/recipe rejection. No official firmware is required for these public tests.

For complete reconstruction checks, supply your own supported firmware locally:

```sh
node tests/web_core.mjs /path/to/official/Digitone_II_OS1.12.syx
```

The extended run checks complete RC17 hash/length, unchanged input, modified firmware rejection, one-bit corruption, wrong-device input and tampered resources. The firmware remains private and no output file is committed. See `validation/web-patcher-report.json` for the recorded 24-check run and browser UI evidence.

## Deployment

`.github/workflows/pages.yml` runs the public codec tests, prepares resources, audits the publication boundary and checks links. It uploads **only `web/`** as a Pages artifact, then deploys it through GitHub Actions. GitHub Pages is configured with the workflow build type. Pushes to `main` update the site; the existing publication audit also runs independently.

The repository name determines the lowercase `/digirust/` path. Every internal site link and worker/resource URL is relative, so the project path is retained. The firmware revision is still RC17 and the internal vendor OS remains 1.12.

## Limits

The web port changes packaging and delivery, not firmware behavior. Exact hashes establish equality to the existing candidate, not hardware safety. Browser UI was exercised in the Codex in-app browser on this Apple Silicon Mac; all browser/device combinations have not been tested. Warranty and use-at-your-own-risk notices remain applicable.
