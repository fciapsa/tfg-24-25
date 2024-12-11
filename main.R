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

#Captación realizada por la propia empresa por comunidades y ciudades autónomas, tipo de captación y periodo
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
#FIN#____________LECTURA DE LOS CSVS____________#FIN#

#INI#____________CONFIGURADACION DE LOS DF OBTENIDOS____________#INI#

########################################################################################################
#Asociamos el valor "Ceuta y Melilla" a la columna 2 del df "df_captac",
#que se encuentra vacia para estos casos en el csv inicial
num_filas <- 1

while (num_filas <= nrow(df_captac)) {
  if (df_captac[num_filas,1] == "Ceuta y Melilla") {
    df_captac[num_filas,2] <- "Ceuta y Melilla"
  } 
  num_filas <- num_filas + 1
}

#Filtramos por este valor en el df para comprobar la actualización
filter(df_captac, `Total Nacional` == "Ceuta y Melilla") %>%
  mutate(`Comunidades y Ciudades Autónomas 2` <- "Ceuta y Melilla")
########################################################################################################

########################################################################################################
#Renombrar la columna 1 del df "aux1"
names(aux1)[1]  <- 'Usuarios'

#Mostrar valores únicos del df
unique((aux1$Total))

#Borrar valores NA del df
aux1 <- na.omit(aux1)

#Factorizamos las columnas
aux1$Usuarios <- factor(aux1$Usuarios)
aux1$periodo <- factor(aux1$periodo)
########################################################################################################


#FIN#____________CONFIGURADACION DE LOS DF OBTENIDOS____________#FIN#


#INI#____________VISUALIZACIÓN DE LOS DFs____________#INI#

#Diagrama de barras de df "aux1" categorizado por tipos de usuarios
ggplot(aux1) +
  geom_col(aes(x = periodo, y = Total, fill = Usuarios), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "right"  
  ) 


aux1_sin_totales <- filter(aux1, Usuarios != 'Total')
table(aux1$Usuarios, aux1$Total)

#Diagrama de barras de df "aux1_sin_totales" categorizado por tipos de usuarios
ggplot(aux1_sin_totales) +
  geom_col(aes(x = periodo, y = Total, fill = Usuarios), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de barras de df "aux1_sin_totales" categorizado por periodo (año)
ggplot(aux1_sin_totales) +
  geom_col(aes(x = Usuarios, y = Total, fill = periodo ), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de dispersión de df "aux1_sin_totales" categorizado por tipos de usuarios
ggplot(aux1_sin_totales) +
  geom_point(aes(x = periodo, y = Total, color = Usuarios)) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8)) 

#Diagrama de dispersión de df "aux1_sin_totales" categorizado por tipos de usuarios de manera individual en vertical
ggplot(aux1_sin_totales) +
  geom_point(aes(x = periodo, y = Total, color = Usuarios)) +
  facet_grid( Usuarios ~ .) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  ) 

#Diagrama de dispersión de df "aux1_sin_totales" categorizado por tipos de usuarios de manera individual en diferentes diagramas
ggplot(aux1_sin_totales) +
  geom_point(aes(x = periodo, y = Total, color = Usuarios)) +
  facet_wrap( Usuarios ~ ., nrow = 2) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  )
#FIN#____________VISUALIZACIÓN DE LOS DFs____________#FIN#

#######################################################################################################
#######################################################################################################