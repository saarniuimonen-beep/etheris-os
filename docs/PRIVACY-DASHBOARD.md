# Etheris OS — Privacy dashboard (0.4 beginning)

**CLI:** `etheris privacy` → policy file + `etheris-security`  
**Not yet:** full GTK Settings panel (planned with Control Center IA)

## Surfaces

| Surface | Status |
|---------|--------|
| `/etc/etheris/privacy.conf` | Policy knobs when present |
| `etheris privacy status` | Dashboard overview |
| `etheris privacy audit` | Local checklist |
| `etheris privacy firewall` | nftables |
| Control Center “Privacy” tile | Future — wrap same commands |

## Principles

- No cloud telemetry in Alpha  
- AUR clearly risky  
- Support bundles via `etheris report create` are **redacted** locally by the user before sharing  
