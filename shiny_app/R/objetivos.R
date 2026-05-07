especificos <- list(
  list(id="obj1", num="01", titulo="Distribución de variables",
    detalle="Describir la distribución de las variables clínicas, conductuales y sociodemográficas presentes en el dataset BRFSS 2015, identificando frecuencias, proporciones y posibles valores atípicos. Este objetivo sienta las bases para entender el comportamiento individual de cada variable antes de explorar sus relaciones."),
  list(id="obj2", num="02", titulo="Desbalance de clases",
    detalle="Analizar el desbalance de clases en la variable objetivo (HeartDiseaseorAttack) y evaluar su implicación para el análisis y la futura modelación. Con solo un 9.42% de casos positivos, este desbalance es crítico para decisiones de modelado como el uso de SMOTE o ajuste de pesos de clase."),
  list(id="obj3", num="03", titulo="Factores de riesgo cardiovascular",
    detalle="Examinar la relación entre los factores de riesgo cardiovascular —como hipertensión, colesterol elevado, tabaquismo, diabetes e índice de masa corporal— y la presencia de enfermedad cardíaca. Se aplican pruebas estadísticas como Chi² y V de Cramér para cuantificar la fuerza de cada asociación."),
  list(id="obj4", num="04", titulo="Comparación entre grupos",
    detalle="Comparar el perfil de salud y los hábitos de vida entre individuos con y sin enfermedad cardíaca, identificando contrastes estadísticamente relevantes. Se utilizan pruebas Mann-Whitney U para variables continuas y tasas de incidencia por grupo para una interpretación clínica directa.")
)

make_obj_card <- function(obj, ns) {
  div(class="col-md-6 mb-4",
    div(class="metric-card", style="height:140px; display:flex; flex-direction:column; justify-content:space-between; text-align:left;",
      div(style="display:flex; align-items:center; gap:0.8rem;",
        span(obj$num, style="color:#fff; font-weight:800; font-size:1.4rem; flex-shrink:0;"),
        h6(obj$titulo, style="color:#fff; font-weight:700; font-size:1rem; margin-bottom:0;")
      ),
      actionButton(ns(paste0("btn_", obj$id)), "Ver más ↓",
        style = "background:transparent; border:1px solid #fff; color:#fff; border-radius:6px; padding:0.3rem 0.8rem; font-size:0.8rem; align-self:flex-start;")
    ),
    div(id=ns(paste0("collapse_", obj$id)),
      style="display:none; background-color:#162032; border-left:4px solid #C0392B; border-radius:0 0 12px 12px; padding:1rem 1.2rem; margin-top:2px;",
      p(obj$detalle, class="page-text", style="margin-bottom:0;")
    )
  )
}

objetivosUI <- function(id) {
  ns <- NS(id)
  div(class="page-content",
    div(class="row mt-4",
      div(class="col-12",
        h1("Objetivos", class="page-title"),
        p("Propósitos que guían el análisis exploratorio del dataset BRFSS 2015.", class="page-subtitle"),
        tags$hr(class="section-hr")
      )
    ),
    div(class="row mb-5",
      div(class="col-12",
        h4("Objetivo General", style="color:#fff; font-weight:700; margin-bottom:1rem;"),
        div(class="metric-card", style="text-align:left; border-left:5px solid #C0392B;",
          p(class="page-text", style="margin-bottom:0;",
            "Examinar, a través de técnicas de análisis exploratorio y visualización de datos, qué factores conductuales, clínicos y sociodemográficos presentan mayor asociación con el riesgo de enfermedad cardíaca en adultos estadounidenses, detectando patrones, contrastes entre grupos y variables con mayor capacidad explicativa como base para una futura modelación predictiva.")
        )
      )
    ),
    tags$hr(class="section-hr"),
    div(class="row",
      div(class="col-12",
        h4("Objetivos Específicos", style="color:#fff; font-weight:700; margin-bottom:0.4rem;"),
        p("Haz click en cada card para expandir los detalles.", class="page-subtitle")
      )
    ),
    div(class="row",
      lapply(especificos, make_obj_card, ns=ns)
    ),
    # Scripts para toggle
    tags$script(HTML(paste0(
      sapply(especificos, function(obj) {
        sprintf("
          $('#%s').on('click', function() {
            var el = document.getElementById('%s');
            if (el.style.display === 'none' || el.style.display === '') {
              el.style.display = 'block';
              $(this).text('Ver menos ↑');
            } else {
              el.style.display = 'none';
              $(this).text('Ver más ↓');
            }
          });",
          paste0(id, "-btn_", obj$id),
          paste0(id, "-collapse_", obj$id)
        )
      }, USE.NAMES=FALSE),
      collapse="\n"
    )))
  )
}
