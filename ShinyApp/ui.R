
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
            menuItem("Statistics", tabName = "Statistics", icon = icon("map")), 
            menuItem("Data", tabName = "Data", icon = icon("database"))
        )
    ), 
    dashboardBody(
        tabItems(
            tabItem(tabName = "Intro",
                    fluidRow(valueBoxOutput("numCompanies"), valueBoxOutput("successRate"))),
            tabItem(tabName = "Factors", "find out what factors affect the success rate"),
            tabItem(tabName = "Statistics", "detail about what correlation is"),
            tabItem(tabName = "Data", fluidRow(box(DT::dataTableOutput("table"), width = 12)))
        )
    )
))
