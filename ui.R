#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(reshape2)

getwd()
setwd("C:/Users/jqizh/Desktop/Lectures soton/6 STAT6119 Data Visualisation/Coursework")
# load data
rm(list = ls())
cpi <- read.csv("cpi.csv",check.names=F)
melcpi <- melt(cpi,id.vars=c("region"),
                 measure.vars = c(2:20),variable.name = "year",value.name = "cpi")
rpi <- read.csv("rpi.csv",check.names=F)
melrpi <- melt(rpi,id.vars=c("region"),
                measure.vars = c(2:20),variable.name = "year",value.name = "rpi")
data <- cbind(melcpi,melrpi)
data <- select(data,-c(4:5))
data <- melt(data,id.vars=c("region","year"),measure.vars = c("cpi","rpi"),variable.name = "index",value.name = "value")

# We want the set of all unique continents to choose from:
regs <- unique(data$region)
# And we want the earliest and latest years for which a user can choose:
#year_ranges <- range(data$year)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Consumer Price Index & Retail Price Index "),
  
  # Sidebar holding inputs 
  sidebarPanel(
    ## Selector for continents
    selectInput("region",  # HTML id (for server reference)
                "Region",  # Label displayed on UI page
                choices = regs), # Choices to select from
    
    ## Slider input for year range
    # Notice that by passing a vector of two numbers to the value
    # argument of the slides we are specifying we want this 
    # slider to allow users to select a *range* of values and not 
    # just a single value.
    
    #sliderInput("year",  # HTML id (for server reference)
               # "Year",  # Label displayed on UI page
              #  min=year_ranges[1], # min value of slider
               # max=year_ranges[2], # max value of slider
                #value=year_ranges, # starting values (see above)
                #
                #  by default, the axis would have labels like
                # "2,010.00" for the year 2010.
                # The arguments below change this behaviour
                #sep = "", # include thousand separators in number?
                #round=T) # Round number
  #),
  
  # Show a plot of the generated distribution
  mainPanel(
    # Specify output element to hold scatterplot
    plotOutput("line_plot", 
               # The brush argument allows us to select units
               # by highlighting areas on the plot
               # Information about this area is communicated
               # to the server
               # This information will be provided by the 
               # input$plot_brush element in this case.
               brush = brushOpts("plot_brush", 
                                 # Reset the brush when data
                                 # changes?
                                 resetOnNew = T)
    ),
    # specify output element to hold a data table
    dataTableOutput("data_table")
  )
)
)
