# Etheris OS — File transfers

## What is included

| Path | Tool | Use |
|------|------|-----|
| **LAN** | Warpinator | Send/receive files with nearby PCs/phones on the same Wi‑Fi |
| **Bluetooth** | Blueman + `bluez-obex` | Pair devices; OBEX push send/receive |
| **Shares / phones** | PCManFM + `gvfs-smb` / `gvfs-nfs` / `gvfs-mtp` | Browse Windows/SMB, NFS, USB/MTP phones |

Hub UI: **Etheris Transfers** (`etheris-transfer`).

Receive folders (created on first open):

- `~/Downloads/Etheris Transfers` — Warpinator / LAN
- `~/Downloads/Bluetooth` — Blueman OBEX (configure in Blueman if needed)

## Quick start

```bash
etheris-transfer          # hub
etheris-transfer lan      # Warpinator
etheris-transfer bluetooth
etheris-transfer send     # Blueman send-to
etheris-transfer files    # network:/// in Files
```

### LAN (Warpinator)

1. Open **Etheris Transfers** → **Open Warpinator** on both devices.
2. Use the **same group code** on both (change from the default in Warpinator preferences).
3. Same subnet (typical home `192.168.x.x`); disable VPN while testing.
4. Firewall already allows TCP `42000–42001`, UDP `42000`, and mDNS `5353` in `nftables`.

### Bluetooth

1. Open **Bluetooth manager** from the hub (starts OBEX + Blueman).
2. Pair/trust the device.
3. Blueman → Local Services → Transfer → enable receiving from trusted devices.
4. **Send files…** uses `blueman-sendto`.

### SMB / phone storage

- **Open Files** → Network, or plug in a phone (MTP via `gvfs-mtp`).
- Connect to `smb://server/share` when prompted.

## Security notes

- SSH remains **disabled/masked** by default; transfers do not require it.
- Warpinator ports are opened only for local LAN discovery/transfer — still use a unique group code.
- Do not expose these ports on untrusted networks without understanding the risk.

## Related

- [SECURITY.md](SECURITY.md)
- [KEYBOARD.md](KEYBOARD.md)
