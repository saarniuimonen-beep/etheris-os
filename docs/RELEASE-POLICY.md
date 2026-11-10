# Etheris OS — Long-Term Release and Support Policy

**STATUS: DEFERRED — design only**

Do **not** implement or advertise four-year support until:

1. Archiso ISO builds reliably  
2. Installer works end-to-end  
3. Channel update tooling is proven (`etheris-update`)  
4. Snapshot promotion testing is routine  

## Intended future policy (not active)

- New Etheris release about every **6 months**
- Semantic versioning
- Changelog + release history
- ~**4 years** support **per release** — only after infra exists
- Security / critical fixes / tested kernels / installer fixes
- Separate snapshots/repos per supported release
- ISO refreshes + checksums
- Upgrade utility between Etheris releases with config backup

## Current reality (0.1.0-alpha)

- Single rolling product with **channels** (stable / rc / edge)
- Stable uses Arch Archive lag (14 days)
- No promise of multi-year support for this alpha
