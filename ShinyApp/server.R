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
    
    output$years <- renderInfoBox({
        infoBox(
            "Years Spanned",
            "1999-2013", 
            icon = icon("list"),
            color = 'green'
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
    
    filteredIndustry <- reactive({ dfSuccessByYearIndustry %>% filter(., `Focus functions of company` == input$industries)})
    output$line <- renderGvis(
        gvisLineChart(filteredIndustry(), "year of founding", c("success"))
    )
    
    filteredProdData <- reactive({ Startup_Data %>% filter(., `Dependent-Company Status` == input$successFail)})
    output$productVsService <- renderGvis(
        gvisPieChart(dplyr::count(filteredProdData(), `Product or service company?`, sort = TRUE), options = list(height = "300px", is3D = TRUE,
                                                                                                            legend = {position = "bottom"}))
    )
    
    output$cloudVsPlatform <- renderGvis(
        gvisPieChart(dplyr::count(filteredProdData(), `Cloud or platform based serive/product?`, sort = TRUE), options = list(height = "300px", is3D = TRUE,
                                                                                                                        legend = {position = "bottom"}))
    )

    output$machineLearning <- renderGvis(
        gvisPieChart(dplyr::count(filteredProdData(), `Machine Learning based business`, sort = TRUE), options = list(height = "300px", is3D = TRUE,
                                                                                                                legend = {position = "bottom"}))
    )
    
    output$internetScore <- renderPlot(
        ggplot(Startup_Data, aes(x=`Company_Name`, y=internet_score, label="Internet Score")) + 
            geom_bar(stat='identity', aes(fill=score_type), width=.5)  +
            scale_fill_manual(name="Internet Score", 
                              labels = c("Above Average", "Below Average"), 
                              values = c("above"="#00ba38", "below"="#f8766d")) + 
            labs(subtitle="Normalised Internet Activity Score", 
                 title= "Internet Actitivty") + coord_flip()
    )
    
    output$ageOfCompany <- renderPlot(
        if(input$radio == "success") {
            ggplot(data=dfAgeCompany, aes(x=`ageCategory`, y=success, fill=`ageCategory`)) + geom_bar(stat="identity") + geom_bar(stat="identity")+theme_minimal()

        }
        else {
            ggplot(data=dfAgeCompany, aes(x=`ageCategory`, y=failed, fill=`ageCategory`)) + geom_bar(stat="identity") + geom_bar(stat="identity")+theme_minimal()
        }
    )
})
