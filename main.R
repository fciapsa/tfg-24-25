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

#INI#____________CONFIGURADACION DE LOS DF OBTENIDOS____________#INI#

########################################################################################################
names(df_captacion)[2]  <- 'Comunidades y Ciudades Autonomas'
names(df_captacion)[3]  <- 'Tipo de captacion'

#Asociamos el valor "Ceuta y Melilla" a la columna 2 del df "df_captacion",
#que se encuentra vacia para estos casos en el csv inicial
num_filas <- 1

while (num_filas <= nrow(df_captacion)) {
  if (df_captacion[num_filas,1] == "Ceuta y Melilla") {
    df_captacion[num_filas,2] <- " 18 Ceuta y Melilla"
  }else if (df_captacion[num_filas,1] == "Total Nacional" & df_captacion[num_filas,2] == "") {
    df_captacion[num_filas,2] <- "00 Total"
  }
  num_filas <- num_filas + 1
}

#Filtramos por este valor en el df para comprobar la actualización
filter(df_captacion, `Total Nacional` == "Ceuta y Melilla") #%>%
  #filter(df_captacion, `Comunidades y Ciudades Autonomas` == "18 Ceuta y Melilla") #%>%
  #mutate(`Comunidades y Ciudades Autonomas` <- "18 Ceuta y Melilla")

########################################################################################################

########################################################################################################
#Renombrar la columna 1 del df "df_distribucion"
names(df_distribucion)[1]  <- 'Usuarios'

#Mostrar valores únicos del df
unique((df_distribucion$Total))

#Borrar valores NA del df
df_distribucion <- na.omit(df_distribucion)

#Factorizamos las columnas
df_distribucion$Usuarios <- factor(df_distribucion$Usuarios)
df_distribucion$periodo <- factor(df_distribucion$periodo)
########################################################################################################


#FIN#____________CONFIGURADACION DE LOS DF OBTENIDOS____________#FIN#


#INI#____________VISUALIZACIÓN DE LOS DFs____________#INI#

#Diagrama de barras de df "df_distribucion" categorizado por tipos de usuarios
ggplot(df_distribucion) +
  geom_col(aes(x = periodo, y = Total, fill = Usuarios), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "right"  
  ) 


df_distribucion_sin_totales <- filter(df_distribucion, Usuarios != 'Total')
table(df_distribucion$Usuarios, df_distribucion$Total)

#Diagrama de barras de df "df_distribucion_sin_totales" categorizado por tipos de usuarios
ggplot(df_distribucion_sin_totales) +
  geom_col(aes(x = periodo, y = Total, fill = Usuarios), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de barras de df "df_distribucion_sin_totales" categorizado por periodo (año)
ggplot(df_distribucion_sin_totales) +
  geom_col(aes(x = Usuarios, y = Total, fill = periodo ), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de dispersión de df "df_distribucion_sin_totales" categorizado por tipos de usuarios
ggplot(df_distribucion_sin_totales) +
  geom_point(aes(x = periodo, y = Total, color = Usuarios)) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8)) 

#Diagrama de dispersión de df "df_distribucion_sin_totales" categorizado por tipos de usuarios de manera individual en vertical
ggplot(df_distribucion_sin_totales) +
  geom_point(aes(x = periodo, y = Total, color = Usuarios)) +
  facet_grid( Usuarios ~ .) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  ) 

#Diagrama de dispersión de df "df_distribucion_sin_totales" categorizado por tipos de usuarios de manera individual en diferentes diagramas
ggplot(df_distribucion_sin_totales) +
  geom_point(aes(x = periodo, y = Total, color = Usuarios)) +
  facet_wrap( Usuarios ~ ., nrow = 2) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  )
#FIN#____________VISUALIZACIÓN DE LOS DFs____________#FIN#

view(df_captacion)
view(df_distribucion)
view(df_volumen)
view(df_distribucion_categorizada)
view(df_volumen_categorizada)
view(df_residuales)

#######################################################################################################
#######################################################################################################