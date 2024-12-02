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

# Renombramiento de las columnas utilizando estilo snake_case
names(aux1)[1] <- "grupos_usuarios"
# names(aux1)[2] <- "periodo"
names(aux1)[3] <- "total"

names(aux2)[1] <- "total_nacional"
names(aux2)[2] <- "comunidades_ciudades_autonomas"
names(aux2)[3] <- "tipo_indicador"
# names(aux2)[4] <- "periodo"
names(aux2)[5] <- "total"

names(aux3)[1] <- "total_nacional"
names(aux3)[2] <- "comunidades_ciudades_autonomas"
names(aux3)[3] <- "grupos_usuarios_importe"
# names(aux3)[4] <- "periodo"
names(aux3)[5] <- "total"

names(aux4)[1] <- "total_nacional"
names(aux4)[2] <- "comunidades_ciudades_autonomas"
names(aux4)[3] <- "tipo_indicador"
# names(aux4)[4] <- "periodo"
names(aux4)[5] <- "total"

names(aux5)[1] <- "total_nacional"
names(aux5)[2] <- "comunidades_ciudades_autonomas"
names(aux5)[3] <- "tipo_indicador"
# names(aux5)[4] <- "periodo"
names(aux5)[5] <- "total"

# Limpieza: Eliminación de las filas sin valores
aux1 <- drop_na(aux1, "total")
aux2 <- drop_na(aux2, "total")
aux3 <- drop_na(aux3, "total")
aux4 <- drop_na(aux4, "total")
aux5 <- drop_na(aux5, "total")

# Factorización de las columnas que contienen datos categóricos
aux1$grupos_usuarios <- factor(aux1$grupos_usuarios)
aux1$periodo <- factor(aux1$periodo)

aux2$comunidades_ciudades_autonomas <- factor(aux2$comunidades_ciudades_autonomas)
aux2$tipo_indicador <- factor(aux2$tipo_indicador)
aux2$periodo <- factor(aux2$periodo)

aux3$comunidades_ciudades_autonomas <- factor(aux3$comunidades_ciudades_autonomas)
aux3$grupos_usuarios_importe <- factor(aux3$grupos_usuarios_importe)
aux3$periodo <- factor(aux3$periodo)

aux4$comunidades_ciudades_autonomas <- factor(aux4$comunidades_ciudades_autonomas)
aux4$tipo_indicador <- factor(aux4$tipo_indicador)
aux4$periodo <- factor(aux4$periodo)

aux5$comunidades_ciudades_autonomas <- factor(aux5$comunidades_ciudades_autonomas)
aux5$tipo_indicador <- factor(aux5$tipo_indicador)
aux5$periodo <- factor(aux5$periodo)
