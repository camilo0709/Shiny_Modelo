diccionario <- data.frame(
  Variable    = c("HeartDiseaseorAttack","HighBP","HighChol","CholCheck","BMI","Smoker","Stroke","Diabetes","PhysActivity","Fruits","Veggies","HvyAlcoholConsump","AnyHealthcare","NoDocbcCost","GenHlth","MentHlth","PhysHlth","DiffWalk","Sex","Age","Education","Income"),
  Tipo        = c("Objetivo","Binaria","Binaria","Binaria","Continua","Binaria","Binaria","Ordinal","Binaria","Binaria","Binaria","Binaria","Binaria","Binaria","Ordinal","Continua","Continua","Binaria","Binaria","Ordinal","Ordinal","Ordinal"),
  Escala      = c("0 / 1","0 / 1","0 / 1","0 / 1","12 – 98","0 / 1","0 / 1","0 / 1 / 2","0 / 1","0 / 1","0 / 1","0 / 1","0 / 1","0 / 1","1 – 5","0 – 30 días","0 – 30 días","0 / 1","0 / 1","1 – 13","1 – 6","1 – 8"),
  Descripción = c("Reportó enfermedad coronaria o infarto","Diagnóstico de presión arterial alta","Diagnóstico de colesterol alto","Revisión de colesterol en últimos 5 años","Índice de masa corporal","Fumó al menos 100 cigarrillos en su vida","Diagnóstico de derrame cerebral (ACV)","0=Sin diabetes · 1=Prediabetes · 2=Diabetes confirmada","Realizó actividad física en últimos 30 días","Consume frutas 1 o más veces al día","Consume verduras 1 o más veces al día","Consumo excesivo de alcohol","Tiene cobertura o seguro médico","No fue al médico en el último año por costo","Autopercepción de salud general (1=Excelente · 5=Mala)","Días con mala salud mental en el último mes","Días con mala salud física en el último mes","Dificultad seria para caminar o subir escaleras","0 = Mujer · 1 = Hombre","Grupo etario en intervalos de 5 años (1=18–24 · 13=80+)","Nivel educativo (1=Sin escolaridad · 6=Universitario)","Ingreso anual del hogar (1=<$10k · 8=≥$75k)"),
  stringsAsFactors = FALSE
)

cargaUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Carga y Estructura del Dataset", class="page-title"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row",
      div(class="col-md-4",
        div(class="metric-card", uiOutput(ns("card_filas")))
      ),
      div(class="col-md-4",
        div(class="metric-card", uiOutput(ns("card_cols")))
      ),
      div(class="col-md-4",
        div(class="metric-card",
          h2("float64", style="color:#FEFBFA;"), p("tipo de dato original")
        )
      )
    ),
    div(class="row mb-4",
      div(class="col-12",
        p(class="page-text",
          "El dataset cargado contiene 253.680 registros y 22 variables, resultado del proceso de limpieza y selección aplicado sobre el BRFSS 2015 original de 441.456 filas y 330 columnas. De las 22 variables, 1 corresponde a la variable objetivo (HeartDiseaseorAttack) y las 21 restantes representan los factores de riesgo seleccionados."),
        p(class="page-text",
          "El hecho de que todas sean float64 es solo el formato de almacenamiento, no su naturaleza estadística. Clasificarlas correctamente es importante porque determina qué tipo de visualizaciones y estadísticas aplicar en el EDA.")
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-5",
      div(class="col-12",
        h4("Vista previa del dataset", style="color:#fff; font-weight:700; margin-bottom:1rem;"),
        p("¿Cuántas filas quieres explorar?", style="color:#94a3b8; font-size:0.85rem;"),
        sliderInput(ns("n_filas"), NULL, min=5, max=20, step=5, value=10),
        DTOutput(ns("tabla_preview"))
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-5",
      div(class="col-12",
        h4("Diccionario de variables", style="color:#fff; font-weight:700; margin-bottom:1rem;"),
        div(class="row",
          div(class="col-md-4",
            tags$label("Filtrar por tipo:", style="color:#94a3b8; font-size:0.85rem;"),
            selectInput(ns("tipo_filtro"), NULL,
              choices = c("Todos","Objetivo","Binaria","Ordinal","Continua"),
              selected = "Objetivo")
          ),
          div(class="col-md-4",
            uiOutput(ns("contador_vars"))
          )
        ),
        DTOutput(ns("tabla_diccionario"))
      )
    )
  )
}

cargaServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {

    dt_opts <- list(
      pageLength = 10, dom = 'tip', scrollX = TRUE,
      initComplete = JS("function(settings, json) {
        $(this.api().table().header()).css({'background-color':'#162032','color':'#ffffff'});
      }")
    )

    output$card_filas <- renderUI({
      tagList(h2(format(nrow(df), big.mark=","), style="color:#FBF8F7;"), p("filas"))
    })
    output$card_cols <- renderUI({
      tagList(h2(ncol(df), style="color:#F9F8F8;"), p("columnas"))
    })

    output$tabla_preview <- renderDT({
      head(df, input$n_filas) |>
        mutate(across(where(is.numeric), ~round(.x, 2)))
    }, options = dt_opts, class="compact hover")

    output$tabla_diccionario <- renderDT({
      data <- if (input$tipo_filtro == "Todos") diccionario
               else diccionario[diccionario$Tipo == input$tipo_filtro, ]
      data
    }, options = list(pageLength=22, dom='t', scrollX=TRUE), class="compact hover")

    output$contador_vars <- renderUI({
      data <- if (input$tipo_filtro == "Todos") diccionario
               else diccionario[diccionario$Tipo == input$tipo_filtro, ]
      p(paste("Mostrando", nrow(data), "variable(s)"),
        style="color:#929caa; font-size:0.85rem; margin-top:2rem;")
    })
  })
}
