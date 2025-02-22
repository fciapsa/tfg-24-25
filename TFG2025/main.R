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
#Cargar datos
data_list <- carga_csvs()

# Verificamos que los dfs se han cargado correctamente
print("Verificando dataframes cargados:")
print(head(data_list[[1]]))  # df_captacion
print(head(data_list[[2]]))  # df_distribucion
print(head(data_list[[3]]))  # df_volumen
print(head(data_list[[4]]))  # df_distribucion_categorizada
print(head(data_list[[5]]))  # df_volumen_categorizada
print(head(data_list[[6]]))  # df_residuales

#Renombramos los dfs
df_captacion <- data_list[[1]]
df_distribucion <- data_list[[2]]
df_volumen <- data_list[[3]]
df_distribucion_categorizada <- data_list[[4]]
df_volumen_categorizada <- data_list[[5]]
df_residuales <- data_list[[6]]
#FIN#____________LECTURA DE LOS CSVS____________#FIN#

#INI#____________CONFIGURADACION DE LOS DF OBTENIDOS____________#INI#

########################################################################################################
#COSAS A REALIZAR df_captacion:
#La columna "Comunidades y Ciudades Autónomas" está vacía para cuando la columna "Total Nacional tiene el valor "Ceuta y Melilla"
#Asociar a la columna "Comunidades y Ciudades Autónomas" el valor de "18 Ceuta y Melilla" - HECHO
#names(df_captacion)[2]  <- 'Comunidades y Ciudades Autonomas'
#names(df_captacion)[3]  <- 'Tipo de captacion'

#Asociamos el valor "Ceuta y Melilla" a la columna 2 del df "df_captacion",
#que se encuentra vacia para estos casos en el csv inicial
num_filas <- 1

while (num_filas <= nrow(df_captacion)) {
  if (df_captacion[num_filas,1] == "Ceuta y Melilla") {
    df_captacion[num_filas,2] <- "18 Ceuta y Melilla"
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
#names(df_distribucion)[1]  <- 'Usuarios'

#Mostrar valores únicos del df
unique((df_distribucion$Total))

#Borrar valores NA del df
df_distribucion <- na.omit(df_distribucion)

#Factorizamos las columnas
df_distribucion$`Grupos de usuarios` <- factor(df_distribucion$`Grupos de usuarios`)
df_distribucion$periodo <- factor(df_distribucion$periodo)
########################################################################################################
#FIN#____________CONFIGURADACION DE LOS DF OBTENIDOS____________#FIN#

#INI#____________CREACION DE DIAGRAMAS_______________#INI#

#Diagrama de barras de df "df_distribucion" categorizado por tipos de usuarios
ggplot(df_distribucion) +
  geom_col(aes(x = periodo, y = Total, fill = `Grupos de usuarios`), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "right"  
  ) 


df_distribucion_sin_totales <- filter(df_distribucion, `Grupos de usuarios` != 'Total')
table(df_distribucion$`Grupos de usuarios`, df_distribucion$Total)

# Verificar valores NA
print("Valores perdidos en df_distribucion:")
print(sum(is.na(df_distribucion)))

# Verificar valores únicos en columnas clave
print("Valores únicos en la columna 'Grupos de usuarios':")
print(unique(df_distribucion$`Grupos de usuarios`))

print("Valores únicos en la columna 'periodo':")
print(unique(df_distribucion$periodo))

print("Valores únicos en la columna 'Total':")
print(unique(df_distribucion$Total))

# Verificar estadísticas descriptivas para identificar posibles valores atípicos
print("Estadísticas descriptivas del dataframe:")
print(summary(df_distribucion))

#Diagrama de barras de df "df_distribucion" categorizado por tipos de usuarios
ggplot(df_distribucion) +
  geom_col(aes(x = periodo, y = Total, fill = `Grupos de usuarios`), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de barras de df "df_distribucion" categorizado por periodo (año)
ggplot(df_distribucion) +
  geom_col(aes(x = `Grupos de usuarios`, y = Total, fill = periodo ), position = "dodge") +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        # arriba(top), izquierda (left), derecha (right), abajo (bottom)
        legend.position = "bottom"  
  ) 

#Diagrama de dispersión de df "df_distribucion" categorizado por tipos de usuarios
ggplot(df_distribucion) +
  geom_point(aes(x = periodo, y = Total, color = `Grupos de usuarios`)) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8)) 

#Diagrama de dispersión de df "df_distribucion" categorizado por tipos de usuarios de manera individual en vertical
ggplot(df_distribucion) +
  geom_point(aes(x = periodo, y = Total, color = `Grupos de usuarios`)) +
  facet_grid( `Grupos de usuarios` ~ .) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  ) 

#Diagrama de dispersión de df "df_distribucion" categorizado por tipos de usuarios de manera individual en diferentes diagramas
ggplot(df_distribucion) +
  geom_point(aes(x = periodo, y = Total, color = `Grupos de usuarios`)) +
  facet_wrap( `Grupos de usuarios` ~ ., nrow = 2) +
  labs(subtitle = "Distribución de agua registrada, usuario y periodo.csv") +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
        legend.position = "bottom"  )
#FIN#____________CREACION DE DIAGRAMAS_______________#FIN#

#INI#____________VISUALIZACIÓN DE LOS DFs____________#INI#  
view(df_captacion)
view(df_distribucion)
view(df_volumen)
view(df_distribucion_categorizada)
view(df_volumen_categorizada)
view(df_residuales)
#FIN#____________VISUALIZACIÓN DE LOS DFs____________#FIN#

#INI#____________CREACION DEL DASHBOARD______________#INI#  
# Definir la interfaz de usuario
#La función fluidPage se utiliza para crear una página fluida que se ajusta al tamaño de la ventana del navegador
#titlePanel se utiliza para añadir un título al dashboard
#sidebarLayout organiza la disposición en una barra lateral y un panel principal
#selectInput crea menús desplegables para seleccionar el dataset y el tipo de gráfico
#plotOutput crea un espacio para mostrar el gráfico generado
ui <- fluidPage(
  titlePanel("Dashboard del Ciclo del Agua"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Seleccione el Dataset:",
                  choices = c("Captación", "Distribución", "Volumen", "Distribución Categorizada", "Volumen Categorizada", "Residuales")),
      selectInput("plotType", "Seleccione el Tipo de Gráfico:",
                  choices = c("Barras", "Dispersión"))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Definir el servidor
#la función server contiene la lógica para generar los gráficos en función de las entradas del usuario
#renderPlot se utiliza para renderizar el gráfico basado en las entradas seleccionadas por el usuario
#switch selecciona el dataset adecuado
#ggplot se utiliza para generar el gráfico correspondiente
server <- function(input, output) {
  output$plot <- renderPlot({
    dataset <- switch(input$dataset,
                      "Captación" = df_captacion,
                      "Distribución" = df_distribucion,
                      "Volumen" = df_volumen,
                      "Distribución Categorizada" = df_distribucion_categorizada,
                      "Volumen Categorizada" = df_volumen_categorizada,
                      "Residuales" = df_residuales)
    
    plotType <- input$plotType
    
    # Convertir los datos a data frame si es un named vector
    #Para solventar el problema de la función asJSON al tratar de  convertir un vector con nombres (named vector) en un objeto JSON
    if (!is.data.frame(dataset)) {
      dataset <- as.data.frame(as.list(dataset))
    }
    
    #Para el csv de distribución, la categorización es diferente que en el resto
    #se filtra en función de eso para visionarlo correctamente
    if (plotType == "Barras") {
      if (input$dataset == "Distribución") {
        ggplot(dataset) +
          geom_col(aes(x = periodo, y = Total, fill = `Grupos de usuarios`), position = "dodge") +
          labs(subtitle = paste(input$dataset, ".csv")) +
          theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
                legend.position = "bottom")
      } else {
        ggplot(dataset) +
          geom_col(aes(x = periodo, y = Total, fill = `Comunidades y Ciudades Autonomas`), position = "dodge") +
          labs(subtitle = paste(input$dataset, ".csv")) +
          theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
                legend.position = "bottom")
      }
    } else {
      
      if (input$dataset == "Distribución") {
        ggplot(dataset) +
          geom_point(aes(x = periodo, y = Total, color = `Grupos de usuarios`)) +
          labs(subtitle = paste(input$dataset, ".csv")) +
          theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
                legend.position = "bottom")
      } else {
        ggplot(dataset) +
          geom_point(aes(x = periodo, y = Total, color = `Comunidades y Ciudades Autonomas`)) +
          labs(subtitle = paste(input$dataset, ".csv")) +
          theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1, size = 8),
                legend.position = "bottom")
      }
    }
  })
}

# Ejecutar la aplicación
#shinyApp es la función que ejecuta la aplicación pasandole como argumentos la UI y el servidor
shinyApp(ui = ui, server = server)
#FIN#____________VISUALIZACIÓN DE LOS DFs____________#FIN#

#######################################################################################################
#######################################################################################################