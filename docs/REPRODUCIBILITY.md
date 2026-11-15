# Etheris OS — Build reproducibility (Beta prep)

---

## Current controls

| Control | Status |
|---------|--------|
| `SOURCE_DATE_EPOCH` | Set by `build.sh` |
| Profile prepare | `scripts/prepare-profile.sh` stamps version/os-release |
| Pacman cache | Host `work/pacman-cache` bind-mounted |
| Arch container image | Pin via `out/build-image.pin` / `ETHERIS_BUILD_IMAGE` |
| ISO SHA256 | `scripts/validate-iso.sh` → `out/SHA256SUMS` |

---

## Pinning the build image

```bash
# After a known-good bake, record digest:
./scripts/pin-build-image.sh

# build.sh reads:
#   ETHERIS_BUILD_IMAGE  (default docker.io/archlinux:latest)
#   or digest from out/build-image.pin when present
```

Rebuilding with the same pin + same `SOURCE_DATE_EPOCH` + warm cache improves repeatability; bit-identical ISOs are **not** guaranteed (archiso, package churn inside the container upgrade step).

---

## Verification report (every bake)

1. `./build.sh`  
2. `./scripts/validate-iso.sh out/etheris-*.iso`  
3. Keep `out/build-*.log` + SHA256SUMS  
4. Optional: `scripts/test-iso-smoke.sh`

---

## Limits

- Container runs `pacman -Syu` before archiso — floating deps.  
- Privileged podman required today.  
- Full deterministic rebuilds need freezing the package set (future).
