
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
            menuItem("Product", tabName = "Product", icon = icon("map"), menuSubItem("Product Analysis", tabName="prodAnalysis"), menuSubItem("Gartner Cycle", tabName="Gartner")), 
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
                    valueBoxOutput("successRate"),
                    valueBoxOutput("years")
                ),
                fluidRow(
                    box( width = 12,
                        img(src='AnalysisDiagram.png', align = "center", width = "1000px")
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
                ),
                fluidRow(
                    column(width = 4,
                       box( width = NULL, status = "success",
                           selectizeInput("industries", "Choose a dataset:",
                                choices = c("Analytics", "Risk Management",
                                    "Marketing & Sales", "Operations",
                                    "Strategy", "Database Management",
                                    "Cloud Computing", "Community",
                                    "Customer Engagement", "Data Integration",
                                    "Data Management", "Database Management",
                                    "Energy", "Finance", "Media", "Network",
                                    "Other", "Research", "Security", "Service",
                                    "Social Media", "Technology", "Telecommunication",
                                    "Web", "Writing")), height = "263px"
                       )
                    ),
                    column(width = 8,
                       box(
                           title = "Distribution by Industry Over The Years", width = NULL, status = "warning",
                           htmlOutput("line")
                       )
                    )
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
            tabItem(tabName = "prodAnalysis",
                headerPanel(h1("Identifying the Factors That Affect Startup Success", align='center')),
                fluidRow(
                    box("The wordcloud uses dataset Failed_Companies to identify the major problems faced by startups.
                    This is based on the reasons provided by the companies for their closure. Based on the main problems
                    that were identified in the wordcloud, we performed a deeper analysis to identify the distribution of
                    reasons across the different companies.", width = 12)
                ),
                fluidRow(
                    box(width = 12,
                        radioButtons("successFail", "Select Success or Failed Company Data", choices = list("Success" = "Success", "Failed" = "Failed"))
                    )
                ),
                fluidRow(
                    column(width = 4,
                           box(
                               title = "Product or service company?", width = NULL, status = "warning",
                               htmlOutput("productVsService")
                           ),
                    ),
                    column(width = 4,
                           box(
                               title = "Cloud or platform based?", width = NULL, status = "warning",
                               htmlOutput("cloudVsPlatform")
                           ),
                    ),
                    column(width = 4,
                           box(
                               title = "Machine Learning based business?", width = NULL, status = "warning",
                               htmlOutput("machineLearning")
                           ),
                    )
                ),
                fluidRow(
                    box(
                        title = "Company Internet Scores", width = 12, height = 2100, status = "warning",
                        plotOutput("internetScore", height = "2000px")
                    ),
                )
            ),
            tabItem(tabName = "Gartner",
            ),
            tabItem(tabName = "Team", 
                headerPanel(h1("Identifying the Factors That Affect Startup Success", align='center')),
                fluidRow(
                    box("The wordcloud uses dataset Failed_Companies to identify the major problems faced by startups.
                    This is based on the reasons provided by the companies for their closure. Based on the main problems
                    that were identified in the wordcloud, we performed a deeper analysis to identify the distribution of
                    reasons across the different companies.", width = 12)
                ),
                fluidRow(
                    column(width = 2,
                        box( width = NULL, height = "463px", status = "success",
                             title = "Success / Failed",
                            "Select the success or failed Radio Button to see how the age of the company affects the success rate.",
                            radioButtons("radio", label = "",
                                 choices = list("Success" = "success", "Failed" = "failed")),
                        )
                    ),
                    column(width = 10,
                       box(
                           title = "Reasons for Failure - Categorized", width = NULL, status = "primary",
                           plotOutput("ageOfCompany")
                       )
                    )
                )
            ),
            tabItem(tabName = "Operations", 
                    "detail about what correlation is"
            ),
            tabItem(tabName = "Data", 
                tabBox(
                    title = "Datasets Used",
                    id = "tabset1", width = 12,
                    tabPanel("Startup Data", fluidRow(box(DT::dataTableOutput("tableStartup"), width = 12, style = "height:600px; overflow-y: scroll;overflow-x: scroll;"))),
                    tabPanel("Failure Data", fluidRow(box(DT::dataTableOutput("tableFailed"), width = 12, style = "height:600px; overflow-y: scroll;overflow-x: scroll;")))
                )
            )
        )
    )
))
