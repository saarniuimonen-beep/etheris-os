# Verification — reliability live smoke (2026-11-15)

KVM QEMU (`qemu:///session`). Evidence: `out/qemu-reliability-smoke-20261115/`.

## Artifact

| Item | Value |
|------|--------|
| ISO | `out/etheris-2026.11.15-x86_64.iso` |
| SHA256 | `ec72603b4dd635dec6394562516196798c605d037d81614faca278eed7889e75` |
| Accel | KVM · host-passthrough |

## Results

| Check | Result | Evidence |
|-------|--------|----------|
| Boot → ReGreet | **PASS** | `fresh-greeter.png`, `boot-*.png` |
| Session list prefers Etheris (Sway); no stock Sway UI | **PASS** | greeter screenshots |
| Password card after Login click | **PASS** | `typed-pw.png`, `post-auth.png` |
| Cold `skip_selection` auto password-first | **PARTIAL** | User/Session still shown until Login; then password + auto session |
| Graphical login `etheris`/`etheris` → desktop | **PASS** | `desktop-clean.png`, `ui-01.png` |
| Waybar brand **Etheris** + **Menu** chip | **PASS** | `desktop-clean.png` |
| Super+A → Etheris MENU sheet | **PASS** | `menu-super-a.png` |
| Super+D → icon launcher | **PASS** | `super-d-launcher.png` |
| `etheris-menu-hover` running | **PASS** | `final-checks.png` (`python3 …/etheris-menu-hover`) |
| Hover-open via QEMU tablet abs coords | **FLAKY** | process up; abs tablet ≠ guest evdev path used by watcher |
| `etheris-auth-check` | **PASS — 12 OK, 0 FAIL, 0 SKIP** | TTY OCR + `final-checks.png` |
| Password hash matches `etheris` | **PASS** | auth-check |
| `nftables` + hide-sway + regreet-cache units active | **PASS** | three `active` in terminal output |
| Watermark **Etheris OS** | **PASS** | desktop screenshots |

## Notes

1. ReGreet still needs a **Login** click (or equivalent) before the password row appears on cold live boot — cache seeds user/session correctly and auto-selects Etheris (Sway) on the password card (`Auto-selecting session 'Etheris (Sway)'`).
2. Greeter AUTH_ERR once during automation was a focus/typing miss; TTY + later graphical login confirm credentials.
3. Menu hover watcher is live; automated abs-tablet hover is unreliable vs the guest’s evdev absolute path — click / Super+A cover Menu open.

## Verdict

**Live reliability smoke PASS** for bake `ec72603b…` (desktop, Menu, launcher, auth-check 12/12, hide-sway, nftables).  
Password-first without any click remains **PARTIAL** (Alpha 0.2 follow-up).
