# Milestone 6 — First-boot OOBE (spike) verification

**Date:** 2026-11-08  
**Installed system:** `ethereal-os.qcow2` (from M5)  
**OOBE under test:** tree copy injected via virtio FAT + tty2 install  
**Evidence:** `out/verification-m6/`

## Acceptance (spike)

| Criterion | Result |
|-----------|--------|
| Does **not** run on live ISO | **PASS** (`ethereal-oobe status` → `action=skip` on live) |
| Runs once on installed system when `state=needed` | **PASS** (`37/38-oobe2.png` welcome → keyboard) |
| Skips account creation when user exists | **PASS** (account summary for `demo`) |
| Keyboard / network / appearance / privacy pages | **PASS** (review showed keyboard=us, theme=aurora) |
| Finish marks `state=done` | **PASS** (`44-status.png`: `state=done`, `action=skip`) |
| Second login skips OOBE → normal desktop | **PASS** (`42` wallpaper desktop, terminal status) |
| No plaintext passwords in draft/state | **PASS** (draft has layout/theme only) |

## Fixes during M6

1. Session gate in `ethereal-session` → OOBE-only Sway config while `needed`/`in_progress`.
2. State dir made world-writable by installer so wizard never prompts for sudo.
3. `sudo -n` only for optional system keyboard apply; user Sway XKB always written.
4. Finish returns to greeter; next login is normal desktop (nested session handoff was unreliable).

## Limitations

- UI is foot TUI (GTK4 wizard still future).
- Appearance page only applies existing `ethereal theme` packs.
- Network page offers `nmtui` optionally; no full NM GUI.
- OOBE **not yet baked into ISO** — next `./build.sh` ships it.
- Finish → greeter (one extra login) rather than seamless compositor replace.

## Verdict

**Milestone 6 spike: Passed** (VM installed path).

**Next:** rebuild ISO to bake OOBE + M5 installer; then M7 services matrix or polish OOBE UI.
