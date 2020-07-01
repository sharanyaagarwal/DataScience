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
    
    output$tableStartup <- DT::renderDataTable({
        DT::datatable(Startup_Data, options = list(paging = TRUE, scrollX = TRUE)) %>% DT::formatStyle(names(Startup_Data))
    })
    
    output$tableFailed <- DT::renderDataTable({
        DT::datatable(Failed_Companies, options = list(paging = TRUE, scrollX = TRUE)) %>% DT::formatStyle(names(Failed_Companies))
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
    
    terms <- reactive({
        
        input$update
        
        text <- ""
        for (row in 1:nrow(Failed_Companies)) {
            rowtext <- (Failed_Companies$Reason_for_Failure[row])
            text = paste(text, rowtext, sep = " ")
        }
        
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                getTermMatrix(text)
            })
        })
    })
    
    wordcloud_rep <- repeatable(wordcloud)
    
    output$wordPlot <- renderPlot({
        v <- terms()
        wordcloud_rep(names(v), v, scale=c(3,0.5),
                      min.freq = input$freq, max.words=input$max,
                      colors=brewer.pal(8, "Dark2"))
    })
    
    output$pieFailureReasons <- renderGvis(
        gvisPieChart(dfReasonsFailure, options = list(width = "565px",
                                                      height = "600px", is3D = TRUE,
                                                      legend = {position = "bottom"}))
    )
    
    output$industryDistribution <- renderPlot(
        ggplot(dfYearDistinct, aes(x = `year of founding`, y = `n`))+
            geom_col(aes(fill = `Focus functions of company`), width = 0.7)    
    )
})
