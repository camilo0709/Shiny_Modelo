temas_mt <- list(
  list(id="tema1", titulo="Enfermedades cardíacas e insuficiencia cardíaca",
    contenido="La insuficiencia cardíaca es un trastorno en el que el corazón es incapaz de satisfacer las demandas del organismo, lo que genera una reducción del flujo sanguíneo y congestión en venas y pulmones. Puede originarse por causas directas —como el debilitamiento o rigidez del músculo cardíaco— o indirectas, producto de condiciones como la hipertensión arterial, la diabetes o valvulopatías.",
    uso=NULL),
  list(id="tema2", titulo="El sistema BRFSS como fuente de datos",
    contenido="El Sistema de Vigilancia de Factores de Riesgo Conductuales (BRFSS) es el principal sistema nacional de encuestas telefónicas sobre salud en Estados Unidos, administrado por los CDC desde 1984. Recopila datos en los 50 estados, con más de 400.000 entrevistas a adultos cada año, siendo el sistema de encuestas telefónicas de salud continua más grande del mundo.",
    uso=NULL),
  list(id="tema3", titulo="Análisis Exploratorio de Datos (EDA)",
    contenido="El análisis exploratorio de datos (EDA) es un enfoque metodológico que permite examinar conjuntos de datos para resumir sus características principales, descubrir patrones, detectar anomalías y evaluar supuestos antes de aplicar técnicas de modelado formal. Desarrollado por John Tukey en la década de 1970, emplea principalmente métodos de visualización estadística.",
    uso=NULL)
)

metricas_mt <- list(
  list(id="met1", titulo="Chi-cuadrado (χ²)", resumen="Asociación entre variables categóricas.",
    contenido="Prueba de hipótesis que evalúa si existe una asociación estadísticamente significativa entre dos variables categóricas. Compara las frecuencias observadas en una tabla de contingencia contra las que se esperarían si las variables fueran independientes.",
    uso="Determinar si cada variable binaria u ordinal tiene relación no aleatoria con HeartDiseaseorAttack."),
  list(id="met2", titulo="V de Cramér", resumen="Magnitud de la asociación entre variables.",
    contenido="Medida de efecto derivada del estadístico Chi-cuadrado, normalizada en un rango de 0 a 1, donde 0 indica ausencia total de asociación y 1 asociación perfecta. Permite comparar la fuerza de asociación entre variables con diferente número de categorías.",
    uso="Cuantificar la magnitud de la asociación más allá de la significancia estadística."),
  list(id="met3", titulo="Mann-Whitney U", resumen="Comparación de distribuciones sin asumir normalidad.",
    contenido="Prueba no paramétrica que compara las distribuciones de una variable continua entre dos grupos independientes, sin asumir normalidad. Más robusta que la t de Student cuando los datos presentan sesgo pronunciado.",
    uso="Comparar BMI, MentHlth y PhysHlth entre grupos con y sin enfermedad cardíaca."),
  list(id="met4", titulo="Correlación de Pearson (r)", resumen="Fuerza y dirección de relación lineal.",
    contenido="Mide la fuerza y dirección de la relación lineal entre dos variables numéricas, en un rango de −1 a 1. Permite identificar de forma rápida qué predictores se relacionan positiva o negativamente con el riesgo cardíaco.",
    uso="Síntesis visual de la fuerza lineal de asociación de todas las variables con el target.")
)

make_collapsible_mt <- function(item, prefix, ns) {
  div(
    div(class="collapsible-header", id=ns(paste0("hdr_", prefix, "_", item$id)),
      style="justify-content:space-between;",
      span(item$titulo),
      span("▼", id=ns(paste0("arr_", prefix, "_", item$id)))
    ),
    div(id=ns(paste0("col_", prefix, "_", item$id)),
      style="display:none;",
      div(class="collapsible-body",
        p(item$contenido, class="page-text", style="margin-bottom:0;"),
        if (!is.null(item$uso)) {
          p(style="margin-top:0.8rem; margin-bottom:0;",
            span("Uso: ", style="color:#fff; font-weight:600; font-size:0.85rem;"),
            span(item$uso, style="color:#94a3b8; font-size:0.85rem;")
          )
        }
      )
    )
  )
}

make_toggle_js <- function(items, prefix, id) {
  paste0(
    sapply(items, function(item) {
      sprintf("
        $('#%s').on('click', function() {
          // Close others
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

marcoTeoricoUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Marco Teórico", class="page-title"),
        p("Fundamentos conceptuales y estadísticos que sustentan el análisis.", class="page-subtitle"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row mb-4",
      div(class="col-12",
        h4("Conceptos Fundamentales", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("Haz click en cada tema para expandirlo.", class="page-subtitle"),
        lapply(temas_mt, make_collapsible_mt, prefix="tema", ns=ns)
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row mb-5",
      div(class="col-12",
        h4("Métricas Estadísticas", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("Herramientas estadísticas aplicadas en el análisis bivariado.", class="page-subtitle"),
        lapply(metricas_mt, make_collapsible_mt, prefix="met", ns=ns)
      )
    ),
    tags$script(HTML(paste0(
      make_toggle_js(temas_mt, "tema", id), "\n",
      make_toggle_js(metricas_mt, "met", id)
    )))
  )
}
