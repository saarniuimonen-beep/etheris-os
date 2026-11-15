# Etheris OS — Branded First-Boot Setup Wizard (OOBE)

**Status: SPIKE IMPLEMENTED (foot TUI) — 2026-11-08**

**Related:** Reboot persistence gates → [`INSTALL-PERSISTENCE.md`](INSTALL-PERSISTENCE.md).

Working code: `etheris-oobe`, session gate in `etheris-session`, installer sets `needed`.  
Verified on installed VM: `out/VERIFICATION-M6-OOBE.md`.  
GTK4/libadwaita UI remains optional follow-up; do not regress the foot spike without a replacement.

This wizard is **separate** from:

| Surface | Role | Spec / code today |
|---------|------|-------------------|
| **Login greeter** | Authenticate → start session | `docs/LOGIN.md`, greetd + tuigreet |
| **First-login welcome** | Short tips after desktop starts (optional) | `etheris-welcome` (foot tip sheet; not OOBE) |
| **Installer** | Disk, bootloader, base packages, initial user | `etheris-installer` |
| **OOBE (this doc)** | Guided post-install first boot of **installed** systems only | *planned* |

---

## Goals

Make the first startup of an **installed** Etheris OS feel like a finished product: branded, guided, keyboard+mouse usable, offline-capable, and backed by normal system services—not a raw Arch firstboot TUI.

## Non-goals

- Replacing greetd / tuigreet / PAM.
- Running on the **live ISO** session.
- Duplicating disk partitioning or package install.
- Mandatory online accounts, telemetry, or network to finish.
- Building a second “settings daemon” when systemd / NM / locale tools already exist.
- Implementing before installer verification.

---

## Current system audit (what already exists)

### Installer (`etheris-installer`) already collects

On install (TUI, root):

- Hostname (default `etheris`)
- Username + password (via `chpasswd` stdin; not logged in heredocs)
- Locale (default `en_US.UTF-8`) → `locale.gen` / `locale.conf`
- Timezone (default `UTC`) → `/etc/localtime`
- Enables NetworkManager, greetd, nftables
- Copies privacy defaults (`/etc/etheris/privacy.conf`)
- Copies skel desktop configs into the new user’s home

**Implication:** After a normal install, **User account** and often **hostname / locale / timezone** are already set. The OOBE must **detect** that and **skip or show review-only** pages—never force a second account.

### Gaps vs a polished OOBE

Installer does **not** currently configure:

- Keyboard layout / `vconsole` / XKB for greetd + Sway consistently  
- Wi-Fi / guided NetworkManager connection  
- Appearance (theme accent / wallpaper beyond skel defaults)  
- Accessibility toggles  
- Branded guided UX (stock `systemd-firstboot` is the opposite of Etheris branding and must stay **masked** on both live and installed images)

### Live vs installed

| Environment | OOBE? | Notes |
|-------------|-------|--------|
| Live ISO | **Never** | Detect archiso / overlay; `etheris-auth-setup` live user only |
| Fresh install, flag unset | **Yes** (once) | After greeter login, before normal desktop shell |
| After successful Finish | **No** | Flag persisted; settings reopen via desktop settings later |
| Recovery / emergency / single-user | **No** | Never block getty or maintenance |

---

## Product experience

### Branding

- Etheris Light visual identity: deep charcoal/navy surfaces, violet/cyan accents, existing logo/mark and wallpapers.
- Consistent type (desktop font family already used by Waybar/foot when valid).
- Subtle, cheap transitions (CSS/GTK or compositor-friendly fades)—never block Apply on animation.
- Progress steps (e.g. dots or labeled step list) + **Back** / **Continue** / **Skip** (where safe) / **Finish**.
- Full keyboard navigation (Tab/arrows/Enter/Esc); visible focus; mouse optional.

### Page set

| Page | Behavior | Skip / conditional |
|------|----------|-------------------|
| **Welcome** | Branding, short intro, UI language for the wizard | Always |
| **Region & language** | Country/region, system language, locale, date/number formats | Pre-fill from installer; allow change |
| **Timezone & clock** | City/region TZ; optional map later; enable `systemd-timesyncd` / chrony as already used; manual set if offline | Pre-fill; DST via zoneinfo |
| **Keyboard** | Layout + variant; typing test; write **both** console and Wayland/XKB paths used by greeter + Sway | Always offer; critical for non-US |
| **Network** | NM Wi-Fi list, Ethernet status, **Continue offline** | Optional; never required |
| **User account** | Username, display name, password×2, wheel/admin | **Only if no normal user exists** (UID≥1000 besides nobody). If installer created user → skip or “Account already set” summary |
| **Device name** | Hostname; validate (`^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$`) | Pre-fill; optional edit |
| **Appearance** | Light / dark / default; accent; wallpaper; apply live via `etheris` theme helpers / skel tools—**no reboot** | Optional Skip |
| **Accessibility** | High contrast, larger text, other supported toggles; document path to reopen in settings | Optional Skip |
| **Privacy** | Explain `/etc/etheris/privacy.conf`; telemetry off; no mandatory account/location; confirm defaults | Informational; defaults stay private |
| **Final review** | Summary; Back to edit; **Apply** transaction; completion → hand off to normal desktop | Always |

---

## Technical design (proposed)

### When it runs

Recommended flow for **installed** systems:

1. greetd / tuigreet authenticates the user (unchanged).  
2. Session command (e.g. `etheris-session`) checks OOBE state.  
3. If OOBE required → start **wizard compositor session** (or full-screen wizard on Sway with locked config) instead of normal desktop.  
4. On Finish → mark complete → `exec` normal `etheris-session` desktop.  
5. If interrupted → keep `state=in_progress`; resume same pages; never mark complete until Apply succeeds.

**Do not** run OOBE as the greeter user or replace tuigreet.

### State machine (persist across reboot)

Suggested files (names flexible at implementation time):

| Path | Purpose | Permissions |
|------|---------|-------------|
| `/var/lib/etheris/oobe/` | System OOBE directory | `root:wheel` mode `2770` (not world-writable) |
| `/var/lib/etheris/oobe/state` | `needed` \| `in_progress` \| `done` | `root:wheel` mode `660` |
| `~/.config/etheris/oobe/draft.conf` | Non-secret draft answers | user-private `600` |
| `~/.config/etheris/oobe/state` | User mirror (`done` wins for session gate) | user-private `600` |
| `/etc/etheris/oobe.conf` | Policy: enable OOBE on install images | root |

Installer sets `needed` on the target root when creating an installed system.  
Live image never sets `needed` (or explicitly sets `disabled`).

Privileged fallback: `etheris-oobe-helper` (pkexec allow-listed) writes system state only.  
Passwords: only via PAM/`chpasswd` at Apply time; **never** written to draft/logs.

### Apply layer (reuse system tools)

| Concern | Mechanism |
|---------|-----------|
| Locale | `locale.conf`, `locale-gen`, existing installer patterns |
| Timezone | `timedatectl set-timezone` / `/etc/localtime` |
| NTP | `timedatectl set-ntp true` (timesyncd already in tree) |
| Hostname | `hostnamectl set-hostname` + `/etc/hosts` 127.0.1.1 line |
| Keyboard | `/etc/vconsole.conf` + Sway/XKB input config under user/`/etc` so **greeter + terminal + desktop** match |
| Network | NetworkManager (`nmcli` / libnm)—no custom Wi-Fi stack |
| User | `useradd` / `chpasswd` / `usermod -aG wheel` only if needed |
| Appearance | Existing `etheris` themes / wallpaper paths under `usr/local/share/etheris` |
| Privacy | Keep defaults in `privacy.conf`; wizard only explains / confirms |
| Accessibility | Settings that map to font scaling / high-contrast theme tokens already used by desktop |

### Transaction / failure rules

- Apply in a defined order; on failure: show error, keep `in_progress`, allow retry; **do not** set `done`.  
- Prefer idempotent commands (`timedatectl`, `hostnamectl`, writing conf files).  
- Partial success: record which steps committed in state file so resume doesn’t blindly re-prompt secrets.  
- Offline: all pages except optional Wi-Fi / online NTP must work; manual time allowed.

### UI stack candidates (choose at implementation approval)

Bias: lightweight, Wayland-native, match Etheris Light.

| Option | Pros | Cons |
|--------|------|------|
| **A. GTK4 + libadwaita (single binary)** | Polished pages, a11y, mouse/keyboard | Extra deps on Light ISO/install |
| **B. Limited Sway + foot/wofi scripts** | Tiny | Hard to brand; poor for maps/Wi-Fi UX |
| **C. Existing toolkit already pulled by desktop** | Reuse | Audit package set first |

**Default recommendation:** Option **A** for installed systems only (not required on minimal live if live never runs OOBE). Confirm RAM impact during implementation spike.

### Relationship to installer (avoid duplication)

- Installer remains source of truth for disk + bootloader + initial user.  
- Longer term: installer can pass a “seed” (`/var/lib/etheris/oobe/seed`) with locale/TZ/hostname already chosen so OOBE opens on Appearance/Keyboard/Network/Privacy/Review.  
- Short term: OOBE detects existing config and skips User / soft-skips Device name.  
- Do **not** reintroduce interactive `systemd-firstboot`; keep it masked and use Etheris OOBE instead on installed systems.

### Settings reopen

After Finish, pages map to normal tools / a thin `etheris-settings` entry points (future):

- Language/region/timezone/keyboard → system settings or documented `localectl` / `timedatectl`  
- Network → NetworkManager applet / `nmtui`/`nmcli`  
- Appearance → `etheris themes`  
- Accessibility / privacy → documented toggles + `privacy.conf`

---

## Testing plan (when implementing)

| Case | Expect |
|------|--------|
| Fresh install in QEMU/KVM | OOBE once after first login |
| Live ISO boot | No OOBE |
| Offline first boot | Finish without network |
| Online first boot | Optional Wi-Fi works; NTP ok |
| Locale/TZ/keyboard | Persist after reboot; greeter matches desktop layout |
| User creation | Only when no user; installer path skips |
| Interrupt (power loss / kill) | Resume `in_progress`; not `done` |
| Resolutions | 1280×800 VM + a higher mode; usable scaling |
| After Finish + reboot | Desktop only; no wizard |

---

## Implementation phases (after approval)

0. **Prerequisites (current priority — not this doc):** clean live boot polish + ISO rebuild; then installer-on-disk verification.  
1. **Spike:** state flag + session gate in `etheris-session` (stub UI).  
2. **Apply backend:** shell/Go/Python helpers calling timedatectl/hostnamectl/nmcli/localectl/chpasswd.  
3. **UI pages** in order; Skip/Back; review + transactional Apply.  
4. **Installer hook:** set `needed` + seed; never enable on live.  
5. **QEMU test matrix** above; document results under `out/`.  

---

## Acceptance criteria (future)

- [ ] Runs only on installed systems, once, until Finish.  
- [ ] Never on live ISO.  
- [ ] Does not replace login greeter or become the welcome tip app.  
- [ ] Keyboard + mouse complete path.  
- [ ] Offline Finish works.  
- [ ] No plaintext passwords in logs/state.  
- [ ] Settings persist across reboot.  
- [ ] Interrupted setup safe; recovery/getty never blocked.  
- [ ] Explicit approval before coding UI.

---

## Immediate priority reminder

Per project direction: **do not interrupt** live-ISO verification / boot polish / Sway confirmation work.  
Next engineering milestone remains **clean cold boot + rebuild**, then **installer verification**.  
This OOBE document is the plan to present for approval **after** those milestones—not an invitation to start coding the wizard now.
