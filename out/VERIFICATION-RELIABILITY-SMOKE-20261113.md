# Verification — reliability rebake live smoke (2026-11-13 ~19:54–20:20)

TCG QEMU (`qemu:///session`, no `/dev/kvm`). Evidence: `out/qemu-reliability-smoke-20261113/`.

## Artifact

| Item | Value |
|------|--------|
| ISO | `out/etheris-2026.11.13-x86_64.iso` (rebake) |
| SHA256 | `107e65381737c8ce05eeed4150fa6df8f8b4ecefb6d04be5946df8ef27c157c2` |
| Libvirt CD | hardlinked at `~/.local/share/libvirt/images/etheris-2026.11.13-x86_64.iso` |
| Build log | `out/build-20261113T174758Z.log` |

## ISO content (squashfs extract)

| Check | Result |
|-------|--------|
| `docs/FLOW.md` | **PASS** |
| `FONT_UI=Noto Sans` in tokens | **PASS** |
| `etheris-theme-apply` Flow + `resolve_font_ui` / `gtk_animations_flag` | **PASS** |
| skel `gtk-enable-animations=0` | **PASS** |
| sway `restore-dnd` + `etheris-overlay winctl` + `etheris-guide` | **PASS** |
| `nftables` `RemainAfterExit` drop-in | **PASS** |
| `etheris-notifications` `restore-dnd` | **PASS** |
| `regreet.toml` `skip_selection=true` | **PASS** (see greeter note) |

## Live VM

| Check | Result | Evidence |
|-------|--------|----------|
| Boot → ReGreet | **PASS** | `boot-10.png` … |
| Login `etheris` / `etheris` → Etheris desktop | **PASS** | `desk-2.png`, `term-open.png`, `smoke-final.png` |
| Waybar Etheris panel | **PASS** | `desk-2.png` |
| Sway session / tiling | **PASS** | `smoke-final.png` (Sway 1.12) |
| `nftables` is-active | **PASS** (`active`) | `checks.png` |
| `etheris-auth-check` | **PARTIAL** | 11 OK, 1 FAIL — Python 3.13 `crypt` removed (**fixed in tree**, needs next bake) |
| Greeter shows User/Session on cold live | **NOTE** | `skip_selection` needs cache; dual Sway vs Etheris sessions — **stock sway.desktop NoDisplay fixed in tree** |

## In-tree follow-ups (not in this ISO)

1. `etheris-auth-check` libcrypt ctypes verify (Python 3.13)
2. Hide stock `sway.desktop` (`NoDisplay=true`)
3. Seeded `/var/lib/regreet/cache.*` for live defaults (best-effort)

## Verdict

**Rebake SUCCESS. Live desktop smoke PASS for Flow/reliability artifacts that shipped in this ISO** (`nftables` active, Flow docs/tokens/theme-apply present, session usable).  
Auth-check false FAIL + greeter session dual-entry are fixed in tree for the next bake.
