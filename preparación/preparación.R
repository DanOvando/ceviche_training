#Asegura que tienes connection al internet
# Core estos lineas

R.version$version.string

# Si tienes una version mucho menos de 3.3.1 debes installer la version de R mas recien

install.packages('tidyverse')

install.packages('scales')

install.packages('stringr')

install.packages('gridextra')

install.packages('broom')

install.packages('forcats')

install.packages('devtools')

install.packages('readxl')

install.packages('fishmethods')

devtools::install_github('AdrianHordyk/LBSPR', build_vignettes = T)
