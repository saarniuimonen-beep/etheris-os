# Etheris OS — Master Development Checklist (status)

Version: **0.1.0-alpha**  
Updated: 2026-11-08  

Roadmap: M0–M6 **Passed** (VM). See `docs/MILESTONE-0-AUDIT.md`, `out/VERIFICATION-20261108.md`, `out/VERIFICATION-M5-INSTALLER.md`, `out/VERIFICATION-M6-OOBE.md`.  
Next: ISO rebuild to bake M6 OOBE (+ already-baked M5 installer), then M7.

Legend: `[x]` done & present in tree · `[~]` partial · `[ ]` not done · `[!]` cannot claim until tested on ISO/VM

## PHASE 1 — Project foundation

- [x] Inspect the existing repository before making changes
- [x] Establish a clean project structure (`profile/`, `build.sh`, `docs/`, `scripts/`)
- [x] Use Arch Linux as the base
- [x] Use systemd
- [x] Use pacman as the package manager
- [x] Maintain compatibility with official Arch repositories (via Arch Linux Archive lag)
- [~] Keep optional AUR support (helper + 30-day lag policy; not enabled by default)
- [x] Create a consistent naming and versioning scheme (`VERSION`, os-release)
- [x] Document the build process (`README.md`)
- [~] Make ISO builds reproducible (`SOURCE_DATE_EPOCH` in build; full bit-identical ISO `[!]`)

## PHASE 2 — Lightweight desktop (Sway)

- [x] Sway (default compositor) — *switched from labwc per checklist*
- [x] Waybar
- [x] Foot
- [x] Wofi
- [x] Mako
- [x] PCManFM
- [x] PipeWire
- [x] NetworkManager
- [x] greetd + tuigreet
- [x] swaylock / swayidle / grim / slurp / wl-clipboard
- [x] XDG desktop portals (`xdg-desktop-portal-wlr`)
- [~] Ensure all components work together correctly — **live login+Sway verified in QEMU** (`out/VERIFICATION-LIVE-DESKTOP.md`); foot.ini + firstboot polish still open

## PHASE 3 — Etheris visual identity

- [~] Logo (text/SVG mark present; full brand kit later)
- [x] Color palette (charcoal / violet / cyan) — expand to full token system per `docs/DESIGN.md`
- [x] Custom wallpaper(s)
- [~] Waybar / foot / launcher styling (present; not yet one design system — foot.ini broken on 1.28)
- [~] Custom login (tuigreet branding today; full Etheris login UX = **future milestone**, see `docs/LOGIN.md`)
- [~] Boot branding (syslinux/EFI titles)
- [~] Light and dark themes (`.theme` packs exist; unified apply → CSS/GTK pending DESIGN V1)
- [x] Themes easy to modify (`etheris themes`)
- [x] Visual polish plan: `docs/DESIGN.md` (**proposal only**)
- [x] Usability investigation (login/startup/welcome/WM): `docs/USABILITY-FIXES.md` (**awaiting fix approval**)

## PHASE 4 — Customization

- [x] Configs in `~/.config` (sway, waybar, …)
- [x] User-editable Sway config
- [x] Multiple color themes / wallpapers
- [~] Panel / shortcut / optional components docs
- [x] Centralized `~/.config/etheris/`

## PHASE 5 — Bootable USB ISO

- [x] Custom Archiso profile
- [~] Etheris branding
- [x] UEFI + BIOS bootmodes in profile
- [x] Live environment overlay
- [~] Troubleshooting utilities
- [~] Etheris installer (in progress)
- [x] Live boots without install — verified in QEMU (login + Sway)
- [x] Hybrid ISO generated — `out/etheris-2026.11.07-x86_64.iso` (verified build + checksum)
- [x] USB write docs in README
- [x] QEMU live boot — greeter + Sway verified (`out/VERIFICATION-LIVE-DESKTOP.md`)
- [x] Clean cold boot without systemd-firstboot — verified on rebuilt ISO (`out/VERIFICATION-USABILITY.md`)
- [x] foot.ini valid for foot 1.28 — fixed (`colors-dark`) + verified
- [x] WM keys Alt+F4 / Super+Q / Alt+Tab / Super+H scratchpad — verified
- [x] First-login welcome once + `etheris welcome` reopen — verified
- [x] First-login guide (5-step) + Shortcut Center (`Super+/`) + startup sound — verified (`out/VERIFICATION-GUIDE-SHORTCUTS-SOUND.md`)

## PHASE 6 — Custom installer

- [~] `etheris-installer` started (UEFI + ext4, safety prompts)
- [ ] Full checklist items (partition, locale, …) complete end-to-end
- [!] Installer tested in VM

## PHASE 7 — Performance

- [x] Minimize services / light session design
- [!] Measure idle RAM / boot time — **no invented numbers; measure after boot**

## PHASE 8 — Testing

- [x] Build ISO · QEMU live login · Sway · keyboard basics — **PASS** (`out/VERIFICATION-LIVE-DESKTOP.md`)
- [ ] Rebuild after firstboot/foot fixes · re-smoke cold boot
- [ ] Installer on virtual disk · audio · fuller net/pacman — **not run yet**

## PHASE 9 — Documentation and release

- [~] Partial docs · no release checksums yet

## Update channels (lightweight — no custom mirror yet)

- [x] Stable channel default (**14-day** Arch Archive lag; configurable → 30)
- [x] RC channel (7-day lag)
- [x] Edge channel (official Arch, warnings)
- [x] Previous snapshot recovery (`etheris-update recover`)
- [x] Security coherent snapshot path (`etheris-update security`)
- [x] Optional AUR lag gate (`etheris-aur`)
- [ ] Promote Stable only after ISO/QEMU/desktop tests (Phase 8)
- [ ] Custom Etheris package mirrors — **blocked until ISO+installer work**
- [ ] 4-year support promises — **deferred** (`docs/RELEASE-POLICY.md`)

## PHASE 19 — Security and privacy (profile defaults)

- [x] No telemetry / analytics / crash upload by default (`/etc/etheris/privacy.conf`)
- [x] nftables firewall config + enabled by default
- [x] SSH not enabled by default (masked; openssh removed from ISO package set)
- [x] Pacman `SigLevel = Required` retained
- [x] ISO SHA-256 checksums produced by `build.sh`
- [x] AUR optional + warnings (`etheris-aur`)
- [x] Installed sudo requires password; live ISO documents NOPASSWD limitation
- [x] Installer avoids logging passwords into heredocs
- [x] `etheris-security status|firewall|audit`
- [x] Docs: `docs/SECURITY.md` (limitations stated; no “completely secure” claim)
- [ ] LUKS opt-in installer UI (deferred)
- [ ] Secure Boot (deferred)
- [ ] Full release security audit on final public ISO (before public release)

## PHASE 20 — Immutable core (planning)

- [x] Architecture plan: `docs/IMMUTABLE.md`
- [x] `MODE=mutable-classic` flag (`/etc/etheris/system-mode.conf`)
- [x] Installer Btrfs layout `@` / `@home` / `@var_log` (mutable, future-friendly)
- [x] `etheris-immutable status` (reports not active)
- [ ] Read-only OS base / A/B atomic updates — **not implemented**
- [ ] Rollback / failed-deployment recovery — **not implemented**
- [ ] Developer mode — **not implemented**
- [ ] QEMU immutability verification suite — **blocked until installable+update stack exists**

## PHASE 21 — Custom login screen (planning)

- [x] Spec: `docs/LOGIN.md` (requirements, non-goals, gate)
- [x] Baseline kept: greetd + tuigreet + PAM + `etheris-auth-setup` (no replacement without approval)
- [ ] Prerequisites: live ISO graphical login + Sway session verified (Phase 5/8)
- [ ] Choose approach (themed tuigreet → gtkgreet/regreet → custom; see LOGIN.md)
- [ ] Etheris Light branding, clock/date, session picker, power controls, keyboard/a11y
- [ ] Confirm no plaintext password storage/logging
- [ ] Implementation — **blocked until approval + prerequisites**

## PHASE 22 — First-boot setup wizard / OOBE

- [x] Design plan: `docs/OOBE.md` (pages, live vs install, apply layer, gates)
- [x] Audit: installer already sets user/hostname/locale/TZ; `etheris-welcome` ≠ OOBE; login stays separate
- [x] Prerequisites: M5 installer E2E passed; session gate + state machine in tree
- [x] Spike UI: foot TUI (`etheris-oobe`) — keyboard/network/appearance/privacy/review
- [x] Apply helpers: keyboard → Sway XKB + optional vconsole; appearance → `etheris theme`
- [x] Installer hook sets `needed`; live never runs OOBE
- [x] QEMU installed-path verification — **PASS** (`out/VERIFICATION-M6-OOBE.md`)
- [ ] GTK4 / libadwaita branded UI (optional upgrade from foot TUI)
- [ ] ISO bake + fresh-install E2E without inject
- [ ] Interrupt / offline edge-case matrix (partial)

## PHASE 23 — Unified visual design (planning)

- [x] Proposal: `docs/DESIGN.md` (tokens, launcher plan, milestones V1–V6)
- [x] Audit: Sway + Waybar + wofi + mako + GTK Adwaita/Papirus; thin `.theme` files; no shared token pipeline yet
- [ ] P0: functional desktop + foot.ini + clean boot (do not start V1 early)
- [ ] V1: design tokens + `etheris theme` apply → waybar/wofi/mako/sway/gtk/foot
- [ ] V2: launcher polish (theme wofi first; replace only if required)
- [ ] V3–V6: panel/OSD/logout, GTK dialogs, align LOGIN/OOBE/welcome, full-session QA
- [ ] Implementation — **blocked until live/login/Sway + boot polish milestones allow**

## PHASE 24 — CPU / GPU / Gaming (foundation)

- [x] Inspect repo vs hardware/gaming requirements; gap doc in `out/MILESTONE-HARDWARE-GAMING.md`
- [x] PCI ID databases + `etheris-hw` / `etheris-drivers` / `etheris-cpu-setup`
- [x] Enable `[multilib]`; Steam + lib32 Vulkan/Mesa + GameMode/MangoHud/Gamescope on package set
- [x] Intel/AMD open stack packages expanded (media + tools)
- [x] NVIDIA Pascal → 580xx AUR guide + pin/hook (no silent nvidia-open)
- [x] NVIDIA Turing+ recommend/apply path (`nvidia-open`)
- [x] Installer: gaming pkgs, microcode initrd, driver recommend pass
- [x] Docs: `HARDWARE.md`, `GAMING.md`, `DRIVER-RECOVERY.md`, `HARDWARE-TEST-MATRIX.md`
- [x] ISO rebuild with gaming stack — `etheris-2026.11.08-x86_64.iso`
- [!] QEMU live: Steam launches (not GPU proof)
- [!] Physical Pascal / Turing+ / AMD RX / Intel Arc matrix rows
- [!] Hybrid graphics / suspend after gaming
- [!] Proton game on real hardware
