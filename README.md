# Etheris OS

Arch-based, lightweight Wayland distribution (**Sway** default, Neo-Aero desktop).  
Version: see `VERSION` (currently **0.1.0-alpha**).

## Goals

- ≤ **500 MB** idle RAM aspirational (Etheris/Sway session; do not strip security/features for it)
- Highly customizable (`~/.config/sway`, `etheris themes`)
- Simple USB install (`etheris-installer`)
- CPU/GPU **Performance Manager** (`etheris-perf`) + **GPU Manager** (`etheris-gpu`)
- **Channels**: `stable` (default, **14-day** Arch Archive lag) · `rc` · `edge`
- Update manager: `etheris-update` (no custom mirror infra yet)
- Optional AUR with lag gate (`etheris-aur`) — user-maintained, not official binaries

## See also

- [SESSION-LOG.md](SESSION-LOG.md) — **resume here**
- [docs/RENAME-VERIFICATION.md](docs/RENAME-VERIFICATION.md) — Ethereal → Etheris rename checkpoint
- [docs/PERFORMANCE-MANAGER.md](docs/PERFORMANCE-MANAGER.md) — performance / GPU managers
- [MASTER-CHECKLIST.md](MASTER-CHECKLIST.md) — phase status (honest)
- [docs/HARDWARE.md](docs/HARDWARE.md) — CPU/GPU detection & driver policy
- [docs/GAMING.md](docs/GAMING.md) — Steam / Proton / gaming stack
- [docs/LOGIN.md](docs/LOGIN.md) — ReGreet Neo-Aero login
- Live login: `etheris` / `etheris`

```bash
etheris hardware          # CPU/GPU report
etheris drivers status    # driver recommendations
etheris performance       # profiles / metrics
etheris gpu               # GPU Manager summary
etheris gaming            # Steam/Proton notes
```

## Build ISO (from Fedora via Podman)

```bash
cd ~/etheris-os
chmod +x build.sh scripts/*.sh
./build.sh
```

Needs ~12–20 GB free. Output: `out/etheris-*.iso` + `SHA256SUMS`.

Write USB:

```bash
sudo dd if=out/etheris-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Security & privacy

Safe defaults (nftables on, no telemetry, no SSH by default). See [docs/SECURITY.md](docs/SECURITY.md).

```bash
etheris-security status
sudo etheris-security firewall
etheris-security audit
```

## Update channels

See [docs/CHANNELS.md](docs/CHANNELS.md). Long-term 4-year support is **deferred**: [docs/RELEASE-POLICY.md](docs/RELEASE-POLICY.md).

```bash
etheris-update status
sudo etheris-update channel stable|rc|edge
sudo etheris-update upgrade
```

## First boot

1. **greetd + ReGreet** (Neo-Aero login; TUI fallback available)
2. User `etheris` / password `etheris` (live)
3. Session: **Etheris (Sway)**
4. Install: `sudo etheris-installer`

Shortcuts: **Super+Return** terminal · **Super+D** / **Super+Space** launcher · **Super+A** Control Center · **Super+,** Settings · **Super+Shift+E** power menu

## Status honesty

Latest ISO bake: see `SESSION-LOG.md` / `out/SHA256SUMS`.  
Performance Manager is in tree; physical GPU validation is separate from QEMU.  
Track progress in `MASTER-CHECKLIST.md`.

## Immutability

Planned only — see [docs/IMMUTABLE.md](docs/IMMUTABLE.md). Current installs are mutable.
