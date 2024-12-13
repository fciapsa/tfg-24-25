#######################################################################################################
#############TFG 2024/2025 - Ciclo del Agua - Flavius Abel Ciapsa & Pablo Martínez Domingo#############
#######################################################################################################

#INI#____________CONFIGURAR DIRECTORIO ACTUAL____________#INI#
current_directory = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_directory)
#FIN#____________CONFIGURAR DIRECTORIO ACTUAL____________#FIN#

#INI#____________CARGA ARCHIVOS R AUXILIARES____________#INI#
source( "funciones_comunes.R" )
#FIN#____________CARGA ARCHIVOS R AUXILIARES____________#FIN#

#INI#____________CONFIGURACIÓN INICIAL DEPENDENCIAS____________#INI#
## Instalación de paquetes necesarios (solo necesario la primera vez que se ejecuta)
#carga_paquetes()
## Carga de librerías necesarias
librerias()
#FIN#____________CONFIGURACIÓN INICIAL DEPENDENCIAS____________#FIN#

#INI#____________LECTURA DE LOS CSVS____________#INI#
#carga_csvs()

#Captación realizada por la propia empresa por comunidades y ciudades autónomas, tipo de captación y periodo
  #COSAS A REALIZAR:
    #La columna "Comunidades y Ciudades Autónomas" está vacía para cuando la columna "Total Nacional tiene el valor "Ceuta y Melilla"
      #Asociar a la columna "Comunidades y Ciudades Autónomas" el valor de "18 Ceuta y Melilla" - HECHO
    #Quitar la tilde de la segunda columna (para que no haya problemas a la hora de seleccionarla) - HECHO
    #Quitar la tilde de la tercera columna (para que no haya problemas a la hora de seleccionarla) - HECHO
# Fuente: https://www.ine.es/up/96pyDkGB
df_captacion <- read_delim("csvs/Captación realizada por la propia empresa por comunidades y ciudades autónomas, tipo de captación y periodo.csv", 
                        delim = ";",
                        col_types = cols(periodo = col_integer(), Total = col_number()),
                        locale = locale(decimal_mark = ",", grouping_mark = "."),
                        na = "..")

# Distribución de agua registrada, usuario y periodo.
# Fuente: https://ine.es/up/izJimhrq
df_distribucion <- read_delim("csvs/Distribución de agua registrada, usuario y periodo.csv",
                   delim = ";",
                   col_types = cols(periodo = col_integer(), Total = col_number()),
                   locale = locale(decimal_mark = ",", grouping_mark = "."),
                   na = "..")

# Volumen de agua disponible (potabilizada y no potabilizada) por comunidades y
# ciudades autónomas, tipo de indicador y periodo.
# Fuente: https://ine.es/up/sHkVfTve
df_volumen <- read_delim("csvs/Volumen de agua disponible (potabilizada y no potabilizada) por comunidades y ciudades autónomas, tipo de indicador y periodo.csv",
                   delim = ";",
                   col_types = cols(periodo = col_integer(), Total = col_number()),
                   locale = locale(decimal_mark = ",", grouping_mark = "."))

# Distribución de agua registrada por comunidades y ciudades autónomas, grupos de usuarios e importe y periodo.
# Fuente: https://ine.es/up/WMtOBGH0
df_distribucion_categorizada <- read_delim("csvs/Distribución de agua registrada por comunidades y ciudades autónomas, grupos de usuarios e importe y periodo.csv", 
                   delim = ";",
                   col_types = cols(periodo = col_integer(), Total = col_number()),
                   locale = locale(decimal_mark = ",", grouping_mark = "."),
                   na = "..")

# Volumen de agua suministrada a la red por comunidades y ciudades autónomas, tipo de indicador y periodo.
# Fuente: https://ine.es/up/ZQ5YmzAI
df_volumen_categorizada <- read_delim("csvs/Volumen de agua suministrada a la red por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", 
                   delim = ";",
                   col_types = cols(periodo = col_integer(), Total = col_number()),
                   locale = locale(decimal_mark = ",", grouping_mark = "."),
                   na = "..")

# Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.
# Fuente: https://ine.es/up/2Hs7okgKi1
df_residuales <- read_delim("csvs/Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.csv", 
                   delim = ";",
                   col_types = cols(periodo = col_integer(), Total = col_number()),
                   locale = locale(decimal_mark = ",", grouping_mark = "."),
                   na = "..")
#FIN#____________LECTURA DE LOS CSVS____________#FIN#

#INI#____________CONFIGURACION DE LOS DF OBTENIDOS____________#INI#

# Renombramiento de las columnas utilizando estilo snake_case
names(df_captacion)[1]  <- 'total_nacional'
names(df_captacion)[2]  <- 'comunidades_ciudades_autonomas'
names(df_captacion)[3]  <- 'tipo_captacion'
#names(df_captacion)[4]  <- 'periodo'
names(df_captacion)[5]  <- 'total'

names(df_distribucion)[1] <- "grupos_usuarios"
# names(df_distribucion)[2] <- "periodo"
names(df_distribucion)[3] <- "total"

names(df_volumen)[1] <- "total_nacional"
names(df_volumen)[2] <- "comunidades_ciudades_autonomas"
names(df_volumen)[3] <- "tipo_indicador"
# names(df_volumen)[4] <- "periodo"
names(df_volumen)[5] <- "total"

names(df_distribucion_categorizada)[1] <- "total_nacional"
names(df_distribucion_categorizada)[2] <- "comunidades_ciudades_autonomas"
names(df_distribucion_categorizada)[3] <- "grupos_usuarios_importe"
# names(df_distribucion_categorizada)[4] <- "periodo"
names(df_distribucion_categorizada)[5] <- "total"

names(df_volumen_categorizada)[1] <- "total_nacional"
names(df_volumen_categorizada)[2] <- "comunidades_ciudades_autonomas"
names(df_volumen_categorizada)[3] <- "tipo_indicador"
# names(df_volumen_categorizada)[4] <- "periodo"
names(df_volumen_categorizada)[5] <- "total"

names(df_residuales)[1] <- "total_nacional"
names(df_residuales)[2] <- "comunidades_ciudades_autonomas"
names(df_residuales)[3] <- "tipo_indicador"
# names(df_residuales)[4] <- "periodo"
names(df_residuales)[5] <- "total"

# Limpieza: Eliminación de las filas sin valores
df_captacion <- drop_na(df_captacion, "total")
df_distribucion <- drop_na(df_distribucion, "total")
df_volumen <- drop_na(df_volumen, "total")
df_distribucion_categorizada <- drop_na(df_distribucion_categorizada, "total")
df_volumen_categorizada <- drop_na(df_volumen_categorizada, "total")
df_residuales <- drop_na(df_residuales, "total")

# Combinación de las columnas "total_nacional" y "comunidades_ciudades_autonomas"
# en una única columna que sintetiza la información de ambas
df_captacion[df_captacion$total_nacional == "Total Nacional" &
               df_captacion$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "00 España"
df_captacion[df_captacion$total_nacional == "Ceuta y Melilla" &
               df_captacion$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "18 Ceuta y Melilla"

df_volumen[df_volumen$total_nacional == "Total Nacional" &
       is.na(df_volumen$comunidades_ciudades_autonomas),]$comunidades_ciudades_autonomas = "00 España"
df_volumen[df_volumen$total_nacional == "Ceuta y Melilla" &
       is.na(df_volumen$comunidades_ciudades_autonomas),]$comunidades_ciudades_autonomas = "18 Ceuta y Melilla"

df_distribucion_categorizada[df_distribucion_categorizada$total_nacional == "Total Nacional" &
       df_distribucion_categorizada$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "00 España"
df_distribucion_categorizada[df_distribucion_categorizada$total_nacional == "Ceuta y Melilla" &
       df_distribucion_categorizada$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "18 Ceuta y Melilla"

df_volumen_categorizada[df_volumen_categorizada$total_nacional == "Total Nacional" &
       df_volumen_categorizada$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "00 España"
df_volumen_categorizada[df_volumen_categorizada$total_nacional == "Ceuta y Melilla" &
       df_volumen_categorizada$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "18 Ceuta y Melilla"

df_residuales[df_residuales$total_nacional == "Total Nacional" &
       df_residuales$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "00 España"
df_residuales[df_residuales$total_nacional == "Ceuta y Melilla" &
       df_residuales$comunidades_ciudades_autonomas == "",]$comunidades_ciudades_autonomas = "18 Ceuta y Melilla"

# Factorización de las columnas que contienen datos categóricos
df_captacion$comunidades_ciudades_autonomas <- factor(df_captacion$comunidades_ciudades_autonomas)
df_captacion$tipo_captacion <- factor(df_captacion$tipo_captacion)
df_captacion$periodo <- factor(df_captacion$periodo)

df_distribucion$grupos_usuarios <- factor(df_distribucion$grupos_usuarios)
df_distribucion$periodo <- factor(df_distribucion$periodo)

df_volumen$comunidades_ciudades_autonomas <- factor(df_volumen$comunidades_ciudades_autonomas)
df_volumen$tipo_indicador <- factor(df_volumen$tipo_indicador)
df_volumen$periodo <- factor(df_volumen$periodo)

df_distribucion_categorizada$comunidades_ciudades_autonomas <- factor(df_distribucion_categorizada$comunidades_ciudades_autonomas)
df_distribucion_categorizada$grupos_usuarios_importe <- factor(df_distribucion_categorizada$grupos_usuarios_importe)
df_distribucion_categorizada$periodo <- factor(df_distribucion_categorizada$periodo)

df_volumen_categorizada$comunidades_ciudades_autonomas <- factor(df_volumen_categorizada$comunidades_ciudades_autonomas)
df_volumen_categorizada$tipo_indicador <- factor(df_volumen_categorizada$tipo_indicador)
df_volumen_categorizada$periodo <- factor(df_volumen_categorizada$periodo)

df_residuales$comunidades_ciudades_autonomas <- factor(df_residuales$comunidades_ciudades_autonomas)
df_residuales$tipo_indicador <- factor(df_residuales$tipo_indicador)
df_residuales$periodo <- factor(df_residuales$periodo)

#FIN#____________CONFIGURACION DE LOS DF OBTENIDOS____________#FIN#


#INI#____________VISUALIZACIÓN DE LOS DFs____________#INI#

#Diagrama de barras de df "df_distribucion" categorizado por tipos de usuarios
ggplot(df_distribucion) +
  geom_col(aes(x = periodo, y = total, fill = grupos_usuarios), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "right"  
  ) 


df_distribucion_sin_totales <- filter(df_distribucion, grupos_usuarios != 'Total')

#Diagrama de barras de df "df_distribucion_sin_totales" categorizado por tipos de usuarios
ggplot(df_distribucion_sin_totales) +
  geom_col(aes(x = periodo, y = total, fill = grupos_usuarios), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de barras de df "df_distribucion_sin_totales" categorizado por periodo (año)
ggplot(df_distribucion_sin_totales) +
  geom_col(aes(x = grupos_usuarios, y = total, fill = periodo ), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de dispersión de df "df_distribucion_sin_totales" categorizado por tipos de usuarios
ggplot(df_distribucion_sin_totales) +
  geom_point(aes(x = periodo, y = total, color = grupos_usuarios)) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8)) 

#Diagrama de dispersión de df "df_distribucion_sin_totales" categorizado por tipos de usuarios de manera individual en vertical
ggplot(df_distribucion_sin_totales) +
  geom_point(aes(x = periodo, y = total, color = grupos_usuarios)) +
  facet_grid( grupos_usuarios ~ .) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  ) 

#Diagrama de dispersión de df "df_distribucion_sin_totales" categorizado por tipos de usuarios de manera individual en diferentes diagramas
ggplot(df_distribucion_sin_totales) +
  geom_point(aes(x = periodo, y = total, color = grupos_usuarios)) +
  facet_wrap( grupos_usuarios ~ ., nrow = 2) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  )
#FIN#____________VISUALIZACIÓN DE LOS DFs____________#FIN#

#######################################################################################################
#######################################################################################################