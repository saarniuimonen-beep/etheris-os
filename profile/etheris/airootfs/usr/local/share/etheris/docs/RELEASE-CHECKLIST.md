# Etheris OS — release checklist

Use before claiming a new ISO or website download row. Do not invent hardware results.

## Pre-bake

- [ ] `VERSION` bumped if product semver changed
- [ ] `SESSION-LOG.md` current (latest ISO + SHA + next steps)
- [ ] `MASTER-CHECKLIST.md` not contradicting SESSION-LOG
- [ ] `./scripts/check-profile.sh` PASS
- [ ] `./scripts/test-p0-security.sh` PASS
- [ ] MOTD / README / website do not advertise unshipped DEs or unverified hardware
- [ ] Deferred items stay labeled deferred (LUKS UI, Secure Boot, immutability, 4-year support)

## Bake

- [ ] `./build.sh` completes
- [ ] `out/SHA256SUMS` lists the new `etheris-YYYY.MM.DD-x86_64.iso`
- [ ] Verification note under `out/VERIFICATION-*.md` for what this bake proves

## Post-bake (VM)

- [ ] Live smoke: greetd/ReGreet → Etheris (Sway) → `etheris` / `etheris`
- [ ] Polkit scoped / auth-setup live-only spot check
- [ ] Installer E2E against [`INSTALL-PERSISTENCE.md`](INSTALL-PERSISTENCE.md) gates (cold reboot)
- [ ] Update website `pages/download.html` SHA + date **only** after local verify (public publish still needs owner approval)

## Do not claim without evidence

- Physical GPU / Proton / suspend matrix rows
- Public “stable” download
- Bit-identical reproducible ISO
- Immutable / A/B updates
