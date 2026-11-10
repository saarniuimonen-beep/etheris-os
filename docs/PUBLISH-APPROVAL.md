# Publication approval checklist (Stage 2 / 5)

**Status:** Prepared locally — **awaiting explicit owner approval** before any public action.

## Repository list

| Repository / tree | Current visibility | Proposed | Notes |
|-------------------|--------------------|----------|-------|
| `~/etheris-os` (OS + docs + website/) | Local only (no git remote) | Public GitHub repo `etheris-os` (name TBD) | Prefer one main repo; website can live in `/website` |
| Separate website repo | N/A | Optional later | Not required for launch |
| Installer / desktop splits | N/A | Keep in main tree | Avoid unnecessary repos |

## Cleanup report

| Item | Status |
|------|--------|
| Secrets in tree | None found in quick scan of profile/docs; re-scan before push |
| ISO in git | Must stay **untracked** (`out/*.iso`) |
| `work/` mkarchiso | Untracked |
| Host `ethereal-*` libvirt images | Outside repo; optional rename |
| LICENSE / CONTRIBUTING / SECURITY / SUPPORT / CoC | Added |
| Issue / PR templates | Added under `.github/` |

## Security / licensing

- MIT draft for Etheris-authored files — **confirm or switch to GPL-3.0** before publish.
- Third-party ISO contents keep their own licenses.
- Rotate any credentials if ever committed (none known).

## Documentation status

| Doc | Status |
|-----|--------|
| README | Updated |
| Performance Manager | `docs/PERFORMANCE-MANAGER.md` |
| Rename verification | `docs/RENAME-VERIFICATION.md` |
| Hardware / gaming / security | Present |
| Full integration report | Draft needed after VM soak |
| Website | Local static site in `website/` |

## Agent must not (until you say so)

- `gh repo create` / change visibility to public
- Publish GitHub Releases or upload ISOs
- Buy a domain / change DNS
- Deploy the website publicly
- Advertise unverified hardware support

## Ask the owner

Reply with approval for any of:

1. `git init` + first commit (local only)
2. Create **private** GitHub repo and push
3. Make repo **public**
4. Publish a pre-release ISO asset
5. Deploy website to a host you specify
