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

