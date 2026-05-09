# EDA: Indicadores de Salud y Enfermedades Cardíacas — BRFSS 2015

Análisis exploratorio completo sobre el dataset BRFSS 2015, construido como
**bookdown** en R.

## Contenido

| Capítulo | Descripción |
|---|---|
| 1 · Introducción | Marco teórico, objetivos y diccionario de variables |
| 2 · Limpieza | Nulos, duplicados, rangos y outliers |
| 3 · Univariado | Distribución de binarias, ordinales y continuas |
| 4 · Bivariado | Chi², V de Cramér, Mann-Whitney, interacciones |
| 5 · Hallazgos | Síntesis de factores de riesgo identificados |
| 6 · Modelado | LogReg, RF, XGBoost — threshold tuning y modelo final |
| 7 · Referencias | Bibliografía y `sessionInfo()` |

## Requisitos

```r
install.packages(c(
  "tidyverse", "scales", "ggplot2", "corrplot",
  "caret", "xgboost", "pROC", "MLmetrics",
  "randomForest", "gridExtra", "knitr", "kableExtra",
  "bookdown"
))
```

## Datos

Descarga el dataset desde
[Kaggle](https://www.kaggle.com/datasets/alexteboul/heart-disease-health-indicators-dataset)
y colócalo en `data/heart_disease_health_indicators_BRFSS2015.csv`.

## Compilar el libro

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

El resultado queda en `_book/`. Abre `_book/index.html` en tu navegador.

## Publicar en GitHub Pages

```bash
# Compilar primero el libro
Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::gitbook")'

# Subir _book/ como rama gh-pages
git checkout --orphan gh-pages
git rm -rf .
cp -r _book/* .
git add .
git commit -m "Deploy book"
git push origin gh-pages
```

Luego en **Settings → Pages**, elige la rama `gh-pages` como fuente.
El libro quedará disponible en `https://<tu-usuario>.github.io/<nombre-repo>/`.

## Estructura del proyecto

```
eda-cardiaco-bookdown/
├── _bookdown.yml       ← configuración del libro
├── _output.yml         ← formatos de salida (gitbook, PDF)
├── index.Rmd           ← portada y setup global
├── 01-introduccion.Rmd
├── 02-limpieza.Rmd
├── 03-univariado.Rmd
├── 04-bivariado.Rmd
├── 05-hallazgos.Rmd
├── 06-modelado.Rmd
├── 07-referencias.Rmd
├── style.css           ← estilos personalizados
├── header.html         ← meta tags HTML
├── preamble.tex        ← configuración LaTeX para PDF
├── references.bib      ← bibliografía BibTeX
├── .gitignore
└── data/               ← coloca aquí el CSV del dataset
```
