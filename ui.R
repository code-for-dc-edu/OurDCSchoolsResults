
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
                                    "Set-Asides for Low-Perf Areas"="setasides_value")),
                     h3("What's going on here?"),
                     p("Seven questions were asked of people where the answers ranged
                       from a frowny face to neutral to a smily face. These graphs show
                       that responses to these questions varied by city ward. For example,
                       in response to how boundaries will change, respondents in Ward 1
                       were generally quite happy, while respondents in Ward 5 were
                       mixed to negative.")
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
                                  c("All", "1", "2", "3", "4", "5", "6", "7", "8")),
                     h3("What's going on here?"),
                     p("Different people responded to the proposals in different ways. On this graph,
                       each line shows how one respondent responded to the 7 questions. The red
                       dots indicate what the most typical response was for each question. Overall,
                       the most common pattern was to strongly like the Boundary and Feeder Pattern
                       change proposals, dislike the choice proposals, and be neutral on the set-asides.
                       This varied by Ward, however. For instance, Ward 2 respondents were less
                       negative about the middle-school choice proposals.")
                ),
                mainPanel(
                    plotOutput("wardsPlot", height="600px")
                )
            )),
    tabPanel("Patterns",
             sidebarLayout(
                 sidebarPanel(
                     radioButtons("clusters", "Clusters:",
                                  c("2", "3", "4", "5", "6", "7", "8", "9"), 
                                  selected="4"),
                     h3("What's going on here?"),
                     p("Another way to look at how individual people responded is to
                       cluster them into similar patterns. You might think of each cluster as
                       \"people who responded similarly\". This graph shows what a
                       typical pattern was when you break down the responses into a particular
                       number of clusters. For instance, with four clusters, you can see a
                       group of people who disliked everything, a group who disliked
                       Elementary Choice and were neutral or negative on everything else, a
                       group who disliked the choice options but really liked the boundary and
                       feeder pattern proposals, and a group that was weakly positive on everything.")
                ),
                 mainPanel(
                     plotOutput("patternsPlot", height="600px")
                )
            ))
    
))
