#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(googleVis)

# Define server logic required to draw a histogram
shinyServer(function(input, output){
    
    output$table <- DT::renderDataTable({
        DT::datatable(Startup_Data, options = list(paging = FALSE, scrollX = TRUE)) %>% DT::formatStyle(names(Startup_Data))
    })
    
    success <- nrow(filter(Startup_Data, Startup_Data$`Dependent-Company Status` == "Success"))
    failed <- nrow(filter(Startup_Data, Startup_Data$`Dependent-Company Status` == "Failed"))
    
    output$successRate <- renderInfoBox({
        infoBox(
            "Startup Success Rate",
            paste0((success * 100) / (failed+success), "%"), 
            icon = icon("thumbs-up"),
            color = 'orange'
        )
    })
    
    output$numCompanies <- renderInfoBox({
        infoBox(
            "Number of Companies",
            nrow(Startup_Data), 
            icon = icon("list"),
            color = 'purple'
        )
    })
})
