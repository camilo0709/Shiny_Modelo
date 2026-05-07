hallazgos_s <- list(
  list(num="01", titulo="Desbalance de clases crítico",
    texto="El 90.58% de los registros no presenta enfermedad cardíaca versus el 9.42% que sí. Este desbalance es un factor determinante para la futura modelación predictiva y requiere estrategias como SMOTE o ajuste de pesos de clase.",
    color="#C0392B"),
  list(num="02", titulo="Salud general como predictor estrella",
    texto="GenHlth (autopercepción de salud) es la variable con mayor asociación con enfermedad cardíaca (V de Cramér más alto). A peor salud percibida, mayor prevalencia cardíaca, con una gradiente clara y consistente.",
    color="#C0392B"),
  list(num="03", titulo="Edad y comorbilidades como factores clave",
    texto="La edad, la dificultad para caminar, el ACV previo y la diabetes muestran las asociaciones más fuertes junto con GenHlth. Los grupos de 65 años en adelante concentran la mayoría de los casos positivos.",
    color="#2C3E6B"),
  list(num="04", titulo="Factores clínicos superan a los conductuales",
    texto="Variables clínicas como hipertensión, colesterol alto y diabetes tienen mayor poder predictivo que factores conductuales como el consumo de frutas, verduras o alcohol.",
    color="#2C3E6B"),
  list(num="05", titulo="Dataset robusto y limpio",
    texto="El dataset no presenta valores nulos. Las 22 variables están dentro de sus rangos esperados. Los 23.899 duplicados se mantienen por ser estadísticamente plausibles en una encuesta poblacional con variables binarias.",
    color="#E8A838"),
  list(num="06", titulo="Sesgo socioeconómico en la muestra",
    texto="La muestra está sobrerrepresentada por personas de alto nivel educativo e ingresos altos, sesgo típico de encuestas telefónicas. Este factor debe considerarse al generalizar los resultados.",
    color="#E8A838")
)

sintesisUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Síntesis General", class="page-title"),
        p("Principales hallazgos del análisis exploratorio del dataset BRFSS 2015.", class="page-subtitle"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row",
      div(class="col-md-3", div(class="metric-card", h2("253.680", style="color:#F8F5F5;"), p("registros analizados"))),
      div(class="col-md-3", div(class="metric-card", h2("22",      style="color:#FEFCFC;"), p("variables clasificadas"))),
      div(class="col-md-3", div(class="metric-card", h2("9.42%",   style="color:#FAF7F6;"), p("prevalencia de enfermedad cardíaca"))),
      div(class="col-md-3", div(class="metric-card", h2("GenHlth", style="color:#FAF7F6;"), p("variable con mayor asociación")))
    ),
    tags$hr(class="section-hr"),
    div(class="row",
      div(class="col-12",
        h4("Hallazgos Clave", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("Los principales patrones identificados en el análisis exploratorio.", class="page-subtitle")
      )
    ),
    div(class="row",
      div(class="col-12",
        lapply(hallazgos_s, function(h) {
          div(class="hallazgo-card",
            div(class="hallazgo-bar", style=paste0("background-color:", h$color, ";")),
            div(
              div(style="margin-bottom:0.5rem;",
                span(h$num, style=paste0("color:", h$color, "; font-weight:800; font-size:1rem; margin-right:0.6rem;")),
                span(h$titulo, style="color:#fff; font-weight:700; font-size:0.95rem;")
              ),
              p(h$texto, class="page-text", style="margin-bottom:0;")
            )
          )
        })
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-5",
      div(class="col-12",
        h4("Conclusión", style="color:#fff; font-weight:700; margin-bottom:1rem;"),
        div(class="metric-card", style="text-align:left; border-left:5px solid #C0392B;",
          p(class="page-text",
            "El análisis exploratorio del dataset BRFSS 2015 permitió caracterizar de forma detallada el perfil de salud de 253.680 adultos estadounidenses y su relación con la enfermedad cardíaca. A lo largo del análisis se aplicaron técnicas descriptivas, pruebas estadísticas no paramétricas y medidas de asociación que en conjunto ofrecen una visión comprehensiva de los factores de riesgo cardiovascular."),
          p(class="page-text",
            "La autopercepción de salud general (GenHlth), la edad, la dificultad para caminar y el antecedente de ACV emergen como los predictores más potentes, seguidos por factores clínicos como la hipertensión, la diabetes y el colesterol alto. Todos presentaron asociaciones estadísticamente significativas con p-valores cercanos a cero."),
          p(class="page-text",
            "El marcado desbalance de clases (90.58% vs 9.42%) representa el principal desafío metodológico para la futura modelación predictiva. Se recomienda el uso de técnicas de balanceo como SMOTE junto con métricas ajustadas como F1-score, AUC-ROC y Recall para la clase positiva.", style="margin-bottom:0;")
        )
      )
    )
  )
}

sintesisServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    output$top_var_card <- renderUI({
      vars_s <- c("HighBP","HighChol","CholCheck","Smoker","Stroke","PhysActivity","Fruits","Veggies",
                  "HvyAlcoholConsump","AnyHealthcare","NoDocbcCost","DiffWalk","Sex",
                  "GenHlth","Age","Education","Income","Diabetes","BMI","MentHlth","PhysHlth")
      target <- "HeartDiseaseorAttack"
      v_vals <- sapply(vars_s, function(var) {
        ct <- table(df[[var]], df[[target]])
        cs <- suppressWarnings(chisq.test(ct))
        n  <- sum(ct); k <- min(nrow(ct), ncol(ct)) - 1
        sqrt(cs$statistic / (n * k))
      })
      top <- names('GenHlth')
      tagList(
        h2('GenHlth', style="color:#F9F7F7; font-weight:800; font-size:1.4rem;"),
        p("variable con mayor asociación")
      )
    })
  })
}
