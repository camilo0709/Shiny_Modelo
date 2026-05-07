homeUI <- function(id) {
  ns <- NS(id)
  div(class = "page-content",
    # Título principal
    div(class = "row mt-3",
      div(class = "col-12",
        h1("Factores asociados a enfermedades cardíacas - encuesta BRFSS 2015",
           class = "page-title-main"),
        h5("Análisis Exploratorio de Indicadores de Salud",
           style = "color:#94a3b8; margin-bottom:1.5rem; font-weight:300;"),
        tags$hr(class = "section-hr")
      )
    ),

    # Introducción + métricas
    div(class = "row mb-5 align-items-stretch",
      div(class = "col-md-8",
        p(class = "page-text",
          "Las enfermedades cardíacas representan la principal causa de muerte en ",
          "Estados Unidos, cobrando aproximadamente 647.000 vidas cada año y generando ",
          "una de las mayores cargas económicas y sanitarias del país. A diferencia de ",
          "otras enfermedades, la cardiopatía coronaria avanza de forma silenciosa: la ",
          "acumulación de placa en las arterias, la inflamación crónica, la hipertensión ",
          "y la diabetes deterioran el sistema cardiovascular durante años antes de que ",
          "aparezca cualquier síntoma visible."),
        p(class = "page-text",
          "En este contexto, las encuestas poblacionales de salud representan una fuente ",
          "valiosa de información. El Sistema de Vigilancia de Factores de Riesgo ",
          "Conductuales (BRFSS), administrado anualmente por el CDC desde 1984, recoge ",
          "respuestas de más de 400.000 estadounidenses sobre conductas de riesgo, ",
          "enfermedades crónicas y uso de servicios preventivos."),
        p(class = "page-text",
          "El dataset empleado corresponde a la versión depurada del BRFSS 2015, con ",
          "253.680 registros y 22 variables que incluyen indicadores como el índice de ",
          "masa corporal, actividad física, tabaquismo, consumo de alcohol, presión ",
          "arterial, colesterol, diabetes, acceso a atención médica y características ",
          "sociodemográficas como edad, sexo, nivel educativo e ingreso del hogar.")
      ),
      div(class = "col-md-4",
        div(class = "metric-card h-100",
          h2("253.680", style = "color:#C0392B;"), p("Registros en el dataset"),
          h2("22",      style = "color:#98033F;"), p("Variables analizadas"),
          h2("9.42%",   style = "color:#E8A838;"), p("Prevalencia de enfermedad cardíaca")
        )
      )
    ),

    tags$hr(class = "section-hr"),

    # Iconos / links
    div(class = "row justify-content-center mb-5",
      div(class = "col-md-2 d-flex justify-content-center",
        tags$a(
          href = "https://www.kaggle.com/datasets/alexteboul/heart-disease-health-indicators-dataset/data",
          target = "_blank", style = "text-decoration:none; text-align:center;",
          div(
            tags$svg(xmlns="http://www.w3.org/2000/svg", width="48", height="48", viewBox="0 0 24 24",
              fill="none", stroke="#ffffff", `stroke-width`="2",
              tags$polyline(points="16 18 22 12 16 6"),
              tags$polyline(points="8 6 2 12 8 18")
            ),
            p("Dataset", style="color:#E7E9EC; font-size:0.88rem; margin-top:0.5rem;")
          )
        )
      ),
      div(class = "col-md-2 d-flex justify-content-center",
        div(style = "text-align:center; cursor:pointer;",
          tags$svg(xmlns="http://www.w3.org/2000/svg", width="48", height="48", viewBox="0 0 24 24",
            fill="none", stroke="#ffffff", `stroke-width`="2",
            tags$circle(cx="12", cy="8", r="4"),
            tags$path(d="M6 20v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2"),
            tags$circle(cx="18", cy="8", r="3"),
            tags$circle(cx="6",  cy="8", r="3")
          ),
          p("About us", style="color:#E7E9EC; font-size:0.88rem; margin-top:0.5rem;"),
          # Modal de colaboradores embebido
          tags$script(HTML("
            $(document).on('click', '#about-trigger', function() {
              $('#about-modal').modal('show');
            });
          "))
        ) |> tagAppendAttributes(id = "about-trigger")
      )
    ),

    # Modal Bootstrap
    div(class="modal fade", id="about-modal", tabindex="-1",
      div(class="modal-dialog modal-dialog-centered",
        div(class="modal-content",
          div(class="modal-header",
            h5(class="modal-title", style="font-weight:700;", "Colaboradores")
          ),
          div(class="modal-body",
            div(class="d-flex align-items-center mb-4",
              tags$svg(xmlns="http://www.w3.org/2000/svg", width="36", height="36",
                viewBox="0 0 24 24", fill="none", stroke="#ffffff", `stroke-width`="2",
                class="me-3",
                tags$circle(cx="12", cy="8", r="4"),
                tags$path(d="M6 20v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2")
              ),
              div(
                p("Natalia Alvarado", style="color:#fff; font-weight:600; margin-bottom:0.1rem;"),
                tags$a("github.com/paolacorr67-ctrl",
                  href="https://github.com/paolacorr67-ctrl", target="_blank",
                  style="color:#C0392B; font-size:0.85rem; text-decoration:none;")
              )
            ),
            div(class="d-flex align-items-center",
              tags$svg(xmlns="http://www.w3.org/2000/svg", width="36", height="36",
                viewBox="0 0 24 24", fill="none", stroke="#ffffff", `stroke-width`="2",
                class="me-3",
                tags$circle(cx="12", cy="8", r="4"),
                tags$path(d="M6 20v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2")
              ),
              div(
                p("Camilo Mujica", style="color:#fff; font-weight:600; margin-bottom:0.1rem;"),
                tags$a("github.com/camilo0709",
                  href="https://github.com/camilo0709", target="_blank",
                  style="color:#C0392B; font-size:0.85rem; text-decoration:none;")
              )
            )
          ),
          div(class="modal-footer",
            tags$button(class="btn btn-danger btn-sm", `data-bs-dismiss`="modal", "Cerrar")
          )
        )
      )
    )
  )
}

homeServer <- function(id) {
  moduleServer(id, function(input, output, session) {})
}
