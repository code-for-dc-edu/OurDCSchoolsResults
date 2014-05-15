
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

options(stringsAsFactors=FALSE)


library(ggplot2)
library(plyr)
library(stringr)
library(lubridate)

dat <- read.csv('ourschoolsdc-2014-05-11.csv')
dat <- subset(dat, !is.na(setasides_value))

library(shiny)

shinyServer(function(input, output) {
   
  output$wardHistPlot <- renderPlot({
     
    # generate and plot an rnorm distribution with the requested
    # number of observations
    pl <- ggplot(dat, aes_string(x=input$question)) +
        geom_histogram(binwidth=1) + facet_wrap(~ward, scales='free') + xlim(1,6)
    print(pl)
  })
  
})
