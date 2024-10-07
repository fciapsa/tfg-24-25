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
  library( lubridate  )
  library( ore        )
  library( stringr    )
  library( stringi    )
  library( DBI        )
  library( dbplyr     )
  library( dplyr      )
  library( tidyr      )
  library( tibble     )
  library( foreach    )
  library( doParallel )
}

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
                     "doParallel")
  install.packages(list_packages,configure.args = c(RNetCDF = "--with-netcdf-include=/usr/include/udunits2"))
  
}
#FIN#____________CARGA LIBRERIAS____________#FIN#

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

## EQUIVALENTE AL MONTHS_BETWEEN() pero invirtiendo el orden:
diff_month <- function( d1, d2 ) {
  month_number( d2 ) - month_number( d1 )
}

## EQUIVALENTE A COUNT(DISTINCT)
length_unique <- function( x ) {
  length( unique( x[x != 0] ) ) # No contamos los ceros
}
#FIN#____________OTRAS FUNCIONES____________#FIN#