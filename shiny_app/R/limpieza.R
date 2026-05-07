rangos_esp <- list(
  HeartDiseaseorAttack=c(0,1), HighBP=c(0,1), HighChol=c(0,1), CholCheck=c(0,1),
  BMI=c(12,98), Smoker=c(0,1), Stroke=c(0,1), Diabetes=c(0,2), PhysActivity=c(0,1),
  Fruits=c(0,1), Veggies=c(0,1), HvyAlcoholConsump=c(0,1), AnyHealthcare=c(0,1),
  NoDocbcCost=c(0,1), GenHlth=c(1,5), MentHlth=c(0,30), PhysHlth=c(0,30),
  DiffWalk=c(0,1), Sex=c(0,1), Age=c(1,13), Education=c(1,6), Income=c(1,8)
)

interpretaciones_out <- list(
  BMI = "Se detectaron 9.847 valores atípicos (3.88%). Los valores extremos superiores llegan hasta 98, correspondientes a casos de obesidad mórbida severa, y los inferiores hasta 12, casos raros de desnutrición extrema. Se conservan sin modificación.",
  MentHlth = "Presenta un alto porcentaje de datos atípicos (14.27%) debido a su distribución extremadamente asimétrica con mediana igual a 0. El IQR es muy pequeño (2 días). Valores como 10, 15 o 30 días son respuestas legítimas y se conservan sin tratamiento.",
  PhysHlth = "Similar a MentHlth, el porcentaje de atípicos es alto (16.14%) con distribución muy asimétrica y mediana igual a 0. El IQR es de apenas 3 días. Se conservan sin tratamiento ya que son respuestas válidas de la encuesta."
)

limpiezaUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Limpieza del Dataset", class="page-title"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row",
      div(class="col-md-3", div(class="metric-card", h2("0", style="color:#F8F3F2;"), p("valores nulos"))),
      div(class="col-md-3", div(class="metric-card", h2("23.899", style="color:#F9F3F3;"), p("registros duplicados"))),
      div(class="col-md-3", div(class="metric-card", h2("9.42%", style="color:#EDEAEA;"), p("duplicados del total"))),
      div(class="col-md-3", div(class="metric-card", h2("22 / 22", style="color:#F5F4F4;"), p("variables en rango esperado")))
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-4",
      div(class="col-12",
        h4("Valores nulos y duplicados", style="color:#fff; font-weight:700; margin-bottom:1rem;"),
        p(class="page-text",
          "El dataset no presenta ningún valor nulo en sus 22 variables. En cuanto a los 23.899 registros duplicados (9.42%), se tomó la decisión de mantenerlos. Al tratarse de una encuesta poblacional con mayoría de variables binarias, es estadísticamente esperable que múltiples individuos compartan exactamente el mismo perfil de respuestas sin que esto represente un error de captura.")
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-4",
      div(class="col-12",
        h4("Verificación de rangos esperados", style="color:#fff; font-weight:700; margin-bottom:1rem;"),
        div(class="row",
          div(class="col-md-4",
            selectInput(ns("var_rango"), NULL, choices=names(rangos_esp), selected="HeartDiseaseorAttack")
          ),
          div(class="col-md-8", uiOutput(ns("rango_resultado")))
        )
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row",
      div(class="col-12",
        h4("Análisis de datos atípicos", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("Aplica únicamente a BMI, MentHlth y PhysHlth. Criterio de Tukey: atípico si cae fuera de Q1 − 1.5·IQR o Q3 + 1.5·IQR.",
          class="page-subtitle")
      )
    ),
    div(class="row",
      div(class="col-md-4", div(class="metric-card",
        h6("BMI", style="color:#C0392B; font-weight:700; text-align:center;"),
        uiOutput(ns("card_bmi"))
      )),
      div(class="col-md-4", div(class="metric-card",
        h6("MentHlth", style="color:#2C3E6B; font-weight:700; text-align:center;"),
        uiOutput(ns("card_ment"))
      )),
      div(class="col-md-4", div(class="metric-card",
        h6("PhysHlth", style="color:#E8A838; font-weight:700; text-align:center;"),
        uiOutput(ns("card_phys"))
      ))
    ),
    div(class="row mb-4",
      div(class="col-12", plotlyOutput(ns("boxplot_cont"), height="480px"))
    ),
    div(class="row mb-5",
      div(class="col-12",
        h5("Interpretación por variable", style="color:#fff; font-weight:600; margin-bottom:1rem;"),
        div(class="row",
          div(class="col-md-4",
            selectInput(ns("var_interp"), NULL, choices=c("BMI","MentHlth","PhysHlth"), selected="BMI")
          )
        ),
        uiOutput(ns("interp_outlier"))
      )
    )
  )
}

limpiezaServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {

    get_outlier_info <- function(col) {
      q1  <- quantile(df[[col]], 0.25)
      q3  <- quantile(df[[col]], 0.75)
      iqr <- q3 - q1
      lo  <- q1 - 1.5 * iqr
      hi  <- q3 + 1.5 * iqr
      n_out <- sum(df[[col]] < lo | df[[col]] > hi)
      list(n=n_out, pct=round(n_out/nrow(df)*100, 2))
    }

    bmi_info  <- get_outlier_info("BMI")
    ment_info <- get_outlier_info("MentHlth")
    phys_info <- get_outlier_info("PhysHlth")

    output$card_bmi  <- renderUI(tagList(
      p(paste(format(bmi_info$n,  big.mark=","), "outliers"), style="color:#fff; font-size:0.85rem; margin-bottom:0.2rem; text-align:center;"),
      p(paste0(bmi_info$pct,  "% del total"), style="color:#94a3b8; font-size:0.82rem; text-align:center;")
    ))
    output$card_ment <- renderUI(tagList(
      p(paste(format(ment_info$n, big.mark=","), "outliers"), style="color:#fff; font-size:0.85rem; margin-bottom:0.2rem; text-align:center;"),
      p(paste0(ment_info$pct, "% del total"), style="color:#94a3b8; font-size:0.82rem; text-align:center;")
    ))
    output$card_phys <- renderUI(tagList(
      p(paste(format(phys_info$n, big.mark=","), "outliers"), style="color:#fff; font-size:0.85rem; margin-bottom:0.2rem; text-align:center;"),
      p(paste0(phys_info$pct, "% del total"), style="color:#94a3b8; font-size:0.82rem; text-align:center;")
    ))

    output$boxplot_cont <- renderPlotly({
      cols   <- c("BMI","MentHlth","PhysHlth")
      colors <- c("#C0392B","#2C3E6B","#E8A838")
      fig <- plot_ly()
      for (i in seq_along(cols)) {
        fig <- fig |> add_trace(
          y=df[[cols[i]]], type="box", name=cols[i],
          marker=list(color=colors[i], size=4, opacity=0.7, outliercolor=colors[i]),
          line=list(color=colors[i], width=2),
          fillcolor="rgba(13,27,46,0.8)", boxpoints="outliers"
        )
      }
      fig |> layout(
        paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",
        font=list(color="#cbd5e1", family="Poppins", size=12),
        title=list(text="Distribución de variables continuas", font=list(color="#ffffff", size=14), x=0),
        yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", zeroline=FALSE),
        xaxis=list(color="#94a3b8", showgrid=FALSE),
        margin=list(t=50, b=40, l=50, r=30),
        showlegend=TRUE,
        legend=list(bgcolor="#0D1B2E", bordercolor="#1e3a5f", borderwidth=1)
      ) |> config(displayModeBar=FALSE)
    })

    output$rango_resultado <- renderUI({
      var    <- input$var_rango
      rng    <- rangos_esp[[var]]
      mi_min <- min(df[[var]])
      mi_max <- max(df[[var]])
      dentro <- mi_min >= rng[1] & mi_max <= rng[2]
      div(style="display:flex; align-items:center; flex-wrap:wrap; padding:0.6rem 1rem; background-color:#0D1B2E; border-radius:8px; border:1px solid #1e3a5f;",
        span(if(dentro) "✓ Dentro del rango esperado" else "✗ Fuera del rango",
          style=paste0("color:", if(dentro) "#4CAF50" else "#C0392B", "; font-weight:700; font-size:0.95rem; margin-right:1.5rem;")),
        span(paste0("Rango esperado: [", rng[1], " – ", rng[2], "]"),
          style="color:#94a3b8; font-size:0.88rem; margin-right:1.5rem;"),
        span(paste0("Rango real: [", mi_min, " – ", mi_max, "]"),
          style="color:#cbd5e1; font-size:0.88rem;")
      )
    })

    output$interp_outlier <- renderUI({
      txt <- interpretaciones_out[[input$var_interp]]
      div(style="padding:1rem 1.2rem; background-color:#0D1B2E; border-left:4px solid #C0392B; border-radius:8px; border:1px solid #1e3a5f;",
        p(txt, class="page-text"),
        p(style="color:#94a3b8; font-style:italic; font-size:0.92rem; margin-bottom:0;",
          "Decisión: No se aplica ningún tratamiento. Los valores extremos corresponden a individuos reales con perfiles de salud severos. Su exclusión introduciría un sesgo de selección que afectaría la validez del análisis.")
      )
    })
  })
}
