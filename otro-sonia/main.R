library(readr)
library(ggplot2)
library(dplyr)
library(flexdashboard)

# Recogida y tratamiento de las aguas residuales por comunidades y ciudades autónomas, tipo de indicador y periodo.
df_agua <- read_delim("53450.csv", delim = "\t", 
                     escape_double = FALSE, col_types = cols(Total = col_number()), 
                     locale = locale(decimal_mark = ",", grouping_mark = ".", 
                                     encoding = "latin1"), trim_ws = TRUE)

names(df_agua)[1] <- 'total_nacional'
names(df_agua)[2] <- 'comunidades_ciudades_autonomas'
names(df_agua)[3] <- 'tipo_indicador'
names(df_agua)[4] <- 'periodo'
names(df_agua)[5] <- 'total'

df_agua$total_nacional <- factor(df_agua$total_nacional)
df_agua$comunidades_ciudades_autonomas <- factor(df_agua$comunidades_ciudades_autonomas)
df_agua$tipo_indicador <- factor(df_agua$tipo_indicador)
df_agua$periodo <- factor(df_agua$periodo)

#Quitar los NA

df_agua <- na.omit(df_agua)

# DataFrame con los datos de poblaciones por año y CCAA
df_poblacion <- read_delim("02003.csv", delim = "\t", 
                           escape_double = FALSE, col_types = cols(Total = col_number()), 
                           locale = locale(decimal_mark = ",", grouping_mark = ".", 
                                           encoding = "latin1"), trim_ws = TRUE)

names(df_poblacion)[1] <- 'total_nacional'
names(df_poblacion)[2] <- 'comunidades_ciudades_autonomas'
names(df_poblacion)[3] <- 'edad'
names(df_poblacion)[4] <- 'nacionalidad'
names(df_poblacion)[5] <- 'sexo'
names(df_poblacion)[6] <- 'periodo'
names(df_poblacion)[7] <- 'total'

df_poblacion$comunidades_ciudades_autonomas <- factor(df_poblacion$comunidades_ciudades_autonomas)
df_poblacion$periodo <- factor(df_poblacion$periodo)

#Quitar los NA

df_poblacion <- na.omit(df_poblacion)

# Filtramos la información que nos sobra
df_poblacion <- select(df_poblacion, comunidades_ciudades_autonomas, periodo, total)

# Mergeamos ambos DataFrames y renombramos sus columnas de totales
df <- merge(df_agua, df_poblacion, by = c("comunidades_ciudades_autonomas", "periodo"))
names(df)[5] <- 'total_agua'
names(df)[6] <- 'total_poblacion'


#total
  
ggplot(df_agua, aes(x = comunidades_ciudades_autonomas, y = total, fill=periodo)) +
  geom_col() +
  labs(title = "Captacion realizada por la propia empresa por comunidades \ny ciudades autonomas, tipo de captación y periodo.",
       subtitle = "",
       x = "Comunidades y ciudades autónomas",
       y = "Total",
       caption = "Datos tomados del INE"
  ) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8))

#agua reutilizada

agua_reutilizada <- df_agua %>% 
  filter(tipo_indicador == "Volumen total de agua reutilizada")

ggplot(agua_reutilizada, aes(x = comunidades_ciudades_autonomas, y = total, fill=periodo)) +
  geom_col() +
  labs(title = "Agua reutilizada por comunidades \ny ciudades autonomas, tipo de captación y periodo.",
       subtitle = "",
       x = "Comunidades y ciudades autónomas",
       y = "Total",
       caption = "Datos tomados del INE"
  ) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8))

#agua reutilizada separado por comunidades

ggplot(agua_reutilizada) +
  geom_col(aes(x = periodo, y = total, fill = comunidades_ciudades_autonomas)) +
  facet_wrap( . ~ comunidades_ciudades_autonomas ) +
  labs(title = "",
       subtitle = ""
  ) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 10),
        #arriba(top), izquierda (left), derecha (right)
        legend.position = "down",
  )


#agua reutilizada por persona

# Construimos nueva columna con el total de agua por persona
# Multiplicamos por 10^3 para pasar de la unidad original m3 a dm3 -> l
agua_reutilizada <- df %>% 
  filter(tipo_indicador == "Volumen total de agua reutilizada", periodo == "2022")
agua_reutilizada$agua_x_persona <- agua_reutilizada$total_agua / agua_reutilizada$total_poblacion

ggplot(agua_reutilizada, aes(x = comunidades_ciudades_autonomas, y = agua_x_persona, fill=periodo)) +
  geom_col() +
  labs(title = "Agua reutilizada por comunidades \ny ciudades autonomas, tipo de captación y periodo.",
       subtitle = "",
       x = "Comunidades y ciudades autónomas",
       y = "Total",
       caption = "Datos tomados del INE"
  ) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8))


