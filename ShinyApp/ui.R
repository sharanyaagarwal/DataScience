
library(shiny)
library(googleVis)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage( 
    dashboardHeader( title = "Shiny App"
    ), 
    dashboardSidebar(
        sidebarUserPanel(
            name = "Sharanya Agarwal", image = '0.jpg'
        ),
        sidebarMenu(
            menuItem("Introduction", tabName = "Intro", icon = icon("map")), 
            menuItem("Factors", tabName = "Factors", icon = icon("map")), 
            menuItem("Industry", tabName = "Industry", icon = icon("map")),
            menuItem("Product", tabName = "Product", icon = icon("map")), 
            menuItem("Team", tabName = "Team", icon = icon("map")), 
            menuItem("Operations", tabName = "Operations", icon = icon("map")), 
            menuItem("Data", tabName = "Data", icon = icon("database"))
        )
    ), 
    dashboardBody(
        tabItems(
            tabItem(tabName = "Intro",
                fluidRow(
                    valueBoxOutput("numCompanies"), 
                    valueBoxOutput("successRate")
                )
            ),
            tabItem(tabName = "Factors", 
                headerPanel(h1("Identifying the Factors That Affect Startup Success", align='center')),
                fluidRow(
                    box("The wordcloud uses dataset Failed_Companies to identify the major problems faced by startups.
                This is based on the reasons provided by the companies for their closure. Based on the main problems
                that were identified in the wordcloud, we performed a deeper analysis to identify the distribution of
                reasons across the different companies.", width = 12)
                ),
                fluidRow(
                    column(width = 5,
                       box(
                           title = "Input for Wordcloud", width = NULL, status = "warning",
                           sliderInput("freq",
                                       "Minimum Frequency:",
                                       min = 17,  max = 50, value = 15),
                           sliderInput("max",
                                       "Maximum Number of Words:",
                                       min = 10,  max = 300,  value = 100),
                       ),
                       box(
                           title = "Reasons for Failure", width = NULL, status = "warning",
                           plotOutput("wordPlot")
                       )
                    ),
                    column(width = 7,
                       box(
                           title = "Reasons for Failure - Categorized", width = NULL, height = "746px", status = "primary",
                           htmlOutput("pieFailureReasons")
                       )
                    )
                )
            ),
            tabItem(tabName = "Industry", 
                headerPanel(h1("Identifying what the correlation between success and industry is", align='center')),
                fluidRow(
                    box("The wordcloud uses dataset Failed_Companies to identify the major problems faced by startups.
                    This is based on the reasons provided by the companies for their closure. Based on the main problems
                    that were identified in the wordcloud, we performed a deeper analysis to identify the distribution of
                    reasons across the different companies.", width = 12),
                ),
                fluidRow(
                    box(
                        title = "Distribution by Industry Over The Years", width = 12, status = "warning",
                        plotOutput("industryDistribution")
                    )
                )
            ),
            tabItem(tabName = "Product", 
                    "detail about what correlation is"
            ),
            tabItem(tabName = "Team", 
                    "detail about what correlation is"
            ),
            tabItem(tabName = "Operations", 
                    "detail about what correlation is"
            ),
            tabItem(tabName = "Data", 
                tabBox(
                    title = "Datasets Used",
                    id = "tabset1", width = 12,
                    tabPanel("Startup Data", fluidRow(box(DT::dataTableOutput("tableStartup"), width = 12, style = "height:700px; overflow-y: scroll;overflow-x: scroll;"))),
                    tabPanel("Failure Data", fluidRow(box(DT::dataTableOutput("tableFailed"), width = 12, style = "height:700px; overflow-y: scroll;overflow-x: scroll;")))
                )
            )
        )
    )
))
