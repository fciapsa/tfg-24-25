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

## Función de carga de los paquetes necesarios (guardados en la carpeta PACKAGES)
carga_paquetes <- function() {
  list_packages <- data.frame( "Package" = unique( installed.packages()[,"Package"] ) )
  aux <- c( "HIGHCHARTER_package"    = "highcharter",
            "ORE151_package"         = "ORE",
            "XLSX_package"           = "xlsx",
            "DPLYR_package"          = "dplyr",
            "RHANDSONTABLE_package"  = "rhandsontable",
            "PLYR_package"           = "plyr",
            "SHINY_package"          = "shiny",
            "SHINYDASHBOARD_package" = "shinydashboard",
            "TIDYR_package"          = "tidyr",
            "DT_package"             = "DT",
            "READR_package"          = "readr",
            "RCURL_package"          = "RCurl",
            "R.UTILS_package"        = "R.utils",
            "SQLDF_package"          = "sqldf" )
  
  for ( paquete in setdiff( aux, list_packages[,"Package"] ) ) {
    Install_Packages( names( which( aux == paquete ) ) )
  }
  
  for ( libreria in aux ) {
    library( libreria, character.only = T )
  }
}

## Función que instala los paquetes
Install_Packages <- function( x ){
  if ( !file.exists( paste( "/PACKAGES/", x, sep = "" ) ) ) { 
    stop( "Nombre erroneo o no existe. Utilice: NOMBREPAQUETE_package" ) 
  }
  
  temp <- dir( "~/R/x86_64-unknown-linux-gnu-library/3.2/" )
  
  if ( sum( substr( temp, 1, 6 ) == "00LOCK" ) >= 1 ) {
    clean <- temp[( substr( temp, 1, 6 ) == "00LOCK" )]
    invisible( lapply( 1:length( clean ), FUN = function(i) {
      unlink( paste( "~/R/x86_64-unknown-linux-gnu-library/3.2/", clean[i], "/", sep = "" ), recursive = TRUE ) 
    } ) )
  }
  
  if ( sum( substr( temp, 1, 6 ) == "00LOCK" ) >= 1 ) {
    cat( "\n Ha habido un error en la instalacion del paquete. Ejecute la siguiente linea de comandos: \n\n Install_Packages(\"", x , "\") \n\n\n", sep = "" )
    
    .rs.restartR()
    stop( NULL, call. = F )
  }
  
  a <- dir( "/PACKAGES/" )
  
  if ( sum( x == a ) == 1 ) {
    dir( paste( "/PACKAGES/", x, "/packages/", sep = "" ) )
    t <- read.table( paste( "/PACKAGES/", x, "/", x, "_dep.txt", sep = "" ) )
    n <- 1:nrow( t )
    
    if ( sum( grepl( "nloptr_", t$V1 ) ) == 1 ) {
      remove.packages( "nloptr" )
      system( "cp -r /PACKAGES/nloptr ~/R/x86_64-unknown-linux-gnu-library/3.2/" )
      
      nloptr <- grep( "nloptr_", t$V1 )
      n <- n[-nloptr]
    }
    
    if ( sum( grepl("stringi_", t$V1 ) ) == 1 ) {
      remove.packages( "stringi" )
      system( "cp -r /PACKAGES/stringi ~/R/x86_64-unknown-linux-gnu-library/3.2/" )
      
      stringi <- grep( "stringi_", t[n,"V1"] )
      n <- n[-stringi]
    }
    
    if ( sum( grepl( "-master.tar.gz", t$V1 ) ) == 1 ) {
      paquete_m <- substr( t$V1[grepl( "-master.tar.gz", t$V1 )], 1, ( nchar( as.character( t$V1[grepl("-master.tar.gz", t$V1 )] ) ) - 14 ) )
      remove.packages( paquete_m )
      system( paste( "cp -r /PACKAGES/", paquete_m, " ~/R/x86_64-unknown-linux-gnu-library/3.2/", sep = "" ) )
      
      master_p <- grep( "-master.tar.gz", t[n,"V1"] )
      n <- n[-master_p]
    }
    
    invisible( lapply( n, FUN = function( i ) {
      install.packages( paste( "/PACKAGES/", x, "/", t[i,], sep = "" ), 
                        repos = NULL,
                        lib = "~/R/x86_64-unknown-linux-gnu-library/3.2/") 
    } ) )
  }
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