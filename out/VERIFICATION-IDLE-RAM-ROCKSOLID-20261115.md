# Verification — Idle RAM ≤500 MiB (rock-solid) · 2026-11-15

**Criteria:** [`docs/IDLE-RAM-CRITERIA.md`](../docs/IDLE-RAM-CRITERIA.md)  
**ISO:** `out/etheris-2026.11.15-x86_64.iso` (rebake after fix)  
**SHA256:** `eb677f92d3d6a336b1eca3f6b8f64de4e649badabf22c17366468c3a4b05dfd6`  
**VM:** `etheris-os` · qemu:///session · live CDROM · ~3584 MiB guest RAM  
**Evidence:** `out/qemu-idle-ram-20261115T200700Z/` (pre-fix) · `out/qemu-idle-ram-verify-20261115T203447Z/` (post-fix)

## Protocol

1. Measure idle **twice** on stock ISO **before** tree changes (IR1/IR2 pre-fix).  
2. Fix only after dual record.  
3. Rebake ISO (no guest-apply for claimed PASS — IR5).  
4. Cold-boot measure **twice** on new ISO; IR4 key-functionality after.

## Pre-fix (stock ISO, before fix)

| Run | `session_pss` | `firefox` | Result |
|-----|---------------|-----------|--------|
| A | **167 MiB** (after `pkill -x firefox`) | no | OK only after killing warm Firefox |
| B | **972 MiB** | **yes** (mapped) | **OVER** — warm preload left Firefox resident |

**Root cause:** default warm Firefox preload exceeded the idle gate.

## Fix (tree → ISO)

| Change | Purpose |
|--------|---------|
| `browser_preload=off` in skel + live home `settings.conf` | Default idle without resident Firefox |
| `etheris-browser --preload` | Always prepares **lean** profile; warm start only if `browser_preload=on`; kill if cannot scratchpad |
| `etheris ram idle-check` | **Must** `firefox: no` and `session_pss ≤ 500` |
| Super+B | Unchanged — lean profile (key browser path kept) |

ISO squashfs verified: `browser_preload=off` in skel + home; warm-disabled + idle firefox gate present in binaries.

## Post-fix (new ISO, cold boots, no guest-apply)

| Run | `session_pss` | `firefox` | `preload_enabled` | Result |
|-----|---------------|-----------|-------------------|--------|
| A | **169 MiB** | no | no | **OK** |
| B | **169 MiB** | no | no | **OK** |

Settle ≥60 s after login. Metric: `etheris ram idle-check` (not Waybar MemUsed).  
OCR “560” on target line is misread **500**. Swap used observed **0** on live screenshots.

### IR4 — key functionality (after verify A)

| Check | Result |
|-------|--------|
| `etheris-auth-check` | **12 OK, 0 FAIL** |
| `systemctl is-active nftables` | **active** |
| `systemctl is-active NetworkManager` | **active** |
| `pgrep -x pipewire` | **running** (pid observed) |
| Super+A Menu | **PASS** — Ocean Glass / Power / Balanced |
| Super+D launcher | **PASS** — app tiles (Etheris Files / Perf / Soft, …) |

## Criteria checklist

| ID | Status |
|----|--------|
| IR0 | **PASS** — protocol + evidence dirs |
| IR1 | **PASS** — verify A · 169 MiB · firefox no |
| IR2 | **PASS** — verify B · 169 MiB · firefox no |
| IR3 | **PASS** — swap used 0 |
| IR4 | **PASS** — auth · Menu · launcher · nftables · NM · PipeWire |
| IR5 | **PASS** — stock rebaked ISO, no inject for claim |

## Must-not-sacrifice

Greeter/Sway/Waybar, Menu, launcher, nftables, auth-check, PipeWire, NetworkManager, lean Super+B path — all retained. Only default **warm resident** Firefox preload is off.

## Verdict

**ROCK-SOLID PASS** — idle `session_pss` ≤500 MiB on two independent cold boots of the fixed ISO, with key functionality intact.
