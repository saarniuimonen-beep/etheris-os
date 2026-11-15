# Verification — idle RAM + Nov 12 ISO (2026-11-12)

**Host:** Fedora stayed up the whole time (`qemu:///session` only — no host reboot).  
**ISO:** `etheris-2026.11.12-x86_64.iso`  
**SHA256:** `2513da3821d162ce66a977a9ff58e27ccc31e9aed4855792f9f77d5213c37f8f`  
**VM:** `etheris-os` · 3584 MiB · live CDROM boot

## Results

| Check | Result |
|-------|--------|
| Attach new ISO / live boot | PASS |
| ReGreet branding | PASS — Etheris OS, Etheris Live User, session **Etheris (Sway)**; wallpaper mark Etheris |
| `etheris-perf` execute bit | PASS (binary runs; live MODE=mutable-classic expected) |
| Lean Firefox profile | PASS — `~/.local/share/etheris/firefox-lean/user.js` present |
| `etheris-immutable status` | PASS — reports mutable-classic on live (immutable-prep is install/Btrfs) |
| Idle with **warm Firefox resident** | **FAIL vs ≤500 MiB** — ~1.2 GiB system used / session_rss inflated |
| Idle **without** Firefox (one terminal) | **Borderline** — `session_rss` ≈ **505 MiB**, `system_used` ≈ **732 MiB** |

## Conclusion on 2B (warm preload + ≤500)

Full resident Firefox warm-start **cannot** fit under 500 MiB on this live Sway stack: the shell alone is already ~505 MiB session_rss.  

Follow-up in tree (next local bake):

- Prepare **lean profile always** when `browser_preload=on`
- Start warm Firefox **only** if session Pss is still under a warm budget (or `ETHERIS_BROWSER_FORCE_WARM=1`)
- Super+B still uses the lean profile (faster/smaller cold start when warm was skipped)
- Idle gate metric switched toward **Pss** (less double-counting than raw VmRSS sum)

## Fedora safety

Host uptime continued across all guest start/stop/poweroff tests. Only `qemu:///session` domain `etheris-os` was used.
