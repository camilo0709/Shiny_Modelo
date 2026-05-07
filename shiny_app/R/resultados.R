binary_vars_r  <- c("HighBP","HighChol","CholCheck","Smoker","Stroke","PhysActivity","Fruits","Veggies","HvyAlcoholConsump","AnyHealthcare","NoDocbcCost","DiffWalk","Sex")
ordinal_vars_r <- c("GenHlth","Age","Education","Income","Diabetes")
continuous_vars_r <- c("BMI","MentHlth","PhysHlth")
all_vars_r <- c(binary_vars_r, ordinal_vars_r, continuous_vars_r)
target_var_r <- "HeartDiseaseorAttack"

mappings_r <- list(
  HeartDiseaseorAttack = c("0"="Sin enfermedad",   "1"="Con enfermedad"),
  HighBP            = c("0"="Sin hipertensión",     "1"="Con hipertensión"),
  HighChol          = c("0"="Sin colesterol alto",  "1"="Con colesterol alto"),
  CholCheck         = c("0"="Sin chequeo",          "1"="Con chequeo"),
  Smoker            = c("0"="No fumador",            "1"="Fumador"),
  Stroke            = c("0"="Sin ACV",               "1"="Con ACV"),
  PhysActivity      = c("0"="Sin actividad física",  "1"="Con actividad física"),
  Fruits            = c("0"="No consume frutas",     "1"="Consume frutas"),
  Veggies           = c("0"="No consume verduras",   "1"="Consume verduras"),
  HvyAlcoholConsump = c("0"="No consumo alto",       "1"="Consumo alto alcohol"),
  AnyHealthcare     = c("0"="Sin cobertura",         "1"="Con cobertura médica"),
  NoDocbcCost       = c("0"="Sin barrera económica", "1"="Con barrera económica"),
  DiffWalk          = c("0"="Sin dificultad",        "1"="Con dificultad al caminar"),
  Sex               = c("0"="Mujer",                 "1"="Hombre"),
  Diabetes          = c("0"="Sin diabetes",          "1"="Prediabetes",       "2"="Diabetes confirmada"),
  GenHlth           = c("1"="Excelente","2"="Muy buena","3"="Buena","4"="Regular","5"="Mala"),
  Age               = c("1"="18–24","2"="25–29","3"="30–34","4"="35–39","5"="40–44","6"="45–49","7"="50–54","8"="55–59","9"="60–64","10"="65–69","11"="70–74","12"="75–79","13"="80+"),
  Education         = c("1"="Nunca asistió","2"="Primaria incompleta","3"="Secundaria incompleta","4"="Secundaria completa","5"="Universidad incompleta","6"="Universidad completa"),
  Income            = c("1"="< $10k","2"="$10–15k","3"="$15–20k","4"="$20–25k","5"="$25–35k","6"="$35–50k","7"="$50–75k","8"="$75k+")
)

interp_uni_r <- c(
  HighBP="El 42.9% de los encuestados presenta hipertensión. Esta distribución es notable ya que casi la mitad de la muestra convive con presión arterial alta, uno de los principales factores de riesgo cardiovascular.",
  HighChol="El 42.41% presenta colesterol alto. La distribución es muy similar a HighBP, reflejando que cerca de cuatro de cada diez participantes tienen este factor de riesgo.",
  CholCheck="El 96.27% se realizó un chequeo de colesterol en los últimos 5 años, reflejando un alto nivel de adherencia a servicios preventivos de salud en la muestra.",
  Smoker="El 44.32% ha fumado al menos 100 cigarrillos en su vida. La distribución es relativamente equilibrada, siendo el tabaquismo uno de los tres factores de riesgo clave identificados por los CDC.",
  Stroke="Solo el 4.06% reportó haber sufrido un derrame cerebral. Aunque su baja prevalencia podría limitar su variabilidad, el ACV y la enfermedad cardíaca comparten múltiples factores de riesgo.",
  PhysActivity="El 75.65% realizó actividad física en los últimos 30 días. El cuarto de la población que no realiza ninguna actividad representa un grupo de interés dado que el sedentarismo es un factor de riesgo cardiovascular relevante.",
  Fruits="El 63.43% consume frutas al menos una vez al día. Más de un tercio no alcanza este mínimo dietético recomendado.",
  Veggies="El 81.14% consume verduras diariamente. Comparado con el consumo de frutas (63.43%), el hábito de consumir verduras está más extendido en la muestra.",
  HvyAlcoholConsump="Solo el 5.62% presenta consumo excesivo de alcohol. La distribución es muy asimétrica con gran concentración en la clase negativa.",
  AnyHealthcare="El 95.11% cuenta con cobertura médica, reflejando un alto nivel de aseguramiento en la muestra.",
  NoDocbcCost="El 8.42% dejó de consultar un médico por razones de costo, representando más de 21.000 personas que potencialmente no recibieron atención médica oportuna.",
  DiffWalk="El 16.82% reporta dificultad para caminar o subir escaleras. Este porcentaje otorga mayor variabilidad y potencial discriminatorio.",
  Sex="El 55.97% son mujeres y el 44.03% hombres. La muestra presenta una leve mayoría femenina.",
  Diabetes="El 84.24% no presenta diabetes, el 13.93% tiene diabetes confirmada y apenas el 1.83% está en prediabetes.",
  GenHlth="Más de la mitad de la muestra (52.98%) califica su salud como excelente o muy buena. Solo el 4.76% la percibe como mala.",
  Age="Los grupos de 55-69 años concentran casi el 38% de la muestra. Los grupos jóvenes (18-29) están subrepresentados.",
  Education="El 42.31% completó la universidad. La muestra está compuesta predominantemente por personas con alto nivel educativo.",
  Income="El 35.63% reporta ingresos de $75.000 o más. La distribución está sesgada hacia ingresos altos.",
  BMI="El BMI presenta una media de 28.38 y mediana de 27.0, con leve asimetría positiva. El 50% central se ubica entre 24.0 y 31.0.",
  MentHlth="El 69.3% reportó 0 días de mala salud mental. La distribución es extremadamente asimétrica con concentración en cero.",
  PhysHlth="Similar a MentHlth, con fuerte concentración en 0 días. Los picos en 7, 14 y 30 días sugieren respuestas semanales o mensuales."
)

interp_biv_r <- c(
  HighBP="La hipertensión muestra una de las asociaciones más fuertes con enfermedad cardíaca. Las personas con hipertensión tienen una tasa de incidencia notablemente mayor.",
  HighChol="El colesterol alto presenta una asociación significativa con la enfermedad cardíaca. La tasa de incidencia en el grupo con colesterol elevado es considerablemente mayor.",
  CholCheck="Quienes no se realizaron chequeo de colesterol paradójicamente muestran menor tasa de enfermedad cardíaca, posiblemente porque son personas más jóvenes y saludables.",
  Smoker="Los fumadores presentan mayor prevalencia de enfermedad cardíaca. El tabaquismo es reconocido como uno de los factores de riesgo cardiovascular modificables más importantes.",
  Stroke="La asociación entre ACV y enfermedad cardíaca es de las más fuertes del dataset. Quienes sufrieron un derrame cerebral tienen una tasa de incidencia cardíaca muy superior.",
  PhysActivity="La actividad física muestra una relación inversa con la enfermedad cardíaca: quienes no realizan actividad física tienen mayor prevalencia.",
  Fruits="El consumo de frutas muestra una asociación modesta con menor riesgo cardíaco, aunque su efecto es menos pronunciado que factores clínicos.",
  Veggies="Similar a Fruits, el consumo de verduras se asocia con menor prevalencia de enfermedad cardíaca, con una magnitud de efecto moderada.",
  HvyAlcoholConsump="Sorprendentemente, el consumo alto de alcohol muestra menor tasa de enfermedad cardíaca. Esto podría explicarse por el perfil más joven de los bebedores excesivos.",
  AnyHealthcare="La cobertura médica se asocia ligeramente con mayor detección de enfermedad cardíaca, posiblemente porque el acceso a salud facilita el diagnóstico.",
  NoDocbcCost="Las personas con barreras económicas para acceder al médico muestran mayor prevalencia de enfermedad cardíaca.",
  DiffWalk="La dificultad para caminar muestra una asociación fuerte con enfermedad cardíaca. Es tanto un síntoma como un factor de riesgo de deterioro cardiovascular.",
  Sex="Los hombres presentan mayor tasa de enfermedad cardíaca que las mujeres en esta muestra.",
  Diabetes="La diabetes muestra una de las asociaciones más fuertes con enfermedad cardíaca. Las personas con diabetes confirmada tienen una tasa de incidencia muy superior.",
  GenHlth="La autopercepción de salud es un predictor muy potente. A peor salud percibida, mayor es la tasa de enfermedad cardíaca, con una gradiente clara.",
  Age="La edad muestra una relación directa y clara: a mayor grupo etario, mayor prevalencia de enfermedad cardíaca. Los grupos de 65 años en adelante concentran la mayoría.",
  Education="A mayor nivel educativo, menor prevalencia de enfermedad cardíaca, aunque la asociación es moderada.",
  Income="El ingreso muestra una relación inversa con la enfermedad cardíaca: a mayores ingresos, menor prevalencia.",
  BMI="El BMI es significativamente mayor en personas con enfermedad cardíaca según la prueba Mann-Whitney.",
  MentHlth="Las personas con enfermedad cardíaca reportan significativamente más días de mala salud mental.",
  PhysHlth="La salud física deteriorada muestra una de las asociaciones más fuertes con enfermedad cardíaca entre las variables continuas."
)

PLOT_BASE_R <- list(
  paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",
  font=list(color="#cbd5e1", family="Poppins", size=12),
  margin=list(t=50, b=50, l=50, r=30)
)

get_var_type_r <- function(var) {
  if (var %in% continuous_vars_r) return("continua")
  if (var %in% ordinal_vars_r)   return("ordinal")
  return("binaria")
}

resultadosUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Resultados del Análisis", class="page-title"),
        tags$hr(class="section-hr")
      )
    ),
    # ── UNIVARIADO ──
    div(class="row",
      div(class="col-12",
        h4("Análisis Univariado", style="color:#fff; font-weight:700; margin-bottom:0.3rem;"),
        p("Distribución individual de cada variable del dataset.", class="page-subtitle")
      )
    ),
    div(class="row mb-4",
      div(class="col-md-5",
        selectInput(ns("dd_uni"), NULL, choices=all_vars_r, selected="HighBP",selectize = TRUE)
      ),
      div(class="col-md-7", uiOutput(ns("uni_badge")))
    ),
    div(class="row mb-5 align-items-stretch",
      div(class="col-md-8",
        div(class="metric-card", style="padding:0.5rem;",
          plotlyOutput(ns("uni_chart"), height="380px"))
      ),
      div(class="col-md-4",
        div(class="metric-card h-100", style="text-align:left;",
          h6("Interpretación", style="color:#fff; font-weight:700; border-bottom:1px solid #1e3a5f; padding-bottom:0.5rem;"),
          uiOutput(ns("uni_interp"))
        )
      )
    ),
    tags$hr(class="section-hr"),
    # ── BIVARIADO ──
    div(class="row",
      div(class="col-12",
        h4("Análisis Bivariado", style="color:#fff; font-weight:700; margin-bottom:0.3rem;"),
        p("Variable objetivo fija: HeartDiseaseorAttack. Selecciona la segunda variable.", class="page-subtitle")
      )
    ),
    div(class="row mb-4 align-items-center",
      div(class="col-md-4",
        div(class="metric-card", style="text-align:left; border-color:#C0392B;",
          p("Variable objetivo", style="color:#94a3b8; font-size:0.78rem; margin-bottom:0.3rem;"),
          h6("HeartDiseaseorAttack", style="color:#fff; font-weight:700; margin-bottom:0;")
        )
      ),
      div(class="col-md-5",
        selectInput(ns("dd_biv"), NULL, choices=all_vars_r, selected="HighBP")
      ),
      div(class="col-md-3", uiOutput(ns("biv_badge")))
    ),
    uiOutput(ns("biv_stat_cards")),
    div(class="row mb-5 align-items-stretch",
      div(class="col-md-8",
        div(class="metric-card", style="padding:0.5rem;",
          plotlyOutput(ns("biv_chart"), height="380px"))
      ),
      div(class="col-md-4",
        div(class="metric-card h-100", style="text-align:left;",
          h6("Interpretación", style="color:#fff; font-weight:700; border-bottom:1px solid #1e3a5f; padding-bottom:0.5rem;"),
          uiOutput(ns("biv_interp"))
        )
      )
    ),
    tags$hr(class="section-hr"),
    # ── CORRELACIÓN ──
    div(class="row",
      div(class="col-12",
        h4("Correlación de Pearson con la variable objetivo", style="color:#fff; font-weight:700; margin-bottom:0.3rem;"),
        p("Fuerza y dirección de la asociación lineal de cada variable con HeartDiseaseorAttack. Barras rojas indican correlación positiva y azules negativa.", class="page-subtitle")
      )
    ),
    div(class="row mb-5",
      div(class="col-12",
        div(class="metric-card", style="padding:0.5rem;",
          plotlyOutput(ns("corr_chart"), height="520px"))
      )
    )
  )
}

resultadosServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {

    make_uni_chart <- function(var) {
      var <- as.character(var)
      vtype <- get_var_type_r(var)
      if (vtype == "continua") {
        m <- mean(df[[var]], na.rm=TRUE)
        med <- median(df[[var]], na.rm=TRUE)
        plot_ly(x=df[[var]], type="histogram", nbinsx=40,
          marker=list(color="#C0392B", line=list(color="#0D1B2E", width=0.5)),
          opacity=0.85, name=var) |>
          add_lines(x=c(m,m), y=c(0,50000), line=list(color="#E8A838", dash="dash"), name=paste0("Media: ",round(m,1))) |>
          add_lines(x=c(med,med), y=c(0,50000), line=list(color="#4A6FA5", dash="dot"), name=paste0("Mediana: ",round(med,1))) |>
          layout(paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",
                 font=list(color="#cbd5e1", family="Poppins", size=12),
                 margin=list(t=50, b=50, l=160, r=80),
            title=list(text=paste("Distribución de",var), font=list(color="#fff",size=14), x=0),
            xaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title=var),
            yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title="Frecuencia"),
            height=380, showlegend=TRUE,
            legend=list(bgcolor="#0D1B2E", bordercolor="#1e3a5f")) |>
          config(displayModeBar=FALSE)
      } else {
        mp <- mappings_r[[var]]
        counts <- table(df[[var]])
        keys   <- names(counts)
        labels <- if (!is.null(mp)) mp[keys] else keys
        labels[is.na(labels)] <- keys[is.na(labels)]
        pcts <- round(as.numeric(counts) / sum(counts) * 100, 1)

        if (vtype == "ordinal") {
          plot_ly(x=pcts, y=labels, type="bar", orientation="h",
            marker=list(color=pcts, colorscale=list(c(0,"#1a2a4a"), c(1,"#C0392B")), showscale=FALSE),
            text=paste0(pcts,"%"), textposition="outside",
            textfont=list(color="#cbd5e1", size=11)) |>
            layout(paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",
                   font=list(color="#cbd5e1", family="Poppins", size=12),
                   margin=list(t=50, b=50, l=160, r=80),
              title=list(text=paste("Distribución de",var), font=list(color="#fff",size=14), x=0),
              xaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title="Porcentaje (%)"),
              yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", autorange="reversed"),
              height=max(300, length(labels)*45), showlegend=FALSE) |>
            config(displayModeBar=FALSE)
        } else {
          plot_ly(x=labels, y=pcts, type="bar",
            marker=list(color=c("#C0392B","#2C3E6B"), line=list(color="#0D1B2E", width=1)),
            text=paste0(pcts,"%"), textposition="outside",
            textfont=list(color="#cbd5e1", size=12)) |>
            layout(paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",           font=list(color="#cbd5e1", family="Poppins", size=12),           margin=list(t=50, b=50, l=160, r=80),
              title=list(text=paste("Distribución de",var), font=list(color="#fff",size=14), x=0),
              xaxis=list(gridcolor="#1e3a5f", color="#94a3b8"),
              yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title="Porcentaje (%)", range=c(0, max(pcts)*1.2)),
              height=360, showlegend=FALSE) |>
            config(displayModeBar=FALSE)
        }
      }
    }

    make_biv_chart <- function(var) {
      var <- as.character(var)
      vtype <- get_var_type_r(var)
      tmap  <- mappings_r[[target_var_r]]

      if (vtype == "continua") {
        fig <- plot_ly()
        cols_biv <- c("#2C3E6B","#C0392B")
        for (i in seq_along(tmap)) {
          val <- as.numeric(names(tmap)[i])
          lbl <- tmap[i]
          sub <- df[[var]][df[[target_var_r]] == val]
          fig <- fig |> add_trace(y=sub, type="box", name=lbl,
            marker=list(color=cols_biv[i], size=3, opacity=0.8),
            line=list(color=cols_biv[i], width=2),
            fillcolor="rgba(13,27,46,0.8)", boxpoints="outliers")
        }
        fig |> layout(paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",           font=list(color="#cbd5e1", family="Poppins", size=12),           margin=list(t=50, b=50, l=160, r=80),
          title=list(text=paste(var,"según enfermedad cardíaca"), font=list(color="#fff",size=14), x=0),
          yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title=var),
          xaxis=list(color="#94a3b8", showgrid=FALSE), height=380,
          legend=list(bgcolor="#0D1B2E", bordercolor="#1e3a5f")) |>
          config(displayModeBar=FALSE)
      } else {
        mp <- mappings_r[[var]]
        df_tmp <- df[, c(var, target_var_r)]
        df_tmp$lbl <- if (!is.null(mp)) mp[as.character(df_tmp[[var]])] else as.character(df_tmp[[var]])
        df_tmp$lbl[is.na(df_tmp$lbl)] <- as.character(df_tmp[[var]][is.na(df_tmp$lbl)])

        inc <- tapply(df_tmp[[target_var_r]], df_tmp$lbl, function(x) round(mean(x)*100, 1))
        inc_df <- data.frame(cat=names(inc), inc=as.numeric(inc), stringsAsFactors=FALSE)

        if (!is.null(mp)) {
          order_lbl <- mp[order(as.numeric(names(mp)))]
          order_lbl <- order_lbl[order_lbl %in% inc_df$cat]
          inc_df <- inc_df[match(order_lbl, inc_df$cat), ]
          inc_df <- inc_df[!is.na(inc_df$cat), ]
        }

        if (vtype == "ordinal") {
          plot_ly(x=inc_df$inc, y=inc_df$cat, type="bar", orientation="h",
            marker=list(color=inc_df$inc, colorscale=list(c(0,"#1a2a4a"),c(1,"#C0392B")), showscale=FALSE,
              line=list(color="#0D1B2E", width=0.5)),
            text=paste0(inc_df$inc,"%"), textposition="outside",
            textfont=list(color="#cbd5e1", size=11)) |>
            layout(paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",           font=list(color="#cbd5e1", family="Poppins", size=12),           margin=list(t=50, b=50, l=160, r=80),
              title=list(text=paste("Tasa de enfermedad cardíaca por",var), font=list(color="#fff",size=14), x=0),
              xaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title="% con enfermedad cardíaca", range=c(0,max(inc_df$inc)*1.25)),
              yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", autorange="reversed"),
              height=max(300, nrow(inc_df)*45), showlegend=FALSE) |>
            config(displayModeBar=FALSE)
        } else {
          plot_ly(x=inc_df$cat, y=inc_df$inc, type="bar",
            marker=list(color=inc_df$inc, colorscale=list(c(0,"#1a2a4a"),c(1,"#C0392B")), showscale=FALSE,
              line=list(color="#0D1B2E", width=1)),
            text=paste0(inc_df$inc,"%"), textposition="outside",
            textfont=list(color="#cbd5e1", size=12)) |>
            layout(paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",           font=list(color="#cbd5e1", family="Poppins", size=12),           margin=list(t=50, b=50, l=160, r=80),
              title=list(text=paste("Tasa de enfermedad cardíaca por",var), font=list(color="#fff",size=14), x=0),
              xaxis=list(gridcolor="#1e3a5f", color="#94a3b8"),
              yaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title="% con enfermedad cardíaca", range=c(0,max(inc_df$inc)*1.25)),
              height=360, showlegend=FALSE) |>
            config(displayModeBar=FALSE)
        }
      }
    }

    make_corr_chart <- function() {
      num_df <- df[, sapply(df, is.numeric)]
      corr   <- cor(num_df, use="complete.obs")
      tc     <- sort(corr[, target_var_r][names(corr[, target_var_r]) != target_var_r])
      print(names(tc))
      colors <- ifelse(tc > 0, "#C0392B", "#2C3E6B")
      plot_ly(x=tc, y=names(tc), type="bar", orientation="h",
        marker=list(color=colors, line=list(color="#0D1B2E", width=0.5)),
        text=round(tc, 3), textposition="outside",
        textfont=list(color="#cbd5e1", size=10),
        yaxis = list(
          gridcolor = "#1e3a5f",
          color = "#94a3b8",
          categoryorder = "array",
          categoryarray = names(tc))) |>
        layout(
          paper_bgcolor="#0D1B2E", plot_bgcolor="#0D1B2E",
          font=list(color="#cbd5e1", family="Poppins", size=12),
          margin=list(t=50, b=50, l=160, r=80),
          title=list(text="Correlación de Pearson con HeartDiseaseorAttack", font=list(color="#fff",size=14), x=0),
          xaxis=list(gridcolor="#1e3a5f", color="#94a3b8", title="Correlación (r)",
            zeroline=TRUE, zerolinecolor="#ffffff", zerolinewidth=1.5,
            range=c(min(tc)*1.3, max(tc)*1.3)),
          yaxis=list(gridcolor="#1e3a5f", color="#94a3b8"),
          height=520, showlegend=FALSE) |>
        config(displayModeBar=FALSE)
    }

    compute_stats_r <- function(var) {
      var <- as.character(var)
      vtype <- get_var_type_r(var)
      if (vtype == "continua") {
        g0 <- df[[var]][df[[target_var_r]] == 0]
        g1 <- df[[var]][df[[target_var_r]] == 1]
        wt <- suppressWarnings(wilcox.test(g0, g1, alternative="two.sided"))
        r  <- cor(df[[var]], df[[target_var_r]], use="complete.obs")
        list(test="Mann-Whitney U", stat=format(wt$statistic, big.mark=",", scientific=FALSE),
             pval=formatC(wt$p.value, format="e", digits=2),
             efecto=paste0("r = ", round(r, 4)), efecto_label="Correlación Pearson")
      } else {
        ct   <- table(df[[var]], df[[target_var_r]])
        cst  <- suppressWarnings(chisq.test(ct))
        # V de Cramer
        n    <- sum(ct)
        k    <- min(nrow(ct), ncol(ct)) - 1
        v    <- sqrt(cst$statistic / (n * k))
        list(test="Chi-cuadrado (χ²)", stat=format(round(cst$statistic, 2), big.mark=","),
             pval=formatC(cst$p.value, format="e", digits=2),
             efecto=paste0("V = ", round(v, 4)), efecto_label="V de Cramér")
      }
    }

    # ── Outputs ──
    output$uni_chart <- renderPlotly({ make_uni_chart(input$dd_uni) })

    output$uni_interp <- renderUI({
      p(interp_uni_r[input$dd_uni], class="page-text", style="margin-bottom:0;")
    })

    output$uni_badge <- renderUI({
      vt <- get_var_type_r(input$dd_uni)
      span(tools::toTitleCase(vt), class=paste0("badge-", vt))
    })

    output$biv_chart <- renderPlotly({ make_biv_chart(input$dd_biv) })

    output$biv_interp <- renderUI({
      p(interp_biv_r[input$dd_biv], class="page-text", style="margin-bottom:0;")
    })

    output$biv_badge <- renderUI({
      vt <- get_var_type_r(input$dd_biv)
      span(tools::toTitleCase(vt), class=paste0("badge-", vt))
    })

    output$biv_stat_cards <- renderUI({
      st <- compute_stats_r(input$dd_biv)
      div(class="row mb-4",
        div(class="col-md-4",
          div(class="metric-card",
            p(st$test, style="color:#94a3b8; font-size:0.88rem; margin-bottom:0.5rem;"),
            h3(st$stat, style="color:#C0392B; font-weight:800; margin-bottom:0;")
          )
        ),
        div(class="col-md-4",
          div(class="metric-card",
            p("p-valor", style="color:#94a3b8; font-size:0.88rem; margin-bottom:0.5rem;"),
            h3(st$pval, style="color:#E8A838; font-weight:800; margin-bottom:0;")
          )
        ),
        div(class="col-md-4",
          div(class="metric-card",
            p(st$efecto_label, style="color:#94a3b8; font-size:0.88rem; margin-bottom:0.5rem;"),
            h3(st$efecto, style="color:#4A6FA5; font-weight:800; margin-bottom:0;")
          )
        )
      )
    })

    output$corr_chart <- renderPlotly({ make_corr_chart() })
  })
}
