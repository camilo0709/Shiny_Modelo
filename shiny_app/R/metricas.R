library(plotly)

# ── Datos ─────────────────────────────────────────────────────────────────────
modelos_df <- data.frame(
  Modelo     = c("XGBoost", "Random Forest", "Logistic Reg.", "KNeighbors", "Linear SVC"),
  Accuracy   = c(0.7351, 0.7237, 0.7502, 0.8815, 0.9070),
  Precision  = c(0.2376, 0.2288, 0.2458, 0.2944, 0.5262),
  Recall     = c(0.8209, 0.8157, 0.7991, 0.1846, 0.1241),
  F1         = c(0.3686, 0.3574, 0.3760, 0.2269, 0.2008),
  AUC_ROC    = c(0.8483, 0.8373, 0.8459, 0.6690, 0.8460),
  Recall_CV  = c(0.8197, 0.8102, 0.7960, 0.1947, 0.1290),
  stringsAsFactors = FALSE
)
modelos_df <- modelos_df[order(-modelos_df$Recall), ]
reduccion_df <- data.frame(
  Modelo     = c("XGBoost completo (21 vars)", "XGBoost reducido A (16 vars)", "XGBoost reducido B (12 vars)"),
  Variables  = c(21, 16, 12),
  Recall     = c(0.8209, 0.8209, 0.8223),
  Precision  = c(0.2376, 0.2376, 0.2376),
  F1         = c(0.3686, 0.3686, 0.3687),
  AUC_ROC    = c(0.8483, 0.8483, 0.8482),
  stringsAsFactors = FALSE
)

vars_imp0    <- c("Veggies", "PhysActivity", "Fruits", "Education", "AnyHealthcare")
vars_imp003  <- c("CholCheck", "BMI", "NoDocbcCost", "MentHlth")
vars_finales <- c("HighBP", "GenHlth", "HighChol", "Age", "DiffWalk",
                  "Sex", "Stroke", "Smoker", "Diabetes", "PhysHlth",
                  "Income", "HvyAlcoholConsump")

# ── Colores ────────────────────────────────────────────────────────────────────
BG_CARD     <- "#0D1B2E"
BG_CARD_ALT <- "#111827"
BORDER      <- "#1e3a5f"
TEXT_PRI    <- "#ffffff"
TEXT_SEC    <- "#94a3b8"
TEXT_MUT    <- "#cbd5e1"
ACCENT      <- "#C0392B"
GOLD        <- "#E8A838"
BLUE        <- "#2C3E6B"

# ── Gráfica 1: Recall y AUC-ROC por modelo ───────────────────────────────────
bar_colors <- ifelse(modelos_df$Modelo == "XGBoost", ACCENT, BLUE)

fig_comp <- plot_ly() |>
  add_bars(
    x = modelos_df$Modelo,
    y = modelos_df$Recall,
    name = "Recall",
    marker = list(color = bar_colors),
    text  = sprintf("%.3f", modelos_df$Recall),
    textposition = "outside",
    textfont = list(color = TEXT_MUT, size = 11)
  ) |>
  add_trace(
    x = modelos_df$Modelo,
    y = modelos_df$AUC_ROC,
    name  = "AUC-ROC",
    type  = "scatter",
    mode  = "lines+markers",
    line  = list(color = GOLD, width = 2),
    marker= list(color = GOLD, size = 8),
    yaxis = "y2"
  ) |>
  layout(
    paper_bgcolor = BG_CARD,
    plot_bgcolor  = BG_CARD,
    font  = list(color = TEXT_MUT, family = "Poppins", size = 12),
    title = list(text = "Recall y AUC-ROC por modelo",
                 font = list(color = TEXT_PRI, size = 14, family = "Poppins"), x = 0),
    xaxis = list(gridcolor = BORDER, color = TEXT_SEC,categoryorder = 'array', categoryarray = modelos_df$Modelo),
    yaxis = list(gridcolor = BORDER, color = TEXT_SEC, title = "Recall", range = c(0, 1.15)),
    yaxis2= list(overlaying = "y", side = "right", color = GOLD,
                 title = "AUC-ROC", range = c(0.5, 1.0), showgrid = FALSE),
    legend= list(bgcolor = BG_CARD, bordercolor = BORDER, borderwidth = 1,
                 font = list(color = TEXT_MUT)),
    height= 380,
    margin= list(t = 50, b = 50, l = 50, r = 30),
    barmode = "group"
  )

# ── Gráfica 2: Reducción de variables ────────────────────────────────────────
pal <- c(ACCENT, GOLD, "#4A6FA5")
metricas_red <- c("Recall", "F1", "AUC_ROC")
labels_red   <- c("Recall", "F1", "AUC-ROC")

fig_red <- plot_ly()
for (i in seq_along(metricas_red)) {
  fig_red <- fig_red |>
    add_bars(
      x    = reduccion_df$Modelo,
      y    = reduccion_df[[metricas_red[i]]],
      name = labels_red[i],
      marker = list(color = pal[i]),
      text   = sprintf("%.4f", reduccion_df[[metricas_red[i]]]),
      textposition = "outside",
      textfont = list(color = TEXT_MUT, size = 10)
    )
}
fig_red <- fig_red |>
  layout(
    paper_bgcolor = BG_CARD,
    plot_bgcolor  = BG_CARD,
    font  = list(color = TEXT_MUT, family = "Poppins", size = 12),
    title = list(text = "Comparacion de versiones XGBoost por numero de variables",
                 font = list(color = TEXT_PRI, size = 14, family = "Poppins"), x = 0),
    xaxis = list(gridcolor = BORDER, color = TEXT_SEC),
    yaxis = list(gridcolor = BORDER, color = TEXT_SEC, title = "Metrica", range = c(0, 1.1)),
    legend= list(bgcolor = BG_CARD, bordercolor = BORDER, borderwidth = 1,
                 font = list(color = TEXT_MUT)),
    barmode = "group",
    height  = 380,
    margin  = list(t = 50, b = 50, l = 50, r = 30)
  )

# ── Helper: tarjeta de métrica ────────────────────────────────────────────────
metric_card_ui <- function(label, value, highlight = FALSE) {
  border_color <- if (highlight) ACCENT else BORDER
  div(class = "col-md-3",
    div(class = "metric-card",
      style = paste0(
        "background-color:", BG_CARD, ";",
        "border:1px solid ", border_color, ";",
        "border-radius:12px; padding:1.2rem; text-align:center; margin-bottom:1rem;"
      ),
      p(label, style = paste0(
        "color:", TEXT_SEC, "; font-size:0.78rem; font-family:'Poppins',sans-serif;",
        "margin-bottom:0.4rem; text-transform:uppercase; letter-spacing:0.8px;"
      )),
      h4(value, style = paste0(
        "color:", TEXT_PRI, "; font-weight:800; font-family:'Poppins',sans-serif; margin-bottom:0;"
      ))
    )
  )
}

# ── Helper: badge de variable ─────────────────────────────────────────────────
var_badge <- function(v, highlight = FALSE) {
  bg  <- if (highlight) "#0d2137" else BG_CARD_ALT
  clr <- if (highlight) TEXT_PRI  else TEXT_SEC
  fw  <- if (highlight) "600"     else "400"
  span(v, style = paste0(
    "background-color:", bg, ";",
    "border:1px solid ", BORDER, ";",
    "border-radius:", if (highlight) "6px" else "4px", ";",
    "color:", clr, ";",
    "font-family:'Poppins',sans-serif;",
    "font-size:", if (highlight) "13px" else "12px", ";",
    "font-weight:", fw, ";",
    "padding:", if (highlight) "10px 12px" else "3px 10px", ";",
    "margin-right:6px; margin-bottom:6px; display:inline-block;"
  ))
}

# ── UI ────────────────────────────────────────────────────────────────────────
metricasUI <- function(id) {
  ns <- NS(id)
  div(class = "page-content",

    # Encabezado
    div(class = "row mt-4",
      div(class = "col-12",
        h1("Selección y evaluación del modelo", class = "page-title"),
        p("Comparación de cinco algoritmos de clasificación y justificación de la selección del modelo XGBoost con 12 variables.",
          class = "page-subtitle", style = "margin-bottom:0;"),
        tags$hr(class = "section-hr")
      )
    ),

    # ── SECCIÓN 1: Comparación de modelos ─────────────────────────────────────
    div(class = "row",
      div(class = "col-12",
        h4("1. Comparación de modelos",
           style = paste0("color:", TEXT_PRI, "; font-family:'Poppins',sans-serif;",
                          "font-weight:700; margin-bottom:0.3rem;")),
        p("Se entrenaron cinco algoritmos con validación cruzada estratificada (5 folds), aplicando ajuste de pesos de clase para compensar el desbalance de clases (90.6% vs 9.4%). El criterio principal de selección fue el Recall sobre la clase positiva, dado que en un contexto clínico es preferible minimizar los falsos negativos.",
          class = "page-subtitle", style = "margin-bottom:1.5rem;")
      )
    ),

    # Tarjetas métricas XGBoost
    div(class = "row",
      metric_card_ui("Recall",    "0.8209", highlight = TRUE),
      metric_card_ui("AUC-ROC",   "0.8483"),
      metric_card_ui("F1-Score",  "0.3686"),
      metric_card_ui("Recall CV", "0.8197")
    ),

    # Tabla comparativa
    div(class = "row mb-4",
      div(class = "col-12",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-radius:12px; padding:1rem;"),
          DT::dataTableOutput(ns("tabla_modelos"))
        )
      )
    ),

    # Gráfica + justificación
    div(class = "row mb-5",
      div(class = "col-md-8",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-radius:12px; padding:1rem;"),
          plotlyOutput(ns("fig_comp"), height = "380px")
        )
      ),
      div(class = "col-md-4",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-radius:12px; padding:1.2rem; height:100%;"),
          h6("¿Por qué XGBoost?",
             style = paste0("color:", TEXT_PRI, "; font-family:'Poppins',sans-serif;",
                            "font-weight:700; margin-bottom:1rem;",
                            "border-bottom:1px solid ", BORDER, "; padding-bottom:0.5rem;")),
          p("XGBoost obtuvo el Recall más alto (0.8209) junto con el AUC-ROC más elevado (0.8483), lo que lo posiciona como el modelo con mayor capacidad para detectar casos reales de enfermedad cardíaca.",
            class = "page-text", style = "margin-bottom:1rem;"),
          p("KNeighbors y Linear SVC alcanzaron una Accuracy superior (0.88 y 0.91), pero con un Recall de apenas 0.18 y 0.12 respectivamente, lo que significa que detectan menos de 1 de cada 5 casos positivos. En un contexto clínico, esta métrica es inaceptable.",
            class = "page-text", style = "margin-bottom:1rem;"),
          p("Logistic Regression obtuvo un F1 ligeramente superior (0.376 vs 0.369), pero un AUC-ROC y Recall CV inferiores, lo que indica menor estabilidad en validación cruzada.",
            class = "page-text", style = "margin-bottom:0;")
        )
      )
    ),

    tags$hr(class = "section-hr"),

    # ── SECCIÓN 2: Reducción de variables ─────────────────────────────────────
    div(class = "row",
      div(class = "col-12",
        h4("2. Reducción a 12 variables",
           style = paste0("color:", TEXT_PRI, "; font-family:'Poppins',sans-serif;",
                          "font-weight:700; margin-bottom:0.3rem;")),
        p("Con el objetivo de construir un modelo más parsimonioso sin sacrificar capacidad predictiva, se analizó la importancia de variables del XGBoost entrenado con las 21 variables del dataset.",
          class = "page-subtitle", style = "margin-bottom:1.5rem;")
      )
    ),

    # Cards variables eliminadas
    div(class = "row",
      div(class = "col-md-6 mb-3",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-left:3px solid ", BORDER, "; border-radius:12px; padding:1.2rem;"),
          p("IMPORTANCIA = 0",
            style = paste0("color:", TEXT_SEC, "; font-size:10px; letter-spacing:1.5px;",
                           "font-family:'Poppins',sans-serif; font-weight:600;",
                           "text-transform:uppercase; margin-bottom:12px;")),
          p("El algoritmo no las utilizó en ningún árbol de decisión durante el entrenamiento.",
            style = paste0("color:", TEXT_MUT, "; font-family:'Poppins',sans-serif;",
                           "font-size:12px; margin-bottom:12px;")),
          div(lapply(vars_imp0, var_badge))
        )
      ),
      div(class = "col-md-6 mb-3",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-left:3px solid ", BORDER, "; border-radius:12px; padding:1.2rem;"),
          p("IMPORTANCIA < 0.003",
            style = paste0("color:", TEXT_SEC, "; font-size:10px; letter-spacing:1.5px;",
                           "font-family:'Poppins',sans-serif; font-weight:600;",
                           "text-transform:uppercase; margin-bottom:12px;")),
          p("Contribución marginal al poder predictivo del modelo.",
            style = paste0("color:", TEXT_MUT, "; font-family:'Poppins',sans-serif;",
                           "font-size:12px; margin-bottom:12px;")),
          div(lapply(vars_imp003, var_badge))
        )
      )
    ),

    # Gráfica reducción + resultado
    div(class = "row mb-4",
      div(class = "col-md-7",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-radius:12px; padding:1rem;"),
          plotlyOutput(ns("fig_red"), height = "380px")
        )
      ),
      div(class = "col-md-5",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-radius:12px; padding:1.2rem; height:100%;"),
          h6("Resultado de la comparación",
             style = paste0("color:", TEXT_PRI, "; font-family:'Poppins',sans-serif;",
                            "font-weight:700; margin-bottom:1rem;",
                            "border-bottom:1px solid ", BORDER, "; padding-bottom:0.5rem;")),
          p("Las tres versiones del modelo obtuvieron métricas prácticamente idénticas: Recall de 0.8209, 0.8209 y 0.8223 respectivamente, y AUC-ROC de 0.8483, 0.8483 y 0.8482.",
            class = "page-text", style = "margin-bottom:1rem;"),
          p("Esto confirma que las 9 variables eliminadas no aportaban información predictiva relevante. Se seleccionó el modelo reducido B como modelo final por ser el más simple, interpretable y eficiente.",
            class = "page-text", style = "margin-bottom:0;")
        )
      )
    ),

    # Variables finales seleccionadas
    div(class = "row mb-5",
      div(class = "col-12",
        div(style = paste0("background-color:", BG_CARD, "; border:1px solid ", BORDER,
                           "; border-left:3px solid ", ACCENT, "; border-radius:12px; padding:1.2rem;"),
          p("12 VARIABLES SELECCIONADAS",
            style = paste0("color:", TEXT_SEC, "; font-size:10px; letter-spacing:1.5px;",
                           "font-family:'Poppins',sans-serif; font-weight:600;",
                           "text-transform:uppercase; margin-bottom:14px;")),
          div(lapply(vars_finales, function(v) var_badge(v, highlight = TRUE)))
        )
      )
    )

  )
}

# ── Server ────────────────────────────────────────────────────────────────────
metricasServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$fig_comp <- renderPlotly({ fig_comp })

    output$fig_red  <- renderPlotly({ fig_red })

    output$tabla_modelos <- DT::renderDataTable({
      display <- modelos_df
      names(display)[names(display) == "AUC_ROC"]   <- "AUC-ROC"
      names(display)[names(display) == "Recall_CV"]  <- "Recall CV"
      DT::datatable(
        display,
        rownames  = FALSE,
        options   = list(
          dom       = "t",
          ordering  = FALSE,
          pageLength = 10
        )
      ) |>
        DT::formatStyle(
          "Modelo",
          target = "row",
          backgroundColor = DT::styleEqual("XGBoost", ACCENT)
        )
    })

  })
}
