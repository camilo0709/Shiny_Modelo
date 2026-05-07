univariado_items <- list(
  list(id="uni1", titulo="Variables binarias",
    descripcion="Se calcularán frecuencias absolutas y relativas con value_counts(), visualizadas en gráficos de barras verticales con el porcentaje anotado sobre cada barra. Cada gráfico es seguido de una interpretación narrativa con énfasis clínico.",
    uso="Aplicado a variables como HighBP, HighChol, Smoker, Stroke, Sex, entre otras."),
  list(id="uni2", titulo="Variables ordinales",
    descripcion="Mismo cálculo de frecuencias, pero representadas con barras horizontales para acomodar las etiquetas. Se preserva el orden natural de las categorías y se usan paletas diferenciadas por nivel.",
    uso="Aplicado a variables como GenHlth, Age, Education, Income y Diabetes."),
  list(id="uni3", titulo="Variables continuas",
    descripcion="Se construye una tabla descriptiva con media, mediana, desviación estándar, cuartiles, IQR y conteo de outliers por criterio de Tukey. BMI se grafica con histograma; MentHlth y PhysHlth con barras por valor exacto.",
    uso="Aplicado a BMI, MentHlth y PhysHlth.")
)

bivariado_items <- list(
  list(id="biv1", titulo="Variables binarias y ordinales → Chi-cuadrado + V de Cramér",
    descripcion="La prueba χ² evalúa si existe asociación estadísticamente significativa entre cada variable predictora y HeartDiseaseorAttack. La V de Cramér cuantifica la magnitud de dicha asociación en un rango [0, 1].",
    uso="Aplicado a las 13 variables binarias y las 5 variables ordinales del dataset."),
  list(id="biv2", titulo="Variables continuas → Mann-Whitney U",
    descripcion="Dado el sesgo pronunciado de BMI, MentHlth y PhysHlth, la prueba no paramétrica de Mann-Whitney es más robusta que la t de Student para comparar las distribuciones entre los dos grupos.",
    uso="Aplicado a BMI, MentHlth y PhysHlth comparando grupos con y sin enfermedad cardíaca."),
  list(id="biv3", titulo="Tasas de incidencia por grupo",
    descripcion="Se calcula el porcentaje de personas con enfermedad cardíaca dentro de cada categoría de cada variable predictora. Este enfoque ofrece una interpretación clínica directa.",
    uso="Complementa los resultados estadísticos con una lectura clínica intuitiva."),
  list(id="biv4", titulo="Mapa de calor de correlaciones de Pearson",
    descripcion="Como síntesis visual, se construye un mapa de calor con la correlación de Pearson entre todas las variables del dataset y la variable objetivo. Permite identificar de forma rápida qué predictores se relacionan positiva o negativamente.",
    uso="Síntesis global de asociaciones lineales entre todas las variables y el target.")
)

make_collapsible_met <- function(item, prefix, ns) {
  div(
    div(class="collapsible-header", id=ns(paste0("hdr_", prefix, "_", item$id)),
      style="justify-content:space-between;",
      span(item$titulo),
      span("▼", id=ns(paste0("arr_", prefix, "_", item$id)))
    ),
    div(id=ns(paste0("col_", prefix, "_", item$id)),
      style="display:none;",
      div(class="collapsible-body",
        p(item$descripcion, class="page-text", style="margin-bottom:0;"),
        p(style="margin-top:0.8rem; margin-bottom:0;",
          span("Aplicación: ", style="color:#fff; font-weight:600; font-size:0.85rem;"),
          span(item$uso, style="color:#94a3b8; font-size:0.85rem;")
        )
      )
    )
  )
}

make_toggle_met <- function(items, prefix, id) {
  paste0(
    sapply(items, function(item) {
      sprintf("
        $('#%s').on('click', function() {
          %s
          var el = document.getElementById('%s');
          var arr = document.getElementById('%s');
          if (el.style.display === 'none' || el.style.display === '') {
            el.style.display = 'block'; arr.textContent = '▲';
          } else {
            el.style.display = 'none'; arr.textContent = '▼';
          }
        });",
        paste0(id, "-hdr_", prefix, "_", item$id),
        paste0(sapply(items, function(o) {
          sprintf("document.getElementById('%s').style.display='none'; document.getElementById('%s').textContent='▼';",
            paste0(id, "-col_", prefix, "_", o$id),
            paste0(id, "-arr_", prefix, "_", o$id))
        }), collapse="\n"),
        paste0(id, "-col_", prefix, "_", item$id),
        paste0(id, "-arr_", prefix, "_", item$id)
      )
    }, USE.NAMES=FALSE),
    collapse="\n"
  )
}

metodologiaUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Metodología", class="page-title"),
        p("Estrategias y técnicas aplicadas en el análisis univariado y bivariado.", class="page-subtitle"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row mb-4",
      div(class="col-12",
        h4("Metodología del Análisis Univariado", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("El análisis univariado se realizará según la naturaleza estadística de cada variable. Haz click en cada uno para ver el detalle.", class="page-subtitle"),
        lapply(univariado_items, make_collapsible_met, prefix="uni", ns=ns)
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-5",
      div(class="col-12",
        h4("Metodología del Análisis Bivariado", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("Para examinar la relación entre cada variable predictora y la variable objetivo, se emplean cuatro estrategias. Haz click en cada una para ver el detalle.", class="page-subtitle"),
        lapply(bivariado_items, make_collapsible_met, prefix="biv", ns=ns)
      )
    ),
    tags$script(HTML(paste0(
      make_toggle_met(univariado_items, "uni", id), "\n",
      make_toggle_met(bivariado_items, "biv", id)
    )))
  )
}
