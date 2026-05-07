referencias_data <- list(
  list(titulo="Heart Disease Health Indicators Dataset — BRFSS 2015",
    detalle="Alex Teboul · Kaggle · 2022",
    url="https://www.kaggle.com/datasets/alexteboul/heart-disease-health-indicators-dataset/data"),
  list(titulo="Behavioral Risk Factor Surveillance System (BRFSS) — 2015",
    detalle="Centers for Disease Control and Prevention (CDC) · 2015",
    url="https://www.cdc.gov/brfss/annual_data/annual_2015.html"),
  list(titulo="Heart Disease Facts",
    detalle="Centers for Disease Control and Prevention (CDC) · 2023",
    url="https://www.cdc.gov/heartdisease/facts.htm"),
  list(titulo="Exploratory Data Analysis",
    detalle="John W. Tukey · Addison-Wesley Publishing Company · 1977",
    url="https://www.worldcat.org/title/exploratory-data-analysis/oclc/3058187"),
  list(titulo="Heart Failure: Pathophysiology and Diagnosis",
    detalle="Braunwald, E. · Journal of Internal Medicine · 2013",
    url="https://pubmed.ncbi.nlm.nih.gov/23121664/"),
  list(titulo="Plotly r graphing library in R",
    detalle="Copyright © 2026 Plotly. All rights reserved.",
    url="https://plotly.com/r/"),
  list(titulo="Welcome to Shiny - Posit",
    detalle="Proudly supported by Posit",
    url="https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/"),
  list(titulo="A Grammar of Data Manipulation • dplyr",
    detalle="Developed by Hadley Wickham, Romain François, Lionel Henry, Kirill Müller, Davis Vaughan, Posit.",
    url="https://dplyr.tidyverse.org"),
  # ── Nuevas referencias: métricas y modelos ──────────────────────────────────
  list(titulo="Americans under 55 dying of severe heart attacks",
    detalle="American Heart Association · Journal of the American Heart Association · 2024",
    url="https://www.ahajournals.org"),
  list(titulo="Heart disease risk factors",
    detalle="National Heart, Lung, and Blood Institute · s.f.",
    url="https://www.nhlbi.nih.gov"),
  list(titulo="Insuficiencia cardíaca",
    detalle="MSD Manuals · s.f.",
    url="https://www.msdmanuals.com/es/hogar/trastornos-del-corazon"),
  list(titulo="¿Qué es el algoritmo de k vecinos más cercanos (KNN)?",
    detalle="IBM · s.f.",
    url="https://www.ibm.com/mx-es/think/topics/knn"),
  list(titulo="¿Qué es un Random Forest?",
    detalle="IBM · s.f.",
    url="https://www.ibm.com/mx-es/think/topics/random-forest"),
  list(titulo="¿Qué es una Máquina de Vectores de Soporte (SVM)?",
    detalle="IBM · s.f.",
    url="https://www.ibm.com/es-es/think/topics/support-vector-machine"),
  list(titulo="¿Qué es la Regresión Logística?",
    detalle="IBM · s.f.",
    url="https://www.ibm.com/es-es/think/topics/logistic-regression"),
  list(titulo="¿Qué es XGBoost?",
    detalle="IBM · s.f.",
    url="https://www.ibm.com/es-es/think/topics/xgboost"),
  list(titulo="Clasificación con datos desbalanceados",
    detalle="Aprende Machine Learning · s.f.",
    url="https://www.aprendemachinelearning.com/clasificacion-con-datos-desbalanceados/"),
  list(titulo="Validación cruzada K-fold estratificada",
    detalle="GeeksforGeeks · 2025",
    url="https://www.geeksforgeeks.org/stratified-k-fold-cross-validation/"),
  list(titulo="¿Qué es un pipeline de machine learning?",
    detalle="IBM · s.f.",
    url="https://www.ibm.com/es-es/think/topics/machine-learning-pipeline"),
  list(titulo="AUC y la curva ROC en aprendizaje automático",
    detalle="DataCamp · 2024",
    url="https://www.datacamp.com/tutorial/auc"),
  list(titulo="Threshold tuning and monitoring",
    detalle="IBM · 2026",
    url="https://www.ibm.com/docs/en/omegamon-for-storage"),
  list(titulo="SciPy: Open Source Scientific Tools for Python",
    detalle="Virtanen, P. et al. · Nature Methods · 2020",
    url="https://scipy.org/"),
  list(titulo="Ataque cardíaco: Información general",
    detalle="Texas Heart Institute · s.f.",
    url="https://www.texasheart.org/heart-health/heart-information-center/topics/ataque-cardiaco/")
)

referenciasUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Referencias", class="page-title"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row mb-5",
      div(class="col-12",
        div(style="border-radius:12px; overflow:hidden; border:1px solid #1e3a5f;",
          lapply(seq_along(referencias_data), function(i) {
            ref <- referencias_data[[i]]
            div(class="ref-row",
              style=if(i %% 2 == 1) "background-color:#0D1B2E;" else "background-color:#111827;",
              span(paste0(i, "."), class="ref-num"),
              div(style="flex-grow:1;",
                span(ref$titulo, class="ref-title"),
                span(ref$detalle, class="ref-detail")
              ),
              tags$a("→", href=ref$url, target="_blank", class="ref-link")
            )
          })
        )
      )
    )
  )
}
