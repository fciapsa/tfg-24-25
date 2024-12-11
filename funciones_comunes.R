#INI#________RESUMEN FUNCIONES FICHERO________#INI#
# librerias()
# carga_paquetes()
# Install_Packages( x )
# sustituir_na( dt )
# con_param( param )
# month_number( d )
# diff_month( d1, d2 )
# length_unique( x )
#FIN#________RESUMEN FUNCIONES FICHERO________#FIN#

#INI#____________CARGA LIBRERIAS____________#INI#
librerias <- function() {
  library( lubridate   )
  library( ore         )
  library( stringr     )
  library( stringi     )
  library( DBI         )
  library( dbplyr      )
  library( dplyr       )
  library( tidyr       )
  library( tibble      )
  library( foreach     )
  library( doParallel  )
  library( shiny       )
  library( rstudioapi  )
  library( readr       )
  library( ggplot2     )
  library(TeachingDemos)
}
#FIN#____________CARGA LIBRERIAS____________#FIN#

#INI#____________CARGA PAQUETES____________#INI#
## Función de carga de los paquetes necesarios 
carga_paquetes <- function() {
  list_packages <- c("lubridate",
                     "ore",
                     "stringr",
                     "stringi",
                     "DBI",
                     "dbplyr",
                     "dplyr",
                     "tidyr",
                     "tibble",
                     "foreach",
                     "doParallel",
                     "shiny",
                     "rstudioapi",
                     "readr")
  install.packages(list_packages,configure.args = c(RNetCDF = "--with-netcdf-include=/usr/include/udunits2"))
  
}
#FIN#____________CARGA PAQUETES____________#FIN#

#INI#____________CARGA CSVs____________#INI#
carga_csvs <- function() {
  #Captación realizada por la propia empresa por comunidades y ciudades autónomas, tipo de captación y periodo
  #COSAS A REALIZAR:
  #La columna "Comunidades y Ciudades Autónomas" está vacía para cuando la columna "Total Nacional tiene el valor "Ceuta y Melilla"
  #Asociar a la columna "Comunidades y Ciudades Autónomas" el valor de "18 Ceuta y Melilla" - HECHO
  #Quitar la tilde de la segunda columna (para que no haya problemas a la hora de seleccionarla) - HECHO
  #Quitar la tilde de la tercera columna (para que no haya problemas a la hora de seleccionarla) - HECHO
  # Fuente: https://www.ine.es/up/96pyDkGB
  df_captac <- read_delim("csvs/Captación realizada por la propia empresa por comunidades y ciudades autónomas, tipo de captación y periodo.csv", 
                          delim = ";",
                          col_types = cols(periodo = col_integer(), Total = col_number()),
                          locale = locale(decimal_mark = ",", grouping_mark = "."),
                          na = "..")
  
  # Distribución de agua registrada, usuario y periodo.
  # Fuente: https://ine.es/up/izJimhrq
  aux1 <- read_delim("csvs/Distribución de agua registrada, usuario y periodo.csv",
                     delim = ";",
                     col_types = cols(periodo = col_integer(), Total = col_number()),
                     locale = locale(decimal_mark = ",", grouping_mark = "."),
                     na = "..")
  
  # Volumen de agua disponible (potabilizada y no potabilizada) por comunidades y
  # ciudades autónomas, tipo de indicador y periodo.
  # Fuente: https://ine.es/up/sHkVfTve
  aux2 <- read_delim("csvs/Volumen de agua disponible (potabilizada y no potabilizada) por comunidades y ciudades autónomas, tipo de indicador y periodo.csv",
                     delim = ";",
                     col_types = cols(periodo = col_integer(), Total = col_number()),
                     locale = locale(decimal_mark = ",", grouping_mark = "."))
  
  # Distribución de agua registrada por comunidades y ciudades autónomas, grupos de usuarios e importe y periodo.
  # Fuente: https://ine.es/up/WMtOBGH0
  aux3 <- read_delim("csvs/Distribución de agua registrada por comunidades y ciudades autónomas, grupos de usuarios e importe y periodo.csv", 
                     delim = ";",
                     col_types = cols(periodo = col_integer(), Total = col_number()),
                     locale = locale(decimal_mark = ",", grouping_mark = "."),
                     na = "..")
  
  # Volumen de agua suministrada a la red por comunidades y ciudades autónomas, tipo de indicador y periodo.
  # Fuente: https://ine.es/up/ZQ5YmzAI
  aux4 <- read_delim("csvs/Volumen de agua suministrada a la red por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", 
                     delim = ";",
                     col_types = cols(periodo = col_integer(), Total = col_number()),
                     locale = locale(decimal_mark = ",", grouping_mark = "."),
                     na = "..")
  
  # Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.
  # Fuente: https://ine.es/up/2Hs7okgKi1
  aux5 <- read_delim("csvs/Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", 
                     delim = ";",
                     col_types = cols(periodo = col_integer(), Total = col_number()),
                     locale = locale(decimal_mark = ",", grouping_mark = "."),
                     na = "..")
  
  return( c(df_captac, aux1, aux2, aux3, aux4, aux5) )
}
#FIN#____________CARGA CSVs____________#FIN#

#INI#____________CONTROL ERRORES____________#INI#
#FIN#____________CONTROL ERRORES____________#FIN#

#INI#____________OTRAS FUNCIONES____________#INI#

## Sustituir los NAs por 'NA'
sustituir_na <- function( dt ) {
  for ( i in 1:ncol( dt ) ) {
    if ( class( dt[, i] ) %in% c( "ore.numeric", "ore.integer", "ore.difftime" ) ) {
      dt[, i] <- as.ore.character( dt[,i] )
      dt[is.na( dt[, i] ), i] <- 'NA'
    } else if ( class( dt[, i] ) %in% c( "ore.factor" ) ) {
      dt[is.na(dt[, i]), i] <- 'NA'
    } else if ( class( dt[, i] ) %in% c( "ore.date", "ore.datetime" ) ) {
      dt[, i] <- as.ore.character( dt[,i] )
      dt[is.na( dt[, i] ), i] <- 'NA'
    }
  }
  return( dt )
}

## Obtener los parámetros
con_param <- function( param ) { 
  return( array( unlist( parametros[names( parametros ) == param] ) ) )
}

## Calcula la cantidad de meses
month_number <- function( d ) { 
  lt <- as.POSIXlt( as.Date( d, origin="1500-01-01" ) )
  lt$year*12 + lt$mon + lt$mday/30.4167
}

## EQUIVALENTE AL MONTHS_BETWEEN() pero invirtiendo el orden
diff_month <- function( d1, d2 ) {
  month_number( d2 ) - month_number( d1 )
}

## EQUIVALENTE A COUNT(DISTINCT)
length_unique <- function( x ) {
  length( unique( x[x != 0] ) ) # No contamos los ceros
}
#FIN#____________OTRAS FUNCIONES____________#FIN#