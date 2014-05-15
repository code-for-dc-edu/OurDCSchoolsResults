
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(navbarPage("Our DC Schools",
    tabPanel("Questions",
             sidebarLayout(
                 # Sidebar with a radio button for question
                 sidebarPanel(
                     radioButtons("question", "Survey Question:",
                                  c("Boundary Change"="boundaries_value",
                                    "Feeder Pattern Change"="feederpatterns_value",
                                    "Elementary Choice Set"="eschoicesets_value",
                                    "Middle Choice Set"="mschoicesets_value",
                                    "Two Closest Middle"="msproximity_value",
                                    "Citywide High School Lottery"="hslottery_value",
                                    "Set-Asides for Low-Perf Areas"="setasides_value"))
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                     plotOutput("wardHistPlot", height="600px")
                 )
            )),
    tabPanel("Wards",
             sidebarLayout(
                 sidebarPanel(
                     radioButtons("ward", "Ward:",
                                  c("All", "1", "2", "3", "4", "5", "6", "7", "8"))
                ),
                mainPanel(
                    plotOutput("patternPlot", height="600px")
                )
            ))
    
))
