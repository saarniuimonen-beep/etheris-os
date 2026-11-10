# Verification — ISO rebuild + clean-install E2E (Stage 1 baked)

**Date:** 2026-11-08  
**Host:** Fedora · guest only via `qemu:///session`  
**Scope:** Rebuild ISO from current tree (Stage 1 token bridge included); disposable live + clean install; prove Stage 1 in ISO; no Stage 2; no inject; no physical disks; no Fedora host package/config changes.  
**Evidence:** `out/verification-e2e-stage1/` · squashfs extract `out/verification-stage1-iso/`

---

## 1. ISO rebuild

| Item | Result |
|------|--------|
| Build command | `./build.sh` (Podman archiso; `/work` bind-mounted under `work/mkarchiso`) |
| Outcome | **PASS** (`Build finished`, exit 0) |
| ISO path | `/home/saarni/ethereal-os/out/ethereal-2026.11.08-x86_64.iso` |
| Size | **1.8 GiB** (`1854160896` bytes) |
| SHA256 | `fc4e013eb807c41eecc939b254938b9041935ba70bd793bc85bbcc2c5d21ae09` (`out/SHA256SUMS` verified) |
| Build log | `out/build-20261108T190106Z.log` |

**Build notes (non-fatal):** initcpio PXE hook warnings (`ipconfig` / `nbd-client` / `nfsmount` missing); `umount: …/dev: target is busy` after pacstrap; firmware “Possibly missing” warnings. ISO still produced.

---

## 2. Stage 1 tokens in built ISO (squashfs)

Extracted from `airootfs.sfs` (not injected):

| Check | Result |
|-------|--------|
| `ethereal.tokens.json` present + parseable | **PASS** |
| `tokens-dark.conf` / `tokens-light.conf` present | **PASS** |
| Dark base `BG=#0a1628`, `FONT_UI=Outfit` | **PASS** |
| Light arctic base colours + `FONT_UI=Outfit` | **PASS** |
| `ethereal-tokens-generate` + `ethereal-theme-apply` executable | **PASS** |
| `ethereal` CLI `tokens` path | **PASS** |
| Templates use `@FONT_UI@` (apply-time) | **PASS** (in share/templates) |
| Skel waybar/wofi CSS still JetBrains until first apply | **Expected** (not a bake failure) |

Live apply proof (from baked ISO, no inject): `ethereal-tokens-generate --check` OK · `ethereal theme aurora` → Applied · waybar/wofi CSS gained `font-family: "Outfit", "JetBrainsMono Nerd Font", …`.

---

## 3. Disposable live boot

| Check | Result | Evidence |
|-------|--------|----------|
| Domain / disk | `ethereal-os` · fresh `ethereal-e2e-stage1.qcow2` (30 G sparse) · **no inject disk** · CDROM = new ISO | dumpxml |
| Boot to greeter | **PASS** · `CMD ethereal-session` | `boot-*.png` |
| Login `ethereal` / `ethereal` | **PASS** | `live-05.png`+ |
| Sway + Waybar + wallpaper | **PASS** | `live-*.png` |
| Networking | **PASS** · ping 1.1.1.1 · `nmcli connected:full` · `ens3` up | `smoke-02` |
| Audio (user PipeWire) | **PASS** on live · `pipewire` / `pipewire-pulse` / `wireplumber` active | `smoke-06/07` |
| Systemd system units for PipeWire | inactive (expected; session services used) | noted |
| Super+Return foot / Super+D wofi | **PASS** | `smoke-01`, `smoke-05` |
| Steam on live ISO | **PASS** present | smoke |
| Sway fallback preserved | **PASS** · compositor remains Sway 1.12 | |

---

## 4. Clean install (no inject)

| Check | Result | Evidence |
|-------|--------|----------|
| Installer | Baked `ethereal-installer --auto --disk /dev/vda --confirm YES --user demo --password demo --fs ext4 --no-reboot` | `install-00` / `install-15` |
| Target | Disposable virtio `/dev/vda` only | summary on screen |
| Finish | **PASS** · `Installation finished SUCCESSFULLY` | `install-15.png` |
| Lean auto (no Steam) | **PASS** by design | later installed check |

---

## 5. First boot / OOBE / desktop (installed, ISO detached)

| Check | Result | Evidence |
|-------|--------|----------|
| Boot without ISO | **PASS** · greeter `CMD ethereal-session` | `installed-boot-*.png` |
| Login `demo` / `demo` (first) | **PASS** → OOBE | `oobe-01.png` |
| OOBE pages | **PASS** · welcome → keyboard → network (`ens3 connected`) → appearance (`arctic-glow`) → privacy → complete | `oobe-step-02`…`09` |
| OOBE state | **PASS** · `done` after finish | installed smoke |
| Second login → desktop | **PASS** (after faillock wait — see issues) · Getting Started guide · light arctic wallpaper | `final-desktop-*`, `installed-01` |
| Account | Installer-created `demo` (OOBE review-only; no second account required) | OOBE copy |
| Networking installed | **PASS** · ping + `connected:full` | `installed-03` |
| Sway installed | **PASS** · 1.12 | `installed-03` |
| Stage 1 on installed root | **PASS** · tokens JSON + generator + `FONT_UI=Outfit` + waybar CSS Outfit bridge | `installed-03`…`05` |
| Wofi installed | **PASS** | `installed-04` |
| Steam on installed (lean auto) | Omitted (**expected**) | `STEAM_OMITTED_LEAN_AUTO` |

---

## 6. Failures / warnings / missing functionality

| Item | Severity | Notes |
|------|----------|-------|
| Installed session: Waybar not visible / not running after arctic-glow OOBE | **Open** | Wallpaper + Sway + wofi OK; waybar CSS exists with Outfit; bar not observed in installed screenshots |
| Installed session: PipeWire user units inactive; `pactl` no sink | **Open** | Live session had working user PipeWire; installed lean path needs follow-up (enable/socket wiring) |
| Outfit font not packaged | Known / deferred | Token bridge writes Outfit first; runtime falls back to JetBrainsMono |
| PAM faillock during OOBE→greeter | Process | Extra Enter keys after OOBE locked `demo` ~10 min; not a product bake defect |
| `ethereal theme list` / `theme apply X` | UX | Correct CLI is `ethereal theme <name>` / `ethereal list-themes` |
| Build initcpio PXE / busy umount | Noise | Non-fatal |
| Live first-login welcome | Not clearly captured | Desktop reached; guide shown on installed path |

**Safety compliance:** physical disks untouched; Fedora host packages/config not modified; Stage 2 not started; inject disk **not** used for this E2E; Sway remains the compositor.

---

## 7. Verdict

| Gate | Verdict |
|------|---------|
| ISO rebuild with Stage 1 | **PASS** |
| Stage 1 present + working on live ISO | **PASS** |
| Clean install from baked ISO (no inject) | **PASS** |
| First boot + OOBE + second login | **PASS** (with faillock delay) |
| Installed desktop basics | **PASS with gaps** (Waybar missing; audio inactive on installed) |

**Overall:** Rebuild + Stage 1 bake + clean-install path are verified enough to treat Stage 1 as shipped in this ISO. Do **not** call the installed desktop fully green until Waybar autostart and PipeWire user session on the lean installed image are fixed or re-tested.

---

## 8. Recommendation — next milestone

1. **Fix installed-session gaps (small hotfix milestone)** before Stage 2: Waybar autostart under light/arctic-glow; PipeWire user services on lean install; optional re-test audio with `pactl`.  
2. **Then** await approval for **Stage 2** (panel/launcher polish only) — still no compositor swap.  
3. Optional later: package Outfit (or approved fallback font); interactive install gaming path E2E (`ETHEREAL_INSTALL_GAMING=1`).

**Stop — waiting for owner approval before Stage 2 or further product changes.**
