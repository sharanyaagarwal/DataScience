
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
            menuItem("Team", tabName = "Team", icon = icon("map"), menuSubItem("Founder Analysis", tabName="founderDetails"), menuSubItem("Team Analysis", tabName="teamDetails")), 
            menuItem("Finances", tabName = "Finances", icon = icon("map")), 
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
                    box("Using the Startup_Data dataset, we further look into the different industries in which startups have been launched over the years.
                        We can then look at each industry and try to see if there is a clear trend between the success rate 
                        over the years.", width = 12),
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
                           selectizeInput("industries", "Choose an industry:",
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
                           title = "Success Rate by Industry Over Years", width = NULL, status = "warning",
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
                headerPanel(h1("Product or Service Analysis", align='center')),
                fluidRow(
                    box("We want to further understand if those companies whose products and services align with
                        the technological trends are more successful or not. We will look to see if these startups
                        use cloud technology, machine learning and if their business is internet dependent.", width = 12)
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
                headerPanel(h1("Gartner Hype Cycle", align='center')),
                fluidRow(
                    column(width = 12,
                           box( width = NULL, status = "success",
                                title = "Average Years of Experience",
                                plotOutput("gartner")
                           )
                    ),
                ),
                fluidRow(
                    box("Gartner has developed a very sound technique for companies to assess if they are keeping up with
                     the technological trends. The hype cycle is a graphical presentation of the maturity, adoption, 
                    and social application of specific technologies. Here, we analyze if the phase of the hype cycle 
                    that a startup is in affects its success.", width = 6),
                    box( width = 6,
                         img(src='GartnerHypeCycle.png', align = "center", width = "489px")
                    )
                ),
            ),
            tabItem(tabName = "founderDetails",
                headerPanel(h1("Identifying how a Founder's Background Affects Startup Success", align='center')),
                fluidRow(
                    box("Here we want to further look at how a founder's background correlates with the success of
                        the business. Does it matter how many years of experience they have? Does their educational
                        background have an impact?", width = 12)
                ),
                fluidRow(
                    column(width = 4,
                       box( width = NULL, status = "success",
                            title = "Average Years of Experience",
                            plotOutput("yearsOfExpFounders")
                       )
                    ),
                    column(width = 4,
                       box( width = NULL, status = "success",
                            title = "Highest Education",
                            plotOutput("higherEd")
                       )
                    ),
                    column(width = 4,
                       box( width = NULL, status = "success",
                            title = "Been part of successful startups?",
                            plotOutput("pastStartups")
                       )
                    )
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
                           title = "Age of Company Correlation", width = NULL, status = "primary",
                           plotOutput("ageOfCompany")
                       )
                    )
                )
            ),
            tabItem(tabName = "teamDetails",
                headerPanel(h1("Team Composition", align='center')),
                fluidRow(
                    box("How does the team structure affect the chance of success? Are larger teams more effective?
                        The team composition score represents the diversity of the team. How many different skillsets
                        does your team consist of? The team is what executes the vision and it is crucial to understand
                        the impact of a talented group of people.", width = 12)
                ),
                fluidRow(
                    column(width = 2,
                           box( width = NULL, height = "463px", status = "success",
                                title = "Success / Failed",
                                "Select the success or failed Radio Button to see how the number of employees affects the success rate.",
                                radioButtons("radio2", label = "",
                                             choices = list("Success" = "success", "Failed" = "failed")),
                           )
                    ),
                    column(width = 10,
                           box(
                               title = "Number of Employees Total", width = NULL, status = "primary",
                               plotOutput("employeeYearly")
                           )
                    )
                ),
                fluidRow(
                    column(width = 12,
                           box(
                               title = "Team Composition Score", width = NULL, status = "primary",
                               plotOutput("teamScore")
                           )
                    )
                )
            ),
            tabItem(tabName = "Finances", 
                    headerPanel(h1("Finance and Investments", align='center')),
                    fluidRow(
                        box("It is difficult for new business to obtain the funds to execute their ideas. Finances is a 
                            large part of setting up a company. Here we will understand if investments affect the success rate.", width = 12)
                    ),
                    fluidRow(
                        column(width = 12,
                               box(
                                   title = "Funding Amount", width = NULL, status = "primary",
                                   plotOutput("fundingAmount")
                               )
                        )
                    ),
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
