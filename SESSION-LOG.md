# Etheris OS — Session log (continue here)

**Last updated:** 2026-11-10T16:30+02:00
**Version:** 0.1.0-alpha  
**Host:** Fedora (builds via Podman; tests via `qemu:///session` only — no host package installs / no physical disks without approval)

Use this file to resume. Detail lives in the linked docs; this is the handoff.

---

## Status snapshot


**2026-11-10:** Rename Stage C **PASS** · CPU/GPU Performance Manager + GPU Manager in tree · official website scaffold started · **no public GitHub/visibility/domain changes**.


**Tonight (2026-11-09 ~22:00–23:20): trademark-safe rename → Etheris, gaming/Defaults fixes, lean browser warm path, ISO re-bake.**  
**Earlier today:** large Neo-Aero shell + apps pass + live VM  
**Prior (2026-11-08):** M0–M6 · Neo-Aero P0 · power menu · Design Phase 2 · Stage 1 tokens · WP-S1–S5  

**Checkpoint:** Fresh ISO baked with branding + gaming/Defaults + browser RAM/warm-start; VM shut off  
**ADR:** `docs/ADR-NEO-AERO-DESKTOP.md`  
**Decorations architecture:** `docs/WINDOW-DECORATIONS.md`  
**ISO (latest bake, 23:17):** `out/etheris-2026.11.09-x86_64.iso` (~2.1 GiB)  
**SHA256:** `6fb625b048bdbb9f21d404d11955dc5183af84ce4d654df2b8f654863662b174`  
**Prior same-day bake:** SHA `84779b4c…` (superseded; branding/gaming/browser not fully in that image)  
**Prior ISO (WP-S5):** `out/etheris-2026.11.08-x86_64.iso` · `3ce76275c7978edae208e0cd0697ae1b732dcb2b7571f7db9e4d6149773d14d0`

**Honesty notes still true:**
- Transparency / glass styling is in tree; **true background blur is off** (Sway cannot do frosted blur)
- 3D timezone globe needs WebKit/WebGL; VM often falls back to Neo-Aero GTK city search UI
- Extra browsers install on demand (not all baked into ISO)
- Virgin Firefox cold start cannot hit &lt;1 s; Super+B &lt;1 s needs scratchpad **warm preload**

**Next:**
1. Inject/bake Performance Manager (`out/perf-gpu-apply.tgz`) and VM-verify profiles + Settings/CC sync
2. Full-system integration audit report (`docs/INTEGRATION-REPORT.md`) — honest untested marks
3. Finish official website (`website/`) locally; **owner approval** before public deploy
4. Git init + GitHub prep (templates/docs) — **do not make repos public without approval**
5. WP-S6 idle RSS · optional Quickshell · decorations soak

---

## Where things live

| Path | Purpose |
|------|---------|
| `~/etheris-os/` | Project root |
| `profile/etheris/` | Archiso profile + airootfs |
| `build.sh` | Podman + mkarchiso (**multilib**; pacman cache in `work/pacman-cache`) |
| `out/etheris-2026.11.09-x86_64.iso` | Latest ISO — panel dock, gaming stack, Rofi launcher, wallpapers, transfers, ReGreet, Files Neo-Aero |
| `out/SHA256SUMS` | ISO checksums |
| `docs/GAMING.md` · `docs/TRANSFERS.md` · `docs/LOGIN.md` · `docs/KEYBOARD.md` | Updated today |
| `design/phase-2/` | Neo-Aero blueprint + previews (not OS) |
| `MASTER-CHECKLIST.md` | Phase status |
| `SESSION-LOG.md` | **This handoff** |

### VM (libvirt user session)

```text
Connection: qemu:///session
Domain:     etheris-os
State:      shut off (as of log update)
RAM:        ~3584 MiB (3670016 KiB) — raised for Firefox / desktop; was 2560 then 4096 earlier
Disk:       ~/.local/share/libvirt/images/etheris-os.qcow2
Inject:     ~/.local/share/libvirt/images/etheris-inject.img  (optional; latest ISO should not need injects)
ISO:        out/etheris-2026.11.09-x86_64.iso  (copy/attach for CDROM boot)
Prior E2E:  ~/.local/share/libvirt/images/etheris-e2e-stage1.qcow2  (demo/demo)
WP-S5 live: ~/.local/share/libvirt/images/etheris-wps5-live.qcow2
```

Live login: `etheris` / `etheris`  
Installed E2E login: `demo` / `demo`

**Try on live desktop:**
- Super+D / Super+Space · Rofi Etheris launcher (Wide/Slim)
- Super+A Control Center · Super+N notifications
- Super+W overview · Super+, Settings · Super+Shift+A window menu
- Super+B browser · Super+Return terminal · Super+I AI agent
- Super+Shift+E power menu · `etheris ram`
- Settings → Shell → Panel position (Top / Bottom dock) · Launcher style
- `etheris-wallpaper` · `etheris-transfer` · `etheris-browsers` · `etheris-defaults` · `etheris-timezone`

---

## What we accomplished — 2026-11-09 evening (branding · gaming · browser · re-bake)

### E1. Trademark-safe rename → **Etheris OS**

Iterative clearance (rejected Ethereal / Eclipse / Galaxy / Elixir / Ether / Flow / Endor / Evo / Entreal / Etherglow / Etherix). Chose **Etheris**.

| Item | Detail |
|------|--------|
| Tree | Project `etheris-os`; airootfs bins/docs/design renamed from ethereal→etherglow→etherix→etheris |
| Live brand | `/etc/issue`, greeter, wallpapers paths, share tree under `/usr/local/share/etheris` |
| Libvirt | Domain/XML/images/NVRAM aligned to `etheris-os` |
| Constraint | Free/OSS + website OK; coined name; no anti-cheat bypass tooling |

### E2. Steam / gaming / anti-cheat + Defaults installs

| Item | Detail |
|------|--------|
| Policy | Legit Steam Play + Valve Proton / EAC / BattlEye **runtimes only** — never bypasses |
| Scripts | `etheris-gaming-setup` (steamplay / runtimes / status); `etheris-steam` (safer CEF, runtimes, xdg-mime) |
| Packages | Extra lib32 deps (`freetype2` / `curl` / `dbus` / `fontconfig`); dropped vanished `lib32-openal` again |
| Defaults fix | GUI pacman elevation: `pkexec` → `sudo -n` → foot; `etheris-defaults-ui` AlertDialog errors; AUR lag=0 |
| Apply pack | `out/gaming-defaults-apply.tgz` (live inject if needed) |
| Docs | `docs/GAMING.md` synced |

### E3. Browser lean RAM + &lt;1 s open (warm path)

| Item | Detail |
|------|--------|
| Goal | No wasteful browser RAM; Super+B under ~1 s after login |
| Reality | True virgin Firefox cold start is multi-second; **warm scratchpad preload** is the supported path |
| Policies | `/etc/firefox/policies/policies.json` — `about:blank` start, 2 content processes, no onboarding/telemetry fluff, capped memory caches |
| Launcher | `etheris-browser` — earlier/reliable preload, race wait, `--status`, `browser_preload=on\|off`, skip if MemAvailable &lt; ~640 MiB |
| Session | Preload ~0.35 s after login; timezone/guide deferred to ~2.5 s / auto-tz ~12 s so preload gets CPU |
| Settings | `browser_preload=on`, `default_browser=firefox` in skel + live user settings |
| Perf doc | `design/phase-2/PERFORMANCE.md` — idle ~500 MiB **before** warm Firefox (~300–450 MiB when preloaded) |
| Apply pack | `out/browser-ram-apply.tgz` · bench helper `out/bench-browser.sh` |
| Existing | `99-etheris-ram.conf` · `99-etheris-snappy.conf` · zram · `MALLOC_ARENA_MAX=2` unchanged |

### E4. ISO re-bake (23:17)

| Item | Result |
|------|--------|
| Disk | Host free space recovered (~119 GiB avail) after earlier ~97% full block |
| Fail #1 | `rm` of root-owned `work/mkarchiso` needed `sudo rm -rf` |
| Fail #2 | `lib32-openal` **target not found** (Arch dropped it) — removed from `packages.x86_64`, `gaming-packages.list`, installer |
| `./build.sh` | **PASS** → `out/etheris-2026.11.09-x86_64.iso` (~2.1 GiB) |
| SHA256 | `6fb625b048bdbb9f21d404d11955dc5183af84ce4d654df2b8f654863662b174` |
| Verified in airootfs | lean Firefox policies · `sleep 0.35; etheris-browser --preload` · `browser_preload` in etheris-browser |

---

## What we accomplished — 2026-11-09 earlier (Neo-Aero shell + apps)

### 1. Panel placement — top floating vs bottom dock

| Item | Detail |
|------|--------|
| Setting | Shell → **Panel position**: Top panel (`floating`) / Bottom dock (`dock`) |
| Top | Existing Neo-Aero Waybar: workspaces, title, winctl, status |
| Bottom | Centered island dock: launcher + Files/Term/Set pins + workspaces + clock + status; taller/rounder; no title/winctl chrome |
| Wiring | `etheris-shell-layout`, Settings, Control Center, waybar style template |

### 2. Gaming stack (Steam / Wine / Proton essentials)

Steam was already on the live ISO; today made it default on disk installs too and expanded the legit runtime stack (**no anti-cheat bypasses**).

| Item | Detail |
|------|--------|
| Install default | Steam + gaming packages on disk installs; lean opt-out `ETHERIS_INSTALL_GAMING=0` |
| Added packages | `steam-devices`, `lib32-pipewire`, `lib32-alsa-plugins`, `protontricks`, `umu-launcher` |
| Wine / Proton | `wine`, `wine-mono`, `wine-gecko`, `winetricks`, `zenity`, `cabextract`, `vkd3d` / `lib32-vkd3d`, common `lib32-*` game libs, GStreamer set |
| Sysctl | `vm.max_map_count` raised for Proton/Wine (`99-etheris-gaming.conf`) |
| Groups | Users get `gamemode` group |
| Docs | `docs/GAMING.md` |
| Build note | Dropped `lib32-openal` — Arch no longer ships it; Steam/Wine still build |

### 3. Etheris application launcher (Rofi Kickoff-style)

| Item | Detail |
|------|--------|
| Engine | **Rofi** (not wofi) for main launcher |
| UX | Opens on **Pinned**; tabs: Pinned · Apps · Run · Windows |
| Theme | Neo-Aero glass via `etheris-theme-apply`; prompt branded **Etheris**; Papirus icons |
| Branding | Panel wordmark **Etheris**; wofi prompts capitalized consistently |
| Style option | Settings → Shell → Application launcher: **Wide** (680px, default) / **Slim** (380px); also Control Center toggle |
| Files | `etheris-launcher` · `share/etheris/rofi/{etheris,etheris-slim}.rasi` · `favorites.mode` |

### 4. Etheris Wallpapers (GTK4 switcher + light file manager)

| Item | Detail |
|------|--------|
| App | `etheris-wallpaper` |
| Sources | My Wallpapers · Pictures · Etheris Library · Browse files |
| Formats | JPG/PNG/WebP/GIF/BMP/SVG/TIFF/JXL/AVIF thumbnails (cached, async) |
| Import | Add files, import folder, drag-and-drop |
| Nav | Up / path bar folder browsing |
| Apply | Fixed so wallpaper actually refreshes on select |

### 5. File transfers

| Item | Detail |
|------|--------|
| Hub | **Etheris Transfers** — `etheris-transfer` |
| LAN | Warpinator |
| Bluetooth | Blueman + `bluez-obex` (OBEX on login) |
| Shares | `gvfs-smb`, `gvfs-nfs`, existing MTP |
| Firewall | Warpinator ports + mDNS; Avahi enabled |
| Docs | `docs/TRANSFERS.md` |

### 6. Etheris Files Places + Neo-Aero GTK look

| Item | Detail |
|------|--------|
| Standard dirs | Wired reliable `xdg-user-dirs` creation on login |
| Places | Home, Desktop, Documents, Downloads, Music, Pictures, Videos, Public, Templates |
| Extra Places | **Wallpapers**, **Screenshots** |
| Look | Glass toolbars/path bar, rounded Places, selection pads, CSD chrome matching Atmosphere |
| Defaults | Larger icons/thumbnails, icon view, ~980×620 |

### 7. Custom login (ReGreet)

| Item | Detail |
|------|--------|
| Greeter | Switched tuigreet → **ReGreet** (GTK4) on minimal Sway seat |
| Style | Glass login card, Etheris wallpaper, clock/greeting (`/etc/greetd/regreet.css`) |
| Auth | Still greetd + PAM |
| Fallback | `etheris-greeter-tui` |
| Docs | `docs/LOGIN.md` |

### 8. ISO bake + VM verification

| Item | Result |
|------|--------|
| `./build.sh` | **PASS** → `out/etheris-2026.11.09-x86_64.iso` |
| SHA256 | `84779b4c00f771e6a9a0edb4aa318864fb02c415ab9f9477fb203289e623f4d2` |
| VM | CDROM boot of 2026.11.09 ISO; virt-viewer session |
| Evidence | `out/verification-neo-aero-vm-login.png` · `out/verification-neo-aero-vm-desktop.png` |
| Glass honesty | Translucent Neo-Aero surfaces yes; **true blur no** (`blur=off`) |

### 9. Browser warm-start (Firefox felt ~5s)

| Item | Detail |
|------|--------|
| Cause | Cold Firefox + RAM-starved guest (~2.5 GiB thrashing swap) |
| Fix | `etheris-browser` warm wrapper; session preload ~1s after login; first-run policy strip |
| VM RAM | Raised toward ~3.5 GiB |
| Bind | **Super+B** |
| Result | Warm open ~**230 ms** in live session (vs ~5 s cold) |

### 10. Etheris Browsers (on-demand installs)

Not all browsers baked into ISO (size/RAM). Manager installs on demand:

| Source | Browsers |
|--------|----------|
| Arch repos | Chromium, Vivaldi, LibreWolf, GNOME Web, Falkon, qutebrowser |
| AUR (builds on machine) | Chrome, Edge, Zen, others as cataloged |

| Item | Detail |
|------|--------|
| Apps | `etheris-browsers` / `etheris-browsers-ui` |
| Entry | Settings → Browsers, Control Center, launcher |
| VM note | Forced Cairo when GTK UI crashed on virtio software renderer; CLI fallback kept |

### 11. Etheris Defaults (browser / terminal / AI agent)

| Item | Detail |
|------|--------|
| UI | Polished floating GTK defaults app — rail + accent hero + glass cards |
| Tabs | **Browser** (Super+B) · **Terminal** (Super+Return) · **AI Agent** (Super+I) |
| Agents | ChatGPT / Claude / Gemini / Copilot / Ollama / … via `etheris-agent` |
| Launcher | Pinned as “Etheris Defaults” |
| Also | Settings → Defaults · Control Center |

### 12. First-login timezone — city-precise + travel auto

| Item | Detail |
|------|--------|
| App | `etheris-timezone` — OOBE / first-login city-precise picker |
| Globe | Three.js WebGL globe + city search (`share/etheris/timezone/`) behind WebKit |
| VM reality | WebKit/WebGL unreliable on virtio → Neo-Aero **GTK search UI** with hub cities pinned |
| Travel | `etheris-timezone-auto` — IP/geolocation country change → set timezone + notify (on by default; toggle in picker) |
| Live overlays | `out/timezone-apply.tgz` · `out/tz-polish-apply.tgz` (and related injects) |

### Post-bake live injects

**Latest 23:17 ISO** should include branding + gaming/Defaults + lean browser warm path from airootfs. Older live guests can still use:

- `out/browser-ram-apply.tgz` · `out/gaming-defaults-apply.tgz`
- Older: `out/browser-fast-apply` / `browser-fast.tgz` · `out/browsers-apply.tgz` · `out/defaults-apply.tgz`
- `out/ui-launcher-apply.tgz` · `out/timezone-apply.tgz` · `out/tz-polish-apply.tgz`

---

## What we accomplished earlier (2026-11-08 night → SESSION-LOG v1)

Kept for continuity; details were verified on WP-S5 ISO.

### A. Steam + snappy live (pre–WP-S5)

**Root cause:** archiso overlay `cow_spacesize` = **256 MiB** → Steam needs ≥250 MiB free.

| Fix | Detail |
|-----|--------|
| Live overlay | `kernel_params=('cow_spacesize=2G')` in `profiledef.sh` |
| Safety remount | `etheris-live-ready.service` remounts cowspace to 2G if still &lt;1 GiB |
| Launcher | `etheris-steam` — free-space + DNS checks, CEF `-no-cef-sandbox`, logs under `~/.local/state/etheris/steam.log` |
| Zram | `zram-generator` + config; guest RAM raised for Steam |

**Snappy defaults:** `animations=off`; theme-apply session stamp; PNG wallpapers preferred; deferred OOBE/guide; waybar 15–30 s; `99-etheris-snappy.conf`.

### B. Neo-Aero WP-S5

Settings (`etheris-settings` · Super+,), workspace overview (Super+W), optional widgets (`widgets=off|clock`), decorations honesty doc, shell-layout wiring. Verified on disposable live VM — report `out/VERIFICATION-WP-S5-SETTINGS.md`.

---

## Critical technical notes

- OOBE must **never** call interactive `sudo` (breaks foot TUI). Use `sudo -n` or user-writable paths.
- State dir: installer `chmod 777` / state `chmod 666` so first login can mark `done`.
- Arch **nvidia 590+** dropped Pascal → AUR `nvidia-580xx-*` only.
- `build.sh` enables `[multilib]`; Steam → lsb-release hook for branding.
- **Sway = compositor**; Quickshell (if ever) = shell only. Keep Sway fallback. **No dual panel.**
- Prefer **PNG** wallpapers at runtime (SVG source OK); glycin-svg was ~30 MiB RSS.
- Live Steam needs `cow_spacesize=2G` + preferably ≥3.5–4 GiB guest RAM / zram.
- Cleaning `work/mkarchiso` after rootful/rootless podman may need:  
  `podman run --rm -v ~/etheris-os/work:/work:Z alpine rm -rf /work/mkarchiso`
- Keep ≥20 GiB free on `/home` before `./build.sh` (SquashFS + overlay peak).
- Power menu: transient GTK4; virtio-gpu may log Vulkan noise (harmless). `ETHERIS_POWER_BLUR=0` for solid backdrop.
- Do **not** claim every app has identical window chrome (CSD vs SSD honesty).
- Glass ≠ blur: translucent surfaces ship; true compositor blur does not on stock Sway.
- Anti-cheat: ship Proton/Wine/runtime deps only — **never** bypass tools.
- WebKitGTK on virtio software GL is flaky; keep GTK fallbacks for timezone / heavy WebKit UIs.
- Firefox cold start cannot hit &lt;1 s in this VM; warm-preload + reuse is the practical path.

---

## Suggested next session

1. **Boot latest ISO** — confirm Etheris branding, Defaults installs (pkexec), `etheris-gaming-setup status`, Super+B warm &lt;1 s (`etheris-browser --status` / `out/bench-browser.sh`).
2. Owner soak of ReGreet + dock + Rofi launcher + Files Places on clean live boot.
3. **WP-S6** performance: idle RSS/CPU with only Waybar/mako/sway (**before** browser preload).
4. Optional: Quickshell Path B behind `shell=quickshell` — must pass ADR gates.
5. Optional: richer GTK Control Center sheet without dropping wofi fallback.
6. Soak decorations; only then expand WP-S4 motion (honour reduced-motion / off).

### Quick resume commands

```bash
cd ~/etheris-os
df -h .
cat out/SHA256SUMS
# attach latest ISO to CDROM if needed, then:
virsh -c qemu:///session start etheris-os
virt-viewer --connect qemu:///session --attach etheris-os &
# live: etheris / etheris
# Super+D / Super+Space → Etheris launcher
# Super+W overview · Super+, Settings · Super+A CC
# Super+B browser · etheris-browser --status · etheris ram
# etheris-defaults · etheris-gaming-setup status · etheris-steam
# optional live apply: tar xf out/browser-ram-apply.tgz && ./browser-ram-apply/apply.sh
```

---

## Key code touchpoints

| Area | Files |
|------|--------|
| Panel top/dock | `etheris-shell-layout` · waybar config/style · Settings Shell |
| Rofi launcher | `etheris-launcher` · `share/etheris/rofi/*` |
| Wallpapers | `etheris-wallpaper` |
| Transfers | `etheris-transfer` · Warpinator / Blueman / gvfs |
| Files Neo-Aero | GTK templates · PCManFM skel · xdg-user-dirs / bookmarks |
| Login | `/etc/greetd/*` · `regreet.css` · `etheris-greeter-tui` |
| Browser warm / lean | `etheris-browser` · `/etc/firefox/policies/policies.json` · session preload · `browser_preload` |
| Browsers manager | `etheris-browsers` · `etheris-browsers-ui` · `browsers/catalog.json` |
| Defaults | `etheris-defaults` · `etheris-defaults-ui` · `defaults/catalog.json` (pkexec elevation) |
| AI agent | `etheris-agent` |
| Timezone | `etheris-timezone` · `etheris-timezone-auto` · `share/etheris/timezone/` |
| Settings / CC | `etheris-settings` · `etheris-control-center` |
| Gaming | `packages.x86_64` · `etheris-steam` · `etheris-gaming-setup` · `99-etheris-gaming.conf` |
| Overview / widgets | `etheris-workspace-overview` · `etheris-widgets` · `etheris-widget-clock` |
| Window controls | `etheris-winctl` · Waybar `custom/winctl` |
| Motion (WP-S4) | `etheris-motion` (only if animations=on) |
| Theme apply | `etheris-theme-apply` (session stamp) |
| Tokens / GTK CSD | `share/etheris/design/templates/gtk.css.tmpl` |
| Overlay mutex | `etheris-overlay` |
| Power menu | `etheris-power-menu` · `etheris logout-menu` |
| Live cow | `profiledef.sh` `kernel_params` · `etheris-live-ready.service` |
| Zram | `zram-generator` · `/etc/systemd/zram-generator.conf` |
| Session / OOBE | `etheris-session` · `etheris-oobe` |
| Installer (M5) | `etheris-installer` |

---

## What we accomplished — 2026-11-10 (rename verify · Performance Manager · release prep start)

### Rename Stage C

- Audit: only historical Ethereal/Etherglow/Etherix mentions in `SESSION-LOG.md`
- User-facing tree consistently **Etheris** (os-release, ReGreet, boot menus, ISO name, apps)
- Report: `docs/RENAME-VERIFICATION.md` — **PASS**
- Host leftover libvirt filenames `ethereal-*` noted (outside repo)

### Stage D — Performance Manager + GPU Manager

| Piece | Path |
|-------|------|
| CLI engine | `usr/local/bin/etheris-perf` |
| GPU CLI | `usr/local/bin/etheris-gpu` |
| GTK Performance Manager | `usr/local/bin/etheris-performance` |
| GTK GPU Manager | `usr/local/bin/etheris-gpu-manager` |
| Settings page | Settings → Performance |
| Quick Settings | Control Center → Performance profile |
| Boot apply | `etheris-perf.service` |
| Docs | `docs/PERFORMANCE-MANAGER.md` |
| Live apply pack | `out/perf-gpu-apply.tgz` |

Profiles: `maximum` · `balanced` · `quiet` · `powersave` (safe interfaces only).

Host smoke: `etheris-perf capabilities|monitor` ran on Fedora (intel_pstate). Guest ISO not yet rebaked with these binaries.

### Public release / website

- In progress: static site under `website/` (local only)
- No git remote / visibility / DNS / public deploy without owner approval
