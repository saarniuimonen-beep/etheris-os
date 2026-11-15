# Etheris OS — SELinux study (Alpha 0.3)

**Status:** Write-up only — **SELinux is not enabled** on Etheris  
**Date:** 2026-11-15

---

## Question

Should Etheris adopt SELinux (or AppArmor) for mandatory access control on a Sway desktop?

---

## Findings (summary)

| Option | Fit for Etheris Alpha | Notes |
|--------|----------------------|-------|
| **SELinux** (targeted) | Poor short-term | Policy maintenance; Arch packaging friction; breaks greeter/flatpak/Steam often without dedicated owners |
| **AppArmor** | Slightly easier on some distros | Still needs profiles for Etheris stack; not default on Arch |
| **Keep DAC + nftables + scoped polkit** | **Recommended through Beta** | Matches current SECURITY-AUDIT posture |

---

## Recommendation

1. **Do not enable SELinux** for Alpha 0.3–0.4.  
2. Invest in: nftables defaults, fewer passwordless polkit rules, optional LUKS, update recovery, honest docs.  
3. Revisit MAC after Software Center + package trust labeling exist (need a policy story for user-installed apps).  
4. If a contributor prototypes SELinux, require: greeter login, PipeWire, portals, Flatpak (if any), and Steam as gates — all on real hardware.

---

## If studied further

- Reference policy source and maintenance cost  
- Audit2allow trap (shipping permissive “allow all” is theater)  
- Interaction with `etheris-immutable` / A/B experiments
