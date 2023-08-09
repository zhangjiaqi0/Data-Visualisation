#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Load packages

library(shiny)
library(tidyverse)
cpi <- read.csv("cpi.csv",check.names=F)
melcpi <- melt(cpi,id.vars=c("region"),
               measure.vars = c(2:20),variable.name = "year",value.name = "cpi")
rpi <- read.csv("rpi.csv",check.names=F)
melrpi <- melt(rpi,id.vars=c("region"),
               measure.vars = c(2:20),variable.name = "year",value.name = "rpi")
data <- cbind(melcpi,melrpi)
data <- select(data,-c(4:5))
data <- melt(data,id.vars=c("region","year"),measure.vars = c("cpi","rpi"),variable.name = "index",value.name = "value")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # First of all we want to filter our data in reaction to changes in 
  # inputs.
  get_filtered_df <- reactive(
    data %>% 
      # We filter continents based on the selection input in the UI
      filter(region==input$region,Year==input$year)
             # We also filter Years to lie between the min and max 
             # extremes of the interval selected by the slider.
             #Year > year_ranges[1],
             #Year < year_ranges[2])
  )
  
  # Now we want to create a scatter plot based on this input
  
  # Remember that to create an output we must assign to the relevant 
  # element of the output list.
  # Remember that the type of the render function (plot)
  # must match the type of the output with this id, created in the 
  # UI code
  output$line_plot <- renderPlot({
    
    # We use normal code for a ggplot2 plot
    # except we use the reactive function created above
    # to get hold of the dataframe filtered by the current values of 
    # the inputs
    ggplot(get_filtered_df(), mapping = aes(x = Year, y = value, colour = index))+ geom_line()
  })
  
  # We similarly use a renderDataTable to assign to the data_table
  # slot we created in the UI code.
  output$data_table <- renderDataTable(
    # Here we use the brush to filter our dataframe further 
    # based on the points highlighted by the brush
    brushedPoints(get_filtered_df(), 
                  input$plot_brush))
  
})
