# SIGAM-BR — Malaria Cost Calculator (Brazilian Amazon)

**Author:** Henrique Bracarense  
**Live app:** https://geesc.shinyapps.io/sigam_br/  
**App type:** R Shiny (shinydashboard)  
**Scope:** Public-sector (SUS) expenditures related to malaria in the Brazilian Amazon

This repository contains the code and data assets for **SIGAM‑BR**, an interactive R Shiny dashboard that estimates and visualizes the **economic cost of malaria** from the perspective of Brazil’s public health system (SUS) for states and municipalities in the **Amazônia Legal**. The app is bilingual (Portuguese/English) and includes cartographic visualization, expenditure breakdowns (diagnosis, treatment, surveillance and control, hospitalizations), and per‑capita or per‑notification indicators.

> **Methodological reference:**  
> Andrade, Mônica V.; Noronha, Kenya; Silva, Valéria; **Bracarense, Henrique**; Carvalho, Lucas; Silva, Daniel Nogueira da; Souza, Aline; Motta‑Santos, André Soares; Peterka, Cassio; Castro, Marcia C. (2024). **The economic cost of malaria in Brazil from the perspective of the public health system.** *PLOS Global Public Health*, 4:e0003783‑12.  
> Use this article for methodological details on unit costs, components, and aggregation strategy implemented in the app.

---

## What the app does

The SIGAM‑BR dashboard brings together epidemiological and cost information to help policy analysts and program managers understand **where and how** SUS resources are spent on malaria. It provides:

- **Overview (“Intro”)**: Landing page with bilingual context and basic instructions.
- **Epidemiology**:
  - **API (Annual Parasite Index)** map for states/municipalities of the Brazilian Amazon using built‑in shapefiles.
  - Choice of **aggregation** (state vs. municipality) and **visualization mode** (map vs. charts).
  - Year selector and language toggle.
- **Diagnostic & Treatment** (grouped menu with two tabs):
  - **Diagnostic**: cards and charts for **test expenditures** and totals. Indicators can be shown as **absolute**, **per capita**, or **per notification**.
  - **Treatment**: cards and charts for **pharmaceutical expenditures**, **hospitalization costs**, and totals. Same indicator options (absolute/per‑capita/per‑notification).
- **Surveillance & Control** (grouped menu with two tabs):
  - **Surveillance**: expenditures in routine surveillance activities.
  - **Control**: expenditures related to vector control and other control programs.
- **Human Resources**: expenditures that can be attributed to HR in the malaria program.
- **Total Expenditures**: roll‑up view with totals and comparison across geographies and time.
- **Interactive map (Leaflet)**: color‑coded API classes (Very low, Low, High) with bilingual legends.
- **Download**: buttons to export the **current data view** (CSV) for offline analysis.

> The interface uses **value boxes**, **cards**, **Leaflet** maps, and custom radio‑button groups for selecting the indicator definition: **absolute values**, **per capita**, or **per notification**.

---

## Inputs & Controls

Key inputs detected in the code:

- `year_input`: select the reference **year**.
- `uf_input` / `city_choice`: choose **state vs. municipality** aggregation (Amazônia Legal only).
- `aggregation_input`: toggles the **level of aggregation** used by charts/cards.
- `visualization_choice`: switches between **Map** and **Chart** in the Epidemiology section.
- Indicator switch: show **Absolute**, **Per capita**, or **Per notification** values.
- `language_input`: **Português / English** toggle.

> The app auto‑scales totals depending on the indicator chosen (e.g., divides by total population or total notifications for the selected year and geography when in per‑capita or per‑notification modes).

---

## Data & Assets

This package ships with the following data assets (as found in the `/www` folder and root directory):

- `base_dados.RDS` — consolidated dataset with expenditures, population, notifications, etc. (used throughout).
- `ipa_base.RDS` — epidemiological base with **API (Annual Parasite Index)**.
- Cartographic layers (ESRI Shapefile sets) for **Amazônia Legal** states (e.g., `ac.*`, `am.*`, `ap.*`, `ma.*`, `mt.*`, `pa.*`, `ro.*`, `rr.*`, `to.*`) used in the Leaflet maps.
- `logo.jpeg` — header logo for the dashboard UI.

> The app’s calculations follow the methodology documented in the PLOS GPH article cited above; values displayed in cards and charts are (re)computed via dplyr pipelines each time you change the year or indicator type.

---

## Directory Structure

```
sigam_zip/
├─ app_malaria34.R        # Main Shiny app (UI + server logic; shinydashboard)
├─ base_dados.RDS         # Aggregated SUS expenditures & population/notifications
├─ ipa_base.RDS           # Annual Parasite Index
└─ www/                   # Map assets & static resources (Amazônia Legal shapefiles, logo)
   ├─ ac.{{shp,shx,dbf,prj}}
   ├─ am.{{shp,shx,dbf,prj}}
   ├─ … (ap, ma, mt, pa, ro, rr, to)
   └─ logo.jpeg
```

---

## How to run locally

1. **Install R (≥ 4.1)** and the packages below.
2. Open `app_malaria34.R` in RStudio (or run from an R console).
3. From the project root, run:

```r
shiny::runApp('app_malaria34.R')
```

### Required packages

The code uses the following packages (inferred from functions present in the script):

```r
install.packages(c(
  "shiny",           # web framework
  "shinydashboard",  # value boxes, dashboard layout
  "shinyjs",         # UI interactivity
  "leaflet",         # interactive maps
  "dplyr",           # data manipulation (filter, summarise, mutate, pipes)
  "readr",           # RDS/CSV helpers (if needed)
  "sf",              # shapefile handling
  "scales",          # labeling/scales for plots and value boxes
  "stringr"          # small string utilities
  # Add: "DT", "plotly", "ggplot2" if you extend tables/plots
))
```

> If you encounter missing‑package errors, install them as prompted. Depending on your environment, you may also need system GDAL/GEOS/PROJ libraries for `sf`.

---

## Reproducibility Notes

- **Data licensing**: Expenditure and epidemiological inputs are aggregated and bundled as `*.RDS` for reproducibility of the demo app. For up‑to‑date or disaggregated analyses, rebuild `base_dados.RDS`/`ipa_base.RDS` from the authoritative sources in your pipeline.
- **Geographic coverage**: Maps and analytics are limited to **Amazônia Legal**.
- **Indicators**: totals may be displayed in **absolute**, **per capita**, or **per notification** terms; ensure you interpret cards accordingly.
- **Downloads**: The app exposes **download buttons** (CSV) to extract the current filtered dataset behind a given view.

---

## Citation

If you use this app, **please cite the methodology** as:

> Andrade, M. V.; Noronha, K.; Silva, V.; **Bracarense, H.**; Carvalho, L.; Silva, D. N.; Souza, A.; Motta‑Santos, A. S.; Peterka, C.; Castro, M. C. (2024). *The economic cost of malaria in Brazil from the perspective of the public health system.* PLOS Global Public Health, 4:e0003783‑12.

And cite the software as:

> **Bracarense, H.** (2025). *SIGAM‑BR — Malaria Cost Calculator (Brazilian Amazon)*. R Shiny application, version 3.4 (file `app_malaria34.R`). URL: https://geesc.shinyapps.io/sigam_br/

---

## Author & Contact

**Henrique Bracarense**  
Lead developer and maintainer of the SIGAM‑BR app.  
For issues or collaboration, please open a GitHub issue in your fork or contact the author directly.

---

## License

Unless stated otherwise by the data owners, this code is released under an MIT‑style license. Please verify third‑party data licenses before redistribution.
