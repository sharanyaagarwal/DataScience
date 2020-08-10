#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(googleway)
library(googleVis)
library(ggmap)
library(treemap)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$numRows <- renderInfoBox({
        infoBox(
            "Number of Job Postings",
            nrow(LinkedInJobs), 
            icon = icon("list"),
            color = 'purple'
        )
    })
    
    output$myMap <- renderGoogle_map({
        set_key("AIzaSyBEDQm4H6O60YCRPf0hYZX0BuCg3Rz4JFM")
        google_map(location = c(-37.817386, 144.967463),
           zoom = 10,
           split_view = "pano") %>% 
            add_markers(lat = LinkedInJobs$lat, lon = LinkedInJobs$lon, info_window = "stop_name")
    })
    
    output$years <- renderInfoBox({
        infoBox(
            "Time Span",
            "2 years (2018 - 2020", 
            icon = icon("list"),
            color = 'green'
        )
    })
    
    terms <- reactive({
        input$update
        
        text <- ""
        for (row in 1:nrow(LinkedInJobs)) {
            rowtext <- (LinkedInJobs$Description[row])
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
        wordcloud_rep(names(v), v, scale=c(3,0.6),
                      min.freq = input$freq, max.words=input$max,
                      colors=brewer.pal(8, "Dark2"))
    })
    
    output$jobFunction <- renderGvis(
        gvisPieChart(jobFunction, options = list(height = "500px", is3D = TRUE,
                                                 legend = {position = "bottom"}))
    )
    
    output$seniorityLevel <- renderGvis(
        gvisPieChart(seniorityLevel, options = list(height = "500px", is3D = TRUE,
                                                 legend = {position = "bottom"}))
    )
    
    output$postedTime <- renderPlot(
        dateposted %>% 
            dplyr::mutate(`Posted Time Ago` = factor(`Posted Time Ago`, 
              levels = c("7 hours ago", "8 hours ago", "12 hours ago", "13 hours ago",
                         "14 hours ago", "15 hours ago", "17 hours ago", "18 hours ago", "19 hours ago", 
                         "20 hours ago", "21 hours ago", "1 day ago", "2 days ago", "3 days ago", 
                         "4 days ago", "5 days ago", "6 days ago", "7 days ago", "1 week ago", 
                         "2 weeks ago", "3 weeks ago", "4LMFAO  weeks ago", "1 month ago", "2 months ago", 
                         "3 months ago", "4 months ago", "5 months ago", "6 months ago", "7 months ago",
                         "8 months ago", "9 months ago", "10 months ago", "11 months ago", "12 months ago",
                         "2 years ago"))) %>% ggplot(aes(x=`Posted Time Ago`, y=n, fill=`Posted Time Ago`), height = "900px") + geom_bar(stat="identity") + geom_bar(stat="identity")+theme_minimal() + coord_flip()
    )
    
    output$employmentType <- renderPlot(
        ggplot(employmentType, aes(x = "", y=n, fill = factor(employmentType$`Employment Type`))) +
             geom_bar(width = 1, stat = "identity") +
             theme(axis.line = element_blank(), plot.title = element_text(hjust=0.5)) +
                labs(fill="class",
                             x=NULL,
                             y=NULL, 
                             title="Employment Type",
                             caption="Source: mpg")       
    )
    
    output$industries <- renderPlot(
        treemap(industries,
            index=c("Industries Sorted"),
            vSize="n",
            type="index",
            palette = "Set2",
            bg.labels=c("white"),
            align.labels=list(
                c("center", "center"), 
                c("right", "bottom")
            )  
        )            
    )
})
