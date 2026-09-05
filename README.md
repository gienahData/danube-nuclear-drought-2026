# Transboundary Climate–Nuclear Risk on the Danube
## Evidence from the August 2026 Drought Event

**Working paper · September 2026**  
Szabó, T. (2026). Transboundary Climate–Nuclear Risk on the Danube:
Evidence from the August 2026 Drought Event. Working paper, September 2026.
https://doi.org/10.5281/zenodo.22411012.
szabo.tunde@geoinsight.hu

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.22411012.svg)](https://doi.org/10.5281/zenodo.22411012)

---

> ⚠️ **Work in progress — not for citation without author permission.**  
> Bootstrap confidence intervals and L-moments cross-validation are pending.

---

## Overview

The August 2026 Danube drought simultaneously reduced cooling-water availability and river temperature buffer capacity at three nuclear power plants: Paks (Hungary), Kozloduy (Bulgaria), and Cernavodă (Romania). This repository contains the supplementary figures, interactive heat-stress analysis, and the core copula analysis code from the working paper.

Total verified generation loss: **1,784 GWh** (29-year low).  
Joint return period of simultaneous thermal + hydraulic stress: **~103 yr** (Gumbel copula, τ = 0.55) vs ~841 yr under the independence assumption — a **4.3× overestimate** if dependence is ignored at T = 10 yr.

---

## Repository contents

| File | Description |
|---|---|
| `danube_figures.html` | Supplementary Figures 1–3 (discharge record, corridor map, copula joint RP) |
| `heat_stress.html` | Interactive capacity-factor chart for all three plants, Jul–Aug 2026 |
| `danube_nuclear.pdf` | Working paper (PDF) |
| `copula_joint_rp.py` | Core copula analysis script — joint return period calculation |

---

## Copula analysis

`copula_joint_rp.py` implements the Gumbel–Hougaard copula joint return period used in the paper.

```bash
pip install numpy scipy matplotlib   # matplotlib optional
python copula_joint_rp.py            # print table + 2026 summary
python copula_joint_rp.py --plot     # reproduce Figure 3
```

**Core formula** (equal marginals, closed form):

```
θ = 1 / (1 − τ)                          Gumbel parameter from Kendall's τ
RP_joint = T^(2^(1/θ))                    joint return period (years)
```

where `T` is the marginal return period and `τ = 0.55` (Van Vliet et al., 2016).

---

## Data sources

All data validated at primary sources; no secondary or unverified aggregators used.

| Data | Source | License |
|---|---|---|
| River discharge (dis06, 6-hourly) | Copernicus EWDS / ECMWF LISFLOOD EFAS v5 reanalysis | CC BY 4.0 |
| Plant generation losses | ENTSO-E Transparency Platform TR 16.1.A r3 | Open |
| Copula τ calibration | Van Vliet et al. (2016) doi:[10.1038/nclimate2961](https://doi.org/10.1038/nclimate2961) | — |

EFAS v5 reference cell: **46.37°N, 18.74°E** (~29 km SSW of Paks), variable `dis06`.

---

## Citation (working paper)

```
Szabó, T. (2026). Transboundary Climate–Nuclear Risk on the Danube:
Evidence from the August 2026 Drought Event. Working paper, September 2026.
szabo.tunde@geoinsight.hu
https://doi.org/10.5281/zenodo.22411012
```

---

## License

Code: MIT.  
Figures and text: CC BY 4.0 — attribution required.
