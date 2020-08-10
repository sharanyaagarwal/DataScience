#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(googleway)

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        dashboardHeader( title = "LinkedIn During COVID"
        ), 
        dashboardSidebar(
            sidebarUserPanel(
                name = "Sharanya Agarwal",
                img(src="Linkedinlogo.jpg", width="60px" )
            ),
            sidebarMenu(
                menuItem("Introduction", tabName = "Intro", icon = icon("map")), 
                menuItem("Industries", tabName = "Industries", icon = icon("map")),
                menuItem("Date Posted", tabName = "DatePosted", icon = icon("map")),
                menuItem("Seniority Level", tabName = "SeniorityLevel", icon = icon("map")),
                menuItem("Key Skills", tabName = "KeySkills", icon = icon("map"))
            )
        ),
        dashboardBody(
            shinyDashboardThemes(
                theme = "grey_light"
            ),
            tabItems(
                
                tabItem(tabName = "Intro",
                    fluidRow(
                        valueBoxOutput("numRows", width = 6), 
                        valueBoxOutput("years", width = 6)
                    ),
                    fluidRow(
                        box("After analyzing the job postings' data, we can see that there are 
                            jobs being posted across the globe. A majority of them are located in the United States 
                            and Europe. There are many in metropolitan, big city areas.", width = 12)
                    ),
                    fluidRow(
                        box(width = 12,
                            google_mapOutput(outputId = "myMap", height = "900px")
                        )
                    )
                ),
                tabItem(tabName = "Industries",
                    fluidRow(
                        box("The jobs are primarily in the Information Technology industry, but there are 
                            jobs being posted in every industry, from Oil & Energy to Retail. There are also all kinds of 
                            roles being offered, whether it is for management positions or development roles. Lastly, the majority 
                            of employment types being offered are full time positions, which is contrary to my assumption.", width = 12)
                    ),
                    fluidRow(
                        column(width = 12,
                           box( width = NULL, status = "success",
                                title = "Industries",
                                plotOutput("industries")
                           )
                        )
                    ),
                    fluidRow(
                        column(width = 6, height = 600,
                           box( width = NULL, status = "success",
                                title = "Job Function",
                                htmlOutput("jobFunction")
                           )
                        ),
                        column(width = 6,
                           box( width = NULL, height = 600, status = "success",
                                title = "Employment Type",
                                plotOutput("employmentType", height = "500px")
                           )
                        )
                    )
                ),
                tabItem(tabName = "DatePosted",
                    fluidRow(
                        box("These jobs span the last 2 years and there are jobs being posted constantly over this 
                            time period. However, most of the jobs seemed to have been posted about a couple weeks ago. 
                            However, this data is being updated everyday and this data is based on the data scraped on August 3, 2020.", width = 12)
                    ),
                    fluidRow(
                        column(width = 12,
                           box( width = NULL, height = 600, status = "success",
                                title = "When was the Job Posted?",
                                plotOutput("postedTime", height = "500px")
                           )
                        )
                    )
                ),
                tabItem(tabName = "KeySkills",
                    fluidRow(
                        box("It is very insightful for those actively searching for a new job to identify some of 
                            the main skills that companies look for. By looking at the descriptions of these jobs descriptions 
                            we can see the terms that are most utilized by recruiters. Furthermore, we can identify some of 
                            the key skills that these hiring committees look for in their applicants.", width = 12)
                    ),
                    fluidRow(
                        column(width = 5,
                           box(height = '460px',
                               title = "Input for Wordcloud", width = NULL, status = "warning",
                               sliderInput("freq",
                                           "Minimum Frequency:",
                                           min = 17,  max = 50, value = 15),
                               sliderInput("max",
                                           "Maximum Number of Words:",
                                           min = 10,  max = 300,  value = 100),
                           )
                        ),
                        column(width = 7,
                           box(
                               title = "Key Skills According to Description", width = NULL, status = "warning",
                               plotOutput("wordPlot")
                           )
                        )
                    )
                ),
                tabItem(tabName = "SeniorityLevel",
                    fluidRow(
                        box("The data was limited to the executive roles. However, even within this domain, we can see 
                            that there are executive and director roles at a lot of companies. You can see this distribution 
                            to see the roles being offered. The difference in executive and director positions is not the same 
                            across companies.", width = 12)
                    ),
                    fluidRow(
                        column(width = 12, height = 600,
                           box( width = NULL, status = "success",
                                title = "Job Function",
                                htmlOutput("seniorityLevel")
                           )
                        )
                    )
                )
            )
        )
    )
)
