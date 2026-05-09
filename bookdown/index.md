---
title: "Análisis Exploratorio de Indicadores de Salud y Factores Asociados a Enfermedades Cardíacas"
subtitle: "Encuesta BRFSS 2015"
author: "Tu Nombre"
date: "09 de mayo de 2026"
site: bookdown::bookdown_site
documentclass: book
bibliography: references.bib
biblio-style: apalike
link-citations: yes
description: "EDA sobre los factores de riesgo cardiovascular en el dataset BRFSS 2015, incluyendo análisis univariado, bivariado y modelado predictivo con XGBoost."
---

# Prefacio {-}

Este libro documenta un análisis exploratorio de datos (EDA) completo sobre el dataset
**BRFSS 2015**, que contiene respuestas de 253.680 estadounidenses sobre conductas de
riesgo, enfermedades crónicas y uso de servicios preventivos.

El objetivo central es identificar qué factores conductuales, clínicos y
sociodemográficos presentan mayor asociación con el riesgo de enfermedad cardíaca,
y construir un clasificador predictivo capaz de detectar casos positivos a partir
de respuestas de encuesta.

## Estructura del libro {-}

| Capítulo | Contenido |
|---|---|
| 1 | Introducción, marco teórico y objetivos |
| 2 | Carga, limpieza y validación de datos |
| 3 | Análisis univariado por tipo de variable |
| 4 | Análisis bivariado e interacciones |
| 5 | Hallazgos principales |
| 6 | Modelado predictivo y selección de clasificador |
| 7 | Referencias bibliográficas |

## Datos {-}

El dataset utilizado es la versión depurada del BRFSS 2015, disponible en
[Kaggle](https://www.kaggle.com/datasets/alexteboul/heart-disease-health-indicators-dataset).
Descárgalo y colócalo en la carpeta `data/` con el nombre
`heart_disease_health_indicators_BRFSS2015.csv`.

## Reproducibilidad {-}




