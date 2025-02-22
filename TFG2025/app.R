library(shiny)
library(ggplot2)
library(dplyr)
library(readr)

# Funciones auxiliares
source("funciones_comunes.R")

# Cargar y limpiar datos
data_list <- carga_csvs()

# Asignar nombres a los dataframes
df_captacion <- data_list[[1]]
df_distribucion <- data_list[[2]]
df_volumen <- data_list[[3]]
df_distribucion_categorizada <- data_list[[4]]
df_volumen_categorizada <- data_list[[5]]
df_residuales <- data_list[[6]]

# Definir la interfaz de usuario
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
    
    if (plotType == "Barras") {
      ggplot(dataset) +
        geom_col(aes(x = periodo, y = Total, fill = `Comunidades y Ciudades Autonomas`), position = "dodge") +
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
  })
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)