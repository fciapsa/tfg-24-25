#######################################################################################################
#INI#____________CARGA ARCHIVOS R AUXILIARES____________#INI#
source( "funciones_comunes.R" )
#FIN#____________CARGA ARCHIVOS R AUXILIARES____________#FIN#

#INI#____________CONFIGURACIÓN INICIAL DEPENDENCIAS____________#INI#
## Instalación de paquetes necesarios (solo necesario la primera vez)
#carga_paquetes()
## Carga de librerías necesarias
librerias()
#FIN#____________CONFIGURACIÓN INICIAL DEPENDENCIAS____________#FIN#

# Configurar el directorio que contiene este script como el directorio de trabajo
current_directory = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_directory)

# Carga de .csv necesarios
aux1 <- read.csv2( "csvs/Distribución de agua registrada, usuario y periodo.csv",  header = TRUE, stringsAsFactor = FALSE, encoding = "UTF-8" )
aux2 <- read.csv2( "csvs/Volumen de agua disponible (potabilizada y no potabilizada) por comunidades y ciudades autónomas, tipo de indicador y periodo.csv",  header = TRUE, stringsAsFactor = FALSE, encoding = "UTF-8" )
aux3 <- read.csv2( "csvs/Distribución de agua registrada por comunidades y ciudades autónomas, grupos de usuarios e importe y periodo.csv", header = TRUE, stringsAsFactor = FALSE, encoding = "UTF-8" )
aux4 <- read.csv2( "csvs/Volumen de agua suministrada a la red por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", header = TRUE, stringsAsFactor = FALSE, encoding = "UTF-8" )
aux5 <- read.csv2( "csvs/Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", header = TRUE, stringsAsFactor = FALSE, encoding = "UTF-8" )

#######################################################################################################