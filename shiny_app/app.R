library(shiny)
library(bslib)
library(DT)
library(plotly)
library(dplyr)
library(readr)

# ── Cargar datos ─────────────────────────────────────────────────────────────
df <- read_csv("docs/heart_disease_health_indicators_BRFSS2015.csv", show_col_types = FALSE)
options(shiny.autoreload = TRUE)
# ── Source módulos ────────────────────────────────────────────────────────────
source("R/home.R")
source("R/objetivos.R")
source("R/marco_teorico.R")
source("R/metodologia.R")
source("R/carga.R")
source("R/limpieza.R")
source("R/resultados.R")
source("R/sintesis.R")
source("R/referencias.R")
source("R/metricas.R")
source("R/modelo.R")

# ── Colores globales ──────────────────────────────────────────────────────────
NAV_BG   <- "#101C2E"
PAGE_BG  <- "#070E1A"
RED      <- "#C0392B"

# ── Estilos CSS globales ──────────────────────────────────────────────────────
css <- "
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap');

body, .shiny-app-main { background-color: #070E1A !important; font-family: 'Poppins', sans-serif; }

/* Navbar */
.navbar { background-color: #101C2E !important; border-bottom: 1px solid #1e3a5f; }
.navbar-brand, .nav-link { color: #ffffff !important; font-family: 'Poppins', sans-serif; font-size: 0.9rem; }
.nav-link:hover, .nav-link.active { color: #C0392B !important; }

/* Contenido */
.page-content { background-color: #070E1A; min-height: 100vh; padding: 2rem 3rem; }

/* Títulos con borde rojo */
.page-title {
  color: #ffffff; font-weight: 800; font-size: 1.6rem;
  border-left: 6px solid #C0392B; padding-left: 14px;
  margin-bottom: 0.5rem; font-family: 'Poppins', sans-serif;
}
.page-title-main {
  color: #ffffff; font-weight: 800; font-size: 2.2rem;
  border-left: 6px solid #C0392B; padding-left: 16px;
  margin-top: 2rem; font-family: 'Poppins', sans-serif;
}
.page-subtitle { color: #94a3b8; font-size: 0.9rem; margin-bottom: 1.5rem; }
.page-text { color: #cbd5e1; font-size: 0.92rem; line-height: 1.8; text-align: justify; }

hr.section-hr { border-color: #1e3a5f; margin: 1.5rem 0; }

/* Cards */
.metric-card {
  background-color: #0D1B2E; border: 1px solid #1e3a5f;
  border-radius: 12px; padding: 1.2rem; text-align: center;
  margin-bottom: 1rem;
}
.metric-card h2 { font-weight: 800; font-family: 'Poppins', sans-serif; margin-bottom: 0.2rem; }
.metric-card p  { color: #94a3b8; font-size: 0.85rem; margin-bottom: 0; }

/* Collapsibles */
.collapsible-header {
  display: flex; align-items: center; gap: 0.8rem;
  padding: 1rem 1.2rem; background-color: #0D1B2E;
  border: 1px solid #1e3a5f; border-radius: 10px;
  cursor: pointer; margin-bottom: 0.5rem;
  color: #ffffff; font-weight: 600; font-size: 0.95rem;
  font-family: 'Poppins', sans-serif;
}
.collapsible-header:hover { border-color: #C0392B; }
.collapsible-body {
  padding: 1rem 1.2rem; background-color: #162032;
  border-left: 4px solid #C0392B; border-radius: 0 0 10px 10px;
  margin-top: -0.5rem; margin-bottom: 0.5rem;
  color: #cbd5e1; font-size: 0.92rem; line-height: 1.8;
}

/* Dropdowns */
.selectize-input { background-color: #0D1B2E !important; color: #cbd5e1 !important; border: 1px solid #1e3a5f !important; border-radius: 8px !important; font-family: 'Poppins', sans-serif; }
.selectize-dropdown { background-color: #0D1B2E !important; color: #cbd5e1 !important; border: 1px solid #1e3a5f !important; }
.selectize-dropdown .option:hover, .selectize-dropdown .active { background-color: #1e3a5f !important; }

/* Slider */
.irs--shiny .irs-bar { background: #C0392B; }
.irs--shiny .irs-handle { background: #C0392B; }
.irs--shiny .irs-from, .irs--shiny .irs-to, .irs--shiny .irs-single { background: #C0392B; }

/* DataTable */
table.dataTable { background-color: #0D1B2E !important; color: #cbd5e1 !important; font-family: 'Poppins', sans-serif; font-size: 0.85rem; }
table.dataTable thead th { background-color: #162032 !important; color: #ffffff !important; border: 1px solid #1e3a5f !important; }
table.dataTable tbody td { border: 1px solid #1e3a5f !important; }
table.dataTable tbody tr:nth-child(even) { background-color: #111827 !important; }
.dataTables_wrapper { color: #94a3b8; }
.dataTables_filter input { background-color: #0D1B2E; color: #cbd5e1; border: 1px solid #1e3a5f; border-radius: 6px; }
.dataTables_length select { background-color: #0D1B2E; color: #cbd5e1; border: 1px solid #1e3a5f; }

/* Badges */
.badge-binaria  { background-color: #C0392B; color: #fff; padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.badge-ordinal  { background-color: #2C3E6B; color: #fff; padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
.badge-continua { background-color: #E8A838; color: #fff; padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }

/* Modal */
.modal-content { background-color: #0D1B2E; border: 1px solid #1e3a5f; color: #ffffff; }
.modal-header { border-bottom: 1px solid #1e3a5f; }
.modal-footer { border-top: 1px solid #1e3a5f; }

/* Hallazgos síntesis */
.hallazgo-card {
  display: flex; padding: 1.2rem; background-color: #0D1B2E;
  border: 1px solid #1e3a5f; border-radius: 12px; margin-bottom: 0.8rem;
}
.hallazgo-bar { width: 4px; border-radius: 4px; flex-shrink: 0; margin-right: 1rem; align-self: stretch; }

/* Referencias */
.ref-row { display: flex; align-items: center; padding: 1rem 1.2rem; border-bottom: 1px solid #1e3a5f; }
.ref-num  { color: #FBF7F7; font-weight: 700; font-size: 0.9rem; flex-shrink: 0; margin-right: 1rem; width: 24px; }
.ref-title { color: #ffffff; font-weight: 600; font-size: 0.92rem; display: block; margin-bottom: 0.2rem; }
.ref-detail{ color: #94a3b8; font-size: 0.82rem; }
.ref-link  { color: #C0392B; font-weight: 700; font-size: 1rem; text-decoration: none; flex-shrink: 0; margin-left: 1rem; }

/* Alinear etiquetas de slider con el track real */
.irs--shiny .irs { padding: 0 !important; }
.irs--shiny .irs-line { margin: 0 !important; }
.slider-marks {
  display: flex;
  justify-content: space-between;
  padding: 0 7px;   /* compensa el radio del thumb (~7px) */
  margin-top: 2px;
}
.slider-marks span {
  flex: 1;
  text-align: center;
  font-size: 10px;
  color: #94a3b8;
  font-family: 'Poppins', sans-serif;
  line-height: 1.2;
}
.slider-marks span:first-child { text-align: left; }
.slider-marks span:last-child  { text-align: right; }
"

# ── UI ────────────────────────────────────────────────────────────────────────
ui <- page_navbar(
  title = "",
  id = "navbar",
  theme = bs_theme(
    bg = "#070E1A", fg = "#ffffff",
    primary = "#C0392B", secondary = "#1e3a5f",
    base_font = font_google("Poppins"),
    bootswatch = "darkly"
  ),
  header = tags$head(tags$style(HTML(css))),
  nav_panel("Inicio",       value = "home",         homeUI("home")),
  nav_panel("Objetivos",    value = "objetivos",    objetivosUI("objetivos")),
  nav_panel("Marco Teórico",value = "marco",        marcoTeoricoUI("marco")),
  nav_panel("Metodología",  value = "metodologia",  metodologiaUI("metodologia")),
  nav_panel("Carga",        value = "carga",        cargaUI("carga")),
  nav_panel("Limpieza",     value = "limpieza",     limpiezaUI("limpieza")),
  nav_panel("Resultados",   value = "resultados",   resultadosUI("resultados")),
  nav_panel("Síntesis",          value = "sintesis",   sintesisUI("sintesis")),
  nav_panel("Métricas",          value = "metricas",   metricasUI("metricas")),
  nav_panel("Modelo Predictivo", value = "modelo",     modeloUI("modelo")),
  nav_panel("Referencias",       value = "referencias",referenciasUI("referencias"))
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {
  homeServer("home")
  cargaServer("carga", df)
  limpiezaServer("limpieza", df)
  resultadosServer("resultados", df)
  sintesisServer("sintesis", df)
  metricasServer("metricas")
  modeloServer("modelo", df)
}

shinyApp(ui, server)
