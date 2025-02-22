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
  files <- list(
    list("path" = "csvs/Captación realizada por la propia empresa por comunidades y ciudades autónomas, tipo de captación y periodo.csv", 
         "col_types" = cols(periodo = col_integer(), Total = col_number())),
    list("path" = "csvs/Distribución de agua registrada, usuario y periodo.csv",
         "col_types" = cols(periodo = col_integer(), Total = col_number())),
    list("path" = "csvs/Volumen de agua disponible (potabilizada y no potabilizada) por comunidades y ciudades autónomas, tipo de indicador y periodo.csv",
         "col_types" = cols(periodo = col_integer(), Total = col_number())),
    list("path" = "csvs/Distribución de agua registrada por comunidades y ciudades autónomas, grupos de usuarios e importe y periodo.csv",
         "col_types" = cols(periodo = col_integer(), Total = col_number())),
    list("path" = "csvs/Volumen de agua suministrada a la red por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", 
         "col_types" = cols(periodo = col_integer(), Total = col_number())),
    list("path" = "csvs/Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", 
         "col_types" = cols(periodo = col_integer(), Total = col_number()))
  )
  
  data_list <- lapply(files, function(file) {
    cargar_csv_limpio(file$path, file$col_types)
  })
  
  return(data_list)
}

cargar_csv_limpio <- function(file, col_types) {
  df <- read_delim(file, delim = ";", col_types = col_types, locale = locale(decimal_mark = ",", grouping_mark = "."), na = "..", col_names = TRUE)
  names(df) <- eliminar_tildes(names(df))
  return(df)
}
#FIN#____________CARGA CSVs____________#FIN#

#INI#____________CONTROL ERRORES____________#INI#
#FIN#____________CONTROL ERRORES____________#FIN#

#INI#____________OTRAS FUNCIONES____________#INI#

eliminar_tildes <- function(texto) {
  return(gsub("á", "a", gsub("é", "e", gsub("í", "i", gsub("ó", "o", gsub("ú", "u", texto))))))
}

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