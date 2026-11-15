# Etheris OS — Project Architecture Audit

**Date:** 2026-11-15  
**Version audited:** 0.1.0-alpha  
**Branch context:** `docs/comprehensive-audit`  
**Method:** Repository inspection + existing `out/VERIFICATION-*.md` evidence. No new unverified claims.

---

## 1. Architecture overview

Etheris is an **Archiso-based live/installable distribution** with a first-party tooling layer under `/usr/local/bin/etheris*` and config under `/etc/etheris/` + `~/.config/etheris/`.

| Layer | Location | Role |
|-------|----------|------|
| Build | `build.sh`, `scripts/`, Podman `archlinux:latest` | Produce hybrid ISO |
| Profile | `profile/etheris/` | Archiso profile (packages, airootfs, boot) |
| First-party tools | `airootfs/usr/local/bin/etheris*` (~60+ binaries) | Desktop, install, update, hw, security |
| Design | `design/phase-{1,2}/`, `share/etheris/design/` | Tokens + HTML previews + apply pipeline |
| Docs | `docs/`, `SESSION-LOG.md`, `MASTER-CHECKLIST.md` | Spec + honesty gates |
| Website | `website/` | Local marketing site (no public publish without approval) |
| Evidence | `out/VERIFICATION-*.md`, `out/qemu-*/` | What was actually tested |

**Compositor (verified in packages + live smoke):** **Sway** — not Hyprland. ADR: [`ADR-ETHERIS-DESKTOP.md`](ADR-ETHERIS-DESKTOP.md).

**Desktop identity names in tree:** Neo-Aero (design intent) · Flow (token/M1 pipeline) · Etheris Desktop (ADR/P0). They describe overlapping efforts; see [`DESKTOP-AUDIT.md`](DESKTOP-AUDIT.md).

---

## 2. Important findings

### Strengths

1. **Honest alpha posture** — SESSION-LOG / SECURITY.md / IMMUTABLE.md explicitly mark deferred work.
2. **Working install path** — UEFI installer + persistence E2E on KVM ([`out/VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md`](../out/VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md)).
3. **Live reliability bake** — ISO `ec72603b…` (2026-11-15): desktop, Menu, launcher, auth-check **12 OK** ([`out/VERIFICATION-RELIABILITY-SMOKE-20261115.md`](../out/VERIFICATION-RELIABILITY-SMOKE-20261115.md)).
4. **Scoped security defaults** — nftables inbound drop, no telemetry, live-only NOPASSWD, scoped polkit, pacman SigLevel Required.
5. **Source CI** — `.github/workflows/source-checks.yml`: `bash -n`, `py_compile`, P0 tests, `check-profile.sh`.
6. **Channel updates** — `etheris-update` + Archive lag (`channels.conf`) without custom mirrors.

### Weaknesses / risks

1. **ISO default is heavy** — ~161 packages including full Steam/Wine/Gamescope stack; conflicts with “lightweight core + optional groups” goal.
2. **Privileged builds** — `build.sh` uses `--privileged` Podman + host network; rootless not productionized.
3. **CLI sprawl** — many `etheris-*` tools; hub `etheris` covers themes/desktop/hw but not a full doctor/report/security surface as one UX.
4. **Update recovery thin** — previous mirrorlist snapshot exists; no Btrfs transactional rollback / user-facing repair wizard.
5. **Docs vs code drift** — Neo-Aero / Flow naming; phase READMEs stale; DESIGN.md launcher=wofi vs Rofi; token panel 40 vs Waybar 28; blur JSON off vs skel on.
6. **Greeter UX gap** — password row still needs a Login click on cold boot (verified 2026-11-15).
7. **No `etheris-doctor` / diagnostic bundle** — diagnostics are split across auth-check, security audit, hw.
8. **Immutable / LUKS / Secure Boot / SELinux** — documented as deferred; stubs only (immutable-prep).
9. **Gaming default ON** — installer defaults gaming stack on; conflicts with lightweight messaging.
10. **Install E2E on latest ISO** — persistence E2E is 2026-11-13; re-run needed on `ec72603b…`.
11. **On-ISO docs sync** — `prepare-profile.sh` must keep FLOW/ROADMAP (and related) current.

Architecture follow-up: [project architecture audit](1dcfa824-a757-468f-93c0-63439ff44620). Design follow-up: [Neo-Aero design audit](3a6f1065-0042-4afe-9bbc-e5e191a3fa1e).

---

## 3. Directory & dependency notes

| Path | Notes |
|------|--------|
| `profile/etheris/airootfs/etc/skel` vs `home/etheris` | Synced by `prepare-profile.sh`; drift caught by `check-profile.sh` |
| Polkit | Triplicated: `usr/local/share/etheris/polkit`, `etc/polkit-1/rules.d`, `usr/share/polkit-1/rules.d` — must stay identical (P0 checks) |
| `out/` | Large evidence tree; not source of truth for runtime |
| `work/` | mkarchiso scratch; root-owned after builds |

**Unnecessary complexity candidates:** dual launcher stacks (rofi + wofi), multiple browser helper UIs, gaming always-on ISO.

---

## 4. Recommended improvements (audit-level)

| Priority | Improvement | Rationale |
|----------|-------------|-----------|
| Critical | Automate post-bake ISO validation | Catch greeter/session/auth regressions before smoke |
| Critical | Keep installer/update reliability ahead of features | Matches alpha philosophy |
| High | Optional package groups (esp. Gaming off default) | Size + attack surface + idle RAM |
| High | Unify CLI (`doctor`, `security audit`, `report`) | Discoverability |
| High | Password-first greeter | First-impression reliability |
| Medium | Neo-Aero design system single source of truth | End Flow/Neo-Aero naming confusion |
| Medium | Pin Podman image digest | Build integrity |
| Experimental | LUKS / Secure Boot / SELinux / atomic updates | After 0.2 reliability |

Detailed rankings: [`DEVELOPMENT-ROADMAP.md`](DEVELOPMENT-ROADMAP.md).

---

## 5. Uncertainty (do not guess)

- Whether `firewalld` would improve UX over current nftables without regressing live Warpinator ports — **unevaluated**.
- SELinux policy cost on Sway/GTK4 stack — **unevaluated**.
- Bit-identical ISO reproducibility — `SOURCE_DATE_EPOCH` set; **not** independently proven.
- Physical GPU/Wi-Fi/suspend matrix — mostly open ([`HARDWARE-TEST-MATRIX.md`](HARDWARE-TEST-MATRIX.md)).
