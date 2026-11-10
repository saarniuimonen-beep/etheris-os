# Etheris hardware ID databases

TSV tables used by `etheris-hw` / `etheris-drivers`.

- Rows are keyed by **PCI device ID** (4 hex digits), not marketing names.
- Generated from system `pci.ids` chip markers; unknown IDs fall back to heuristics in the tools.
- GT 1030 Pascal = `1d01` (GP108). A Kepler rebadge (`0fc5`) is listed separately — not the Pascal target.
- Do not treat GT 1030 as a minimum performance bar.

Columns differ per vendor; see header comments in each `.tsv`.
