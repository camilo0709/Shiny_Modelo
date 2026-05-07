library(xgboost)

# ── Colores ────────────────────────────────────────────────────────────────────
BG_PAGE_M   <- "#070E1A"
BG_CARD_M   <- "#0D1B2E"
BG_CARD_ALT_M <- "#111827"
BORDER_M    <- "#1e3a5f"
TEXT_PRI_M  <- "#ffffff"
TEXT_SEC_M  <- "#94a3b8"
ACCENT_M    <- "#C0392B"
GOLD_M      <- "#E8A838"
FONT_M      <- "'Poppins', sans-serif"

# ── Variables del modelo ───────────────────────────────────────────────────────
TOP_VARS <- c("HighBP", "GenHlth", "HighChol", "Age", "DiffWalk",
              "Sex", "Stroke", "Smoker", "Diabetes", "PhysHlth",
              "Income", "HvyAlcoholConsump")

VARS_META <- list(
  HighBP   = list(label = "Presión arterial alta",
                  type  = "radio",
                  choices = c("No" = 0, "Sí" = 1)),
  GenHlth  = list(label = "Estado de salud general autopercibido",
                  type  = "select",
                  min = 1, max = 5, step = 1,
                  marks = c("1" = "Excelente", "2" = "Muy bueno", "3" = "Bueno",
                            "4" = "Regular",   "5" = "Malo")),
  HighChol = list(label = "Colesterol alto",
                  type  = "radio",
                  choices = c("No" = 0, "Sí" = 1)),
  Age      = list(label = "Rango de edad",
                  type  = "select",
                  min = 1, max = 13, step = 1,
                  marks = c("1" = "18-24", "4" = "30-34", "7" = "45-49",
                            "10" = "60-64", "13" = "80+")),
  DiffWalk = list(label = "Dificultad para caminar o subir escaleras",
                  type  = "radio",
                  choices = c("No" = 0, "Sí" = 1)),
  Sex      = list(label = "Sexo biológico",
                  type  = "radio",
                  choices = c("Femenino" = 0, "Masculino" = 1)),
  Stroke   = list(label = "Antecedente de derrame cerebral",
                  type  = "radio",
                  choices = c("No" = 0, "Sí" = 1)),
  Smoker   = list(label = "Ha fumado 100 o más cigarrillos en su vida",
                  type  = "radio",
                  choices = c("No" = 0, "Sí" = 1)),
  Diabetes = list(label = "Condición de diabetes",
                  type  = "select",
                  min = 0, max = 2, step = 1,
                  marks = c("0" = "No", "1" = "Pre-diabetes", "2" = "Sí")),
  PhysHlth = list(label = "Días con mala salud física en los últimos 30 días",
                  type  = "select",
                  min = 0, max = 30, step = 1,
                  marks = c("0" = "0", "10" = "10", "20" = "20", "30" = "30")),
  Income   = list(label = "Nivel de ingreso anual",
                  type  = "select",
                  min = 1, max = 8, step = 1,
                  marks = c("1" = "<$10k", "3" = "<$25k", "5" = "<$50k", "8" = "$75k+")),
  HvyAlcoholConsump = list(label = "Consumo excesivo de alcohol",
                            type  = "radio",
                            choices = c("No" = 0, "Sí" = 1))
)

# ── Helper: construir un campo de entrada ─────────────────────────────────────
make_input_ui <- function(ns, var_id, meta) {
  label_ui <- tags$label(
    meta$label,
    style = paste0(
      "color:", TEXT_PRI_M, "; font-family:", FONT_M, "; font-size:12px;",
      "font-weight:600; margin-bottom:14px; display:block;",
      "text-transform:uppercase; letter-spacing:0.6px; line-height:1.4;"
    )
  )
  input_ui <- if (meta$type == "radio") {
    radioButtons(
      inputId  = ns(paste0("input_", var_id)),
      label    = NULL,
      choices  = meta$choices,
      selected = character(0),
      inline   = TRUE
    )
  } else if (meta$type == "select"){
    selectInput(
      inputId  = ns(paste0("input_", var_id)),
      label    = NULL,
      choices  = c("— Seleccionar —" = "", meta$choices),
      selected = ""
    )
  } else {
    sliderInput(
      inputId = ns(paste0("input_", var_id)),
      label   = NULL,
      min     = meta$min,
      max     = meta$max,
      step    = meta$step,
      value   = meta$min,
      ticks   = TRUE
    )
  }
  div(class = "col-md-6 col-lg-4 mb-3",
    div(style = paste0(
      "background-color:", BG_CARD_M, ";",
      "border:1px solid ", BORDER_M, ";",
      "border-radius:10px; padding:20px 22px; height:100%;"
    ),
    label_ui,
    input_ui
    )
  )
}

# ── UI ────────────────────────────────────────────────────────────────────────
modeloUI <- function(id) {
  ns <- NS(id)
  div(style = paste0("background-color:", BG_PAGE_M, "; padding:2rem 3rem; min-height:100vh;"),

    div(style = paste0(
      "border-left:4px solid ", ACCENT_M, "; padding-left:22px; margin-bottom:36px;"
    ),
    h2("Modelo Predictivo — XGBoost",
       style = paste0("color:", TEXT_PRI_M, "; font-family:", FONT_M, ";",
                      "font-weight:700; margin-bottom:10px;",
                      "font-size:22px; letter-spacing:0.3px;")),
    p("Complete los campos clínicos y sociodemográficos para obtener una estimación de la probabilidad de enfermedad cardíaca. El modelo fue entrenado con la encuesta BRFSS 2015 (253,680 registros) empleando las 12 variables de mayor relevancia predictiva (AUC = 0.84).",
      style = paste0("color:", TEXT_SEC_M, "; font-family:", FONT_M, ";",
                     "font-size:14px; max-width:860px; line-height:1.75; margin-bottom:0;"))
    ),

    p("Variables de entrada",
      style = paste0("color:", TEXT_SEC_M, "; font-family:", FONT_M, ";",
                     "font-size:10px; text-transform:uppercase; letter-spacing:2px;",
                     "margin-bottom:14px; font-weight:600;")),

    # Formulario
    div(class = "row",
      lapply(names(VARS_META), function(v) make_input_ui(ns, v, VARS_META[[v]]))
    ),

    # Advertencia campos vacíos
    uiOutput(ns("warning_empty")),

    # Botón
    div(class = "row",
      div(class = "col-md-4 offset-md-4 text-center mt-4 mb-2",
        actionButton(
          inputId = ns("btn_predict"),
          label   = "Ejecutar predicción",
          style   = paste0(
            "background-color:", ACCENT_M, "; border:none; border-radius:8px;",
            "padding:13px 0; font-size:13px; font-weight:700;",
            "font-family:", FONT_M, "; color:", TEXT_PRI_M, "; width:100%;",
            "letter-spacing:1.5px; text-transform:uppercase;"
          )
        )
      )
    ),

    # Instrucción / resultado
    div(
      id = ns("instruccion_msg"),
      "Haga clic en 'Ejecutar predicción' para visualizar el resultado.",
      style = paste0(
        "background-color:", BG_CARD_M, ";",
        "border:1px solid ", BORDER_M, ";",
        "border-left:3px solid #1e6a9e;",
        "border-radius:8px; color:", TEXT_SEC_M, ";",
        "font-family:", FONT_M, "; font-size:13px;",
        "padding:12px 18px; margin-top:10px; margin-bottom:10px; text-align:center;"
      )
    ),
    uiOutput(ns("resultado_prediccion"))
  )
}

# ── Server ────────────────────────────────────────────────────────────────────
modeloServer <- function(id, df_global) {
  moduleServer(id, function(input, output, session) {

    # Entrenar modelo (una sola vez)
    modelo_trained <- reactive({
      req(df_global)
      df <- df_global
      X  <- df[, TOP_VARS]
      y  <- df[["HeartDiseaseorAttack"]]

      set.seed(42)
      idx    <- sample(nrow(df), floor(0.8 * nrow(df)))
      X_tr   <- X[idx,  ];  y_tr <- y[idx]
      X_te   <- X[-idx, ];  y_te <- y[-idx]

      neg <- sum(y_tr == 0)
      pos <- sum(y_tr == 1)
      spw <- neg / pos

      dtrain <- xgb.DMatrix(data = as.matrix(X_tr), label = y_tr)

      model <- xgb.train(
        params = list(
          objective       = "binary:logistic",
          eval_metric     = "logloss",
          scale_pos_weight = spw,
          eta             = 0.05,
          max_depth       = 3,
          subsample       = 1.0,
          seed            = 42
        ),
        data    = dtrain,
        nrounds = 100,
        verbose = 0
      )
      model
    })

    output$warning_empty <- renderUI({ NULL })

    observeEvent(input$btn_predict, {

      values <- lapply(names(VARS_META), function(v) {
        val <- input[[paste0("input_", v)]]
        if (is.null(val) || length(val) == 0) NA else as.numeric(val)
      })
      names(values) <- names(VARS_META)

      missing_labels <- names(which(sapply(values, is.na)))

      if (length(missing_labels) > 0) {
        labels_faltantes <- sapply(missing_labels, function(v) VARS_META[[v]]$label)
        output$warning_empty <- renderUI({
          div(
            paste0("Complete los siguientes campos antes de continuar: ",
                   paste(labels_faltantes, collapse = ", "), "."),
            style = paste0(
              "background-color:#1a0505; border:1px solid ", ACCENT_M, ";",
              "border-radius:8px; color:#e87070;",
              "font-family:", FONT_M, "; font-size:13px;",
              "padding:13px 18px; line-height:1.6;"
            )
          )
        })
        output$resultado_prediccion <- renderUI({ NULL })
        return()
      }

      output$warning_empty <- renderUI({ NULL })

      row_vals <- as.numeric(unlist(values))
      names(row_vals) <- names(VARS_META)
      df_in <- matrix(row_vals, nrow = 1, dimnames = list(NULL, names(row_vals)))
      dtest <- xgb.DMatrix(data = df_in)

      prob     <- predict(modelo_trained(), dtest)
      prob_pct <- round(prob * 100, 1)

      if (prob < 0.30) {
        nivel       <- "BAJO"
        color_nivel <- "#27AE60"
      } else if (prob < 0.55) {
        nivel       <- "MODERADO"
        color_nivel <- "#E67E22"
      } else {
        nivel       <- "ALTO"
        color_nivel <- ACCENT_M
      }

      # ── Gauge ──────────────────────────────────────────────────────────────
      fig_gauge <- plot_ly(
        type  = "indicator",
        mode  = "gauge+number",
        value = prob_pct,
        number = list(suffix = "%",
                      font   = list(size = 46, color = color_nivel, family = FONT_M)),
        gauge = list(
          axis  = list(range = list(0, 100), tickwidth = 1, tickcolor = BORDER_M,
                       tickfont = list(color = TEXT_SEC_M, size = 11, family = FONT_M)),
          bar   = list(color = color_nivel, thickness = 0.28),
          bgcolor    = BG_CARD_ALT_M,
          borderwidth = 0,
          steps = list(
            list(range = c(0,  30),  color = "#071410"),
            list(range = c(30, 55),  color = "#141007"),
            list(range = c(55, 100), color = "#140707")
          ),
          threshold = list(
            line      = list(color = color_nivel, width = 3),
            thickness = 0.8,
            value     = prob_pct
          )
        ),
        title = list(text = "Probabilidad estimada de enfermedad cardíaca",
                     font = list(size = 12, color = TEXT_SEC_M, family = FONT_M))
      ) |>
        layout(
          height        = 270,
          margin        = list(l = 30, r = 30, t = 60, b = 10),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)"
        )

      # ── Barras contribución relativa ────────────────────────────────────────
      factor_risk <- c(
        "Presión arterial alta"       = row_vals["HighBP"]   * 0.18,
        "Salud general autopercibida" = (row_vals["GenHlth"] - 1) / 4 * 0.16,
        "Colesterol alto"             = row_vals["HighChol"] * 0.14,
        "Rango de edad"               = (row_vals["Age"] - 1) / 12 * 0.13,
        "Dificultad al caminar"       = row_vals["DiffWalk"] * 0.11,
        "Antecedente de derrame"      = row_vals["Stroke"]   * 0.10,
        "Condición de diabetes"       = row_vals["Diabetes"] / 2 * 0.09,
        "Días con mala salud física"  = row_vals["PhysHlth"] / 30 * 0.09
      )
      factor_risk <- sort(factor_risk, decreasing = TRUE)
      max_val     <- max(factor_risk)
      if (max_val == 0) max_val <- 1
      bar_colors  <- ifelse(factor_risk >= max_val * 0.6, ACCENT_M, BORDER_M)

      fig_bar <- plot_ly(
        x           = unname(factor_risk),
        y           = names(factor_risk),
        type        = "bar",
        orientation = "h",
        marker      = list(color = bar_colors),
        hovertemplate = "%{y}: %{x:.3f}<extra></extra>"
      ) |>
        layout(
          title        = list(text = "Contribución relativa por factor de riesgo",
                              font = list(size = 12, color = TEXT_SEC_M, family = FONT_M)),
          xaxis        = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
          yaxis        = list(autorange = "reversed", color = TEXT_SEC_M,
                              tickfont = list(family = FONT_M, size = 12)),
          height        = 290,
          margin        = list(l = 10, r = 20, t = 50, b = 20),
          paper_bgcolor = "rgba(0,0,0,0)",
          plot_bgcolor  = "rgba(0,0,0,0)",
          font          = list(color = TEXT_SEC_M, size = 12, family = FONT_M)
        )

      output$resultado_prediccion <- renderUI({
        div(
          # Banner nivel
          div(style = paste0(
            "display:flex; align-items:center;",
            "background-color:", BG_CARD_M, ";",
            "border:1px solid ", BORDER_M, ";",
            "border-top:3px solid ", color_nivel, ";",
            "border-radius:10px; padding:22px 32px; margin-bottom:16px;"
          ),
          div(style = paste0("flex:1; border-right:1px solid ", BORDER_M, "; padding-right:32px;"),
            span("NIVEL DE RIESGO",
                 style = paste0("color:", TEXT_SEC_M, "; font-family:", FONT_M, ";",
                                "font-size:10px; letter-spacing:1.8px; font-weight:600;",
                                "text-transform:uppercase; display:block; margin-bottom:6px;")),
            span(nivel,
                 style = paste0("color:", color_nivel, "; font-family:", FONT_M, ";",
                                "font-size:26px; font-weight:800; letter-spacing:3px;"))
          ),
          div(style = "flex:1; padding-left:32px;",
            span("PROBABILIDAD ESTIMADA",
                 style = paste0("color:", TEXT_SEC_M, "; font-family:", FONT_M, ";",
                                "font-size:10px; letter-spacing:1.8px; font-weight:600;",
                                "text-transform:uppercase; display:block; margin-bottom:6px;")),
            span(paste0(prob_pct, "%"),
                 style = paste0("color:", color_nivel, "; font-family:", FONT_M, ";",
                                "font-size:26px; font-weight:800;"))
          )
          ),

          # Gráficas
          div(class = "row g-3",
            div(class = "col-md-5 mb-3",
              div(style = paste0("background-color:", BG_CARD_M, ";",
                                 "border:1px solid ", BORDER_M, ";",
                                 "border-radius:10px; padding:8px;"),
                plotlyOutput(session$ns("gauge_plot"), height = "270px")
              )
            ),
            div(class = "col-md-7 mb-3",
              div(style = paste0("background-color:", BG_CARD_M, ";",
                                 "border:1px solid ", BORDER_M, ";",
                                 "border-radius:10px; padding:8px;"),
                plotlyOutput(session$ns("bar_plot"), height = "290px")
              )
            )
          ),

          # Nota metodológica
          p("Nota metodológica: Esta herramienta tiene fines académicos e ilustrativos. La probabilidad se estima a partir de un modelo XGBoost entrenado sobre datos poblacionales de la encuesta BRFSS 2015 y no constituye un diagnóstico clínico.",
            style = paste0("color:", TEXT_SEC_M, "; font-family:", FONT_M, ";",
                           "font-size:12px; margin-top:8px; line-height:1.65;",
                           "border-top:1px solid ", BORDER_M, ";",
                           "padding-top:16px; margin-bottom:30px;"))
        )
      })

      output$gauge_plot <- renderPlotly({ fig_gauge })
      output$bar_plot   <- renderPlotly({ fig_bar })

    })
  })
}
