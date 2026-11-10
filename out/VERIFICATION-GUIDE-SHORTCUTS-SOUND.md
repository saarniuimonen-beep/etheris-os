# Verification — First-login guide, Shortcut Center, startup sound

**Date:** 2026-11-08  
**VM:** `qemu:///session` / `ethereal-os` (installed `demo` user)  
**Evidence:** `out/verification-guide-shortcuts-sound/`

## Results

| # | Check | Result |
|---|--------|--------|
| 1 | First-login guide appears once (installed) | **PASS** (`04-guide.png` step 1/5) |
| 2 | Finish/Skip persist; second login no auto-guide | **PASS** (`09-second-login.png` desktop only) |
| 3 | Manual reopen available (`ethereal guide --force`) | **PASS** (binary + desktop entry) |
| 4 | Shortcut Center via `Super+/` | **PASS** (`06-shortcuts.png`) |
| 5 | Shortcut Center via launcher `.desktop` | **PASS** (files under `/usr/share/applications/`) |
| 6 | Catalog searchable / categorized | **PASS** (categories + search prompt) |
| 7 | Startup sound file present | **PASS** (`startup.wav`) |
| 8 | Default disabled; enable works | **PASS** (`startup_enabled=0` → `1`) |
| 9 | Preview without reboot | **PASS** (`Played: …/startup.wav`) |
| 10 | Settings hooks (`ethereal settings` / sound menu) | **PASS** (CLI + wofi entries in tree) |

## Notes

- Guide uses flag `~/.config/ethereal/guide-done`; legacy `welcomed` also counts as done.
- Startup sound default remains **off**; enable with `ethereal sound enable`.
- Playback uses `/usr/bin/pw-play` or `/usr/bin/paplay` (PipeWire).
- Tree changes are in airootfs; next ISO rebuild ships them without inject.

## Verdict

**PASS** for this UX slice on the installed VM path.
