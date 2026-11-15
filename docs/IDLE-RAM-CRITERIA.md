# Etheris OS — Idle RAM criteria (≤500 MiB, rock-solid)

**Rule:** Claim **idle RAM PASS** only when **two** independent measurements both meet every Must below.  
**Order:** Measure twice **before** changing the tree. Fix only after both runs are recorded.

**Metric (Must):** `session_pss` via `etheris ram idle-check`  
= sum of the desktop user’s process **Pss** (MiB).  
**Not** the same as Waybar `{used}` / `MemTotal−MemAvailable` (those include kernel, page cache, and other users).

**Target:** `session_pss ≤ 500` MiB at idle.

---

## Idle definition (strict)

Measurement is valid only when **all** are true:

1. Live (or installed) **Etheris (Sway)** graphical session  
2. **No Firefox** process (`firefox: no`)  
3. No extra user apps (no Settings / Files / Steam / terminals left open preferred; one foot for the probe OK if closed before final read, or counted in session_pss)  
4. Settle **≥60 s** after login before reading  
5. `swap used = 0` (zram size may be non-zero; **used** must be 0)  
6. Overlays closed (no Menu / launcher sheet open)

---

## Must (rock-solid)

| ID | Criterion |
|----|-----------|
| IR0 | Documented protocol followed; evidence under `out/qemu-idle-ram-*/` |
| IR1 | Run **A**: `etheris ram idle-check` → **OK**, `session_pss ≤ 500`, `firefox: no` |
| IR2 | Run **B**: second cold boot **or** ≥5 min later re-settle → same as IR1 |
| IR3 | Both runs: `swap used = 0` |
| IR4 | After Run B: key functionality still works — `etheris-auth-check` 0 FAIL, Super+A Menu, Super+D launcher, `nftables` active |
| IR5 | No guest-apply / inject required for the claimed PASS |

## Recorded (not Must-fail alone)

| ID | Record |
|----|--------|
| IR-R1 | `system_used` (MemTotal−MemAvailable) both runs |
| IR-R2 | Top RSS contributors (`ps` / `etheris-browser --status`) |
| IR-R3 | Whether warm Firefox preload skipped (budget log) |

---

## Must NOT sacrifice for the budget

Do **not** remove or break to hit 500 MiB:

- greetd / ReGreet login · Etheris (Sway) session · Waybar  
- Menu (Super+A) · launcher (Super+D) · lock  
- `nftables` · `etheris-auth-check` · scoped polkit  
- PipeWire audio stack · NetworkManager  
- Installer / update path  

Allowed lean levers (only after dual FAIL evidence):

- Keep **lean Firefox profile**; skip **warm resident** preload when over budget (already)  
- Default `browser_preload` warm-start off if warm Firefox is what breaks idle (Super+B still uses lean profile)  
- Avoid leaving autostart apps visible on the workspace  

---

## How to measure

```bash
# After login, settle ≥60s, close overlays/apps:
etheris ram idle-check
# Expect: result OK — session_pss under 500 MiB ; firefox: no ; exit 0
```

Two runs required (IR1 + IR2) before any fix PR/rebake claim.
