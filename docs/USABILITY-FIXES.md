# Etheris OS — Login, Startup, Welcome & Window Management

**Status: APPROVED INCREMENTAL FIXES IN PROGRESS / LANDED IN TREE**

Scope: usability/reliability issues (login polish, startup, first-login welcome, window close/switch).  
Out of scope for this pass: custom greeter replacement, OOBE, full design-system rewrite (`docs/DESIGN.md` / `docs/LOGIN.md`).

**Applied (await QEMU verification on rebuilt ISO):** Alt+F4 / Super+Q / Alt+Tab cycle / Super+H scratchpad + docs; welcome once + `etheris welcome`; foot 1.28 `colors-dark`; UTC `localtime` + firstboot mask; greeter greeting cosmetic only.

---

## Executive summary

| Area | Root cause (short) | Severity |
|------|--------------------|----------|
| Login looks unfinished | Stock **tuigreet** TUI + systemd messages on same VT; branding is greeting string only | Medium (UX) |
| Startup unpolished | No Plymouth; verbose/firstboot; pacman-init under greeter; foot errors on desktop | High (P0 firstboot already known) |
| Welcome popup broken | **`etheris-welcome` is never launched** from session/Sway; completion flag logic also flawed | High |
| Close window confusing | Only **`Super+Shift+Q`**; **no Alt+F4**; **pixel borders → no titlebar close button** | High |
| Alt+Tab / minimize | Not bound; Sway has no classic minimize (scratchpad only) | High / Medium |

---

## 1. Login screen

### What exists

| Piece | Path / notes |
|-------|----------------|
| DM | greetd → `display-manager.service` |
| Greeter | tuigreet via `profile/.../etc/greetd/config.toml` |
| Auth | PAM (`/etc/pam.d/greetd`); live passwords via `etheris-auth-setup` + `chpasswd` (hashed only) |
| Sessions | `--sessions` + default `--cmd etheris-session` |
| Power | tuigreet **F12** (built-in); not branded |

### Root causes

1. **Visual unfinished:** tuigreet is a terminal greeter; Etheris only sets `--greeting 'Etheris OS'` and `--time`. No shared design tokens, no wallpaper under greeter, boot journal still paints on VT1 (verified in QEMU).
2. **Error feedback:** “Authentication failed” is correct for wrong user (e.g. remembered `saarni`); easy to misread as broken auth.
3. **Clutter:** long-running `pacman-init` and multi-user target messages overlap the greeter.
4. **Session selection:** F3 works in tuigreet; default cmd is fine; installer greeter config uses bare `sway` (inconsistency on **installed** systems — separate from live).

### Proposed fixes (incremental — keep greetd/PAM)

| Fix | Change | Needs approval? |
|-----|--------|-----------------|
| A1 | Clearer greeting + help text (live user hint once); ensure `--sessions` list is clean | Low — config only |
| A2 | Quiet VT / delay greeter until `etheris-auth-setup` + keyring job settle; or `SkipTTY`/getty conflict review | Medium |
| A3 | Document F2/F3/F12 in motd + KEYBOARD.md | Low |
| A4 | Full branded greeter | **Yes** — `docs/LOGIN.md` |

**Do not** replace authentication without approval.

### Regressions to watch

- Autologin accidental enable  
- greeter user / PAM `pam_shells` if greeter shell path wrong  
- Session default drifting from `etheris-session`

### Test

Cold boot → tuigreet → wrong password once → correct `etheris`/`etheris` → Sway; F3 sessions; F12 reboot option visible.

---

## 2. Startup experience

### Inspect findings

| Stage | Current | Issue |
|-------|---------|--------|
| Bootloader | systemd-boot / syslinux titles “Etheris OS”; syslinux `MENU BACKGROUND splash.png` | UEFI entries still archiso-ish; no rich branded splash guaranteed |
| Splash | **No Plymouth** in packages | Verbose kernel/systemd text |
| Firstboot | Interactive timezone TUI on shipped ISO | Blocks polished path (`VERIFICATION-LIVE-DESKTOP.md`) |
| Greeter transition | Journal under tuigreet | Looks broken |
| Desktop start | sway → waybar/mako/`etheris apply-session` | **foot.ini errors** when terminal opens; no welcome (see §3) |

### Root causes

1. Missing `/etc/localtime` on ISO + firstboot mask not in **built** image.  
2. No splash; reliability-first text boot.  
3. Startup jobs (pacman-init) unbound from greeter UX.  
4. Broken foot config makes first terminal look like a crash.

### Proposed fixes

| Fix | Notes |
|-----|--------|
| B1 | Ship timezone + keep `systemd-firstboot` masked; rebuild ISO (**already recommended P0**) |
| B2 | Fix `foot.ini` for foot 1.28 |
| B3 | Optional later: Plymouth or quieter `quiet splash` **without** hiding emergency shell / failure targets |
| B4 | Order: auth-setup before greeter (already `Before=greetd`); consider After= for pacman-init not on tty1 spam |

**Do not** hide real failures (emergency.target, failed units).

### Regressions

Over-quiet boots hiding disk/fs errors; Plymouth delaying recovery.

### Test

Cold boot screenshot series; no firstboot TUI; greeter readable; no unexpected windows before intentional welcome.

---

## 3. First-login welcome popup

### What exists

- Script: `usr/local/bin/etheris-welcome`  
- Flag: `~/.config/etheris/welcomed` (`touch` at end)  
- Packaged in `profiledef.sh`  
- **Not referenced** by `etheris-session`, Sway `exec`, systemd user unit, or `etheris apply-session`

### Root causes

1. **Never autostarted** — primary bug. Popup “doesn’t behave” often means it never appears, or appears only if run manually.  
2. **Completion flag after UI:** `touch welcomed` runs even when foot fails (`|| true`), so a failed launch can mark “done” and never retry.  
3. **Should touch only after Enter:** currently touches unconditionally after foot exits (OK if user pressed Enter; bad if foot crashed immediately).  
4. **Content:** hardcodes live credentials — wrong for installed systems; conflicts with OOBE later.  
5. **Reopen:** no `etheris welcome` command; no check of flag for manual reopen.  
6. **Interference:** if later hooked as blocking `exec`, could delay waybar; should be `exec` async or `exec_always` once.

### Proposed fixes (fix existing implementation first)

| Fix | Detail |
|-----|--------|
| C1 | Autostart once: Sway `exec` wrapper e.g. `exec etheris-welcome` **or** call from `etheris apply-session` if `! -f welcomed` |
| C2 | Only `touch welcomed` after successful dismiss (Enter); do not touch on foot crash |
| C3 | Guard: if `welcomed` exists, exit 0 immediately |
| C4 | Manual reopen: `etheris welcome` ignoring flag or with `--force` |
| C5 | Soften copy (no password on installed images; detect live via archiso) |
| C6 | Prefer floating foot geometry if available; don’t steal focus forever |

**Do not** expand into full OOBE here (`docs/OOBE.md`).

### Regressions

- Welcome every login if flag path wrong (XDG_CONFIG_HOME)  
- Duplicate windows if both apply-session and sway exec call it  
- Blocking session start if run synchronously in `etheris-session` before `exec sway`

### Test

1. New home / delete `welcomed` → login → welcome once.  
2. Dismiss → flag set → logout/login → no welcome.  
3. `etheris welcome` reopens.  
4. Kill foot before Enter → flag **not** set → shows again next login.

---

## 4. Window management (high priority)

### Sway reality check

Current skel `~/.config/sway/config`:

- `default_border pixel 2` → **no SSD titlebar**, hence **no close/max buttons** on server decorations.  
- Close: **`Super+Shift+Q`** → `kill` only.  
- **No** `Alt+F4`, **No** `Super+Q`, **No** `Alt+Tab`, **No** `Super+H`.  
- Workspaces: Super+1–4 only (not 1–9).  
- Focus: colored pixel borders (`client.focused` accent) — easy to miss vs titlebars.  
- Floating: `Super+Shift+Space`; resize mode `Super+R`.  
- **Minimize:** Sway does not implement Windows-style minimize; usual pattern is **scratchpad** (`move scratchpad` / `scratchpad show`).

GTK/Qt apps with **CSD** (client-side decorations) still have their own close buttons; many Wayland/TUI apps do not.

Docs (`docs/KEYBOARD.md`) match config (Shift+Q) but users expect Alt+F4.

### Root causes

| Expectation | Actual |
|-------------|--------|
| Alt+F4 closes | Unbound |
| Super+Q closes | Unbound (Hypr sample uses Q; Sway default does not) |
| Titlebar close | Disabled by pixel borders |
| Alt+Tab | Unbound (needs custom binding or helper e.g. swayr — not packaged) |
| Super+H minimize | Unbound; no true minimize |

### Proposed fixes

| Fix | Implementation | Approval |
|-----|----------------|----------|
| D1 | `bindsym Alt+F4 kill` | Low — config |
| D2 | `bindsym $mod+q kill` (document; conflicts rare) | Low |
| D3 | Keep `$mod+Shift+q kill` for muscle memory | — |
| D4 | **Option SSD:** `default_border normal` + `titlebar_border_thickness` / buttons if sway build supports layout — **or** keep pixel and rely on keys + CSD | Medium (visual change) |
| D5 | Alt+Tab: bind to workspace/window cycle — e.g. `bindsym Alt+Tab focus next` / `bindsym Alt+Shift+Tab focus prev` (simple) or add **swayr** later | Simple = low; swayr = package approval |
| D6 | “Minimize”: `bindsym $mod+h move scratchpad` + `$mod+Shift+h scratchpad show` (document as hide/restore) | Low — semantics differ from Windows |
| D7 | Super+5–9 workspaces optional | Low |
| D8 | Update `docs/KEYBOARD.md` + welcome text + Super+? cheatsheet later | Low |

### Regressions

- Alt+F4 in apps that use Alt+F4 internally (uncommon on Linux)  
- `focus next` Alt+Tab feels unlike Windows MRU list  
- Normal borders increase chrome / slight RAM — still fine for Light  
- Scratchpad ≠ taskbar minimize; users may think window is “gone”

### Test (QEMU)

Open foot ×2 + pcmanfm → Alt+Tab focus → Alt+F4 closes one → session remains → Super+H scratchpad → restore → floating move/resize → logout/login.

---

## 5. General desktop usability

| Check | Finding | Proposed |
|-------|---------|----------|
| Sensible positions | Tiling by design — can surprise newcomers | Document; optional float for dialogs via `for_window [window_role="pop-up"] floating enable` patterns |
| Move/resize | Floating + resize mode work if discovered | Document Super+R / floating toggle |
| Dialogs on parent | portals/wlr; app-dependent | Avoid killing portals |
| Popups dismiss | Esc in wofi; mako click | OK |
| Focus stuck | Possible after wofi/logout-menu | Ensure wofi exits; fix logout `wofi -p -p` double flag |
| Close ≠ end session | `kill` vs `swaymsg exit` — OK if Alt+F4 is kill only | Never bind Alt+F4 to exit |
| After “minimize” | Scratchpad show key required | Document |
| Logout menu bug | `wofi --dmenu -p -p 'session › '` duplicate `-p`; Files menu calls **thunar** but stack is **pcmanfm** | Fix when touching `etheris` |

---

## 6. Recommended implementation order (after approval)

1. **P0 (reliability):** firstboot/timezone + foot.ini + rebuild (existing verification).  
2. **WM keys (D1–D3, D5 simple, D6, D8)** — high user impact, low architecture risk.  
3. **Welcome C1–C5** — wire once-only correctly.  
4. **Login A1–A3** — greeter copy/noise without replacing greeter.  
5. **Borders D4** — only after key close works.  
6. **Branded greeter / Plymouth / DESIGN V1** — separate approvals.

---

## 7. Test matrix (QEMU/KVM) — record pass/fail when fixing

| # | Step | Pass? |
|---|------|-------|
| 1 | Boot ISO | |
| 2 | Reach login | |
| 3 | Log in | |
| 4 | First-login welcome once | |
| 5 | Open several apps | |
| 6 | Switch windows (Alt+Tab) | |
| 7 | Close with Alt+F4 | |
| 8 | Controls / resize | |
| 9 | Logout + login (no second welcome) | |
| 10 | Reboot; welcome flag persists | |

Update this table in `out/VERIFICATION-…` when fixes land.

---

## 8. Approval gate

**Ready to implement on request (small diffs):** D1–D3, D5 (`focus next/prev`), D6 scratchpad, D8 docs, C1–C5 welcome, A1/A3 greeter text, logout-menu wofi typo, foot.ini, firstboot P0.

**Needs explicit architectural approval:** replacing tuigreet; Plymouth; swayr-based MRU Alt+Tab; switching default_border to full titlebars as product default; any new desktop framework.

No significant architectural changes started from this document alone.
