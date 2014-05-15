
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
library(cluster)
library(shiny)
library(reshape2)

dat <- read.csv('ourschoolsdc-2014-05-11.csv')
dat <- subset(dat, !is.na(setasides_value))

datc <- subset(dat, select=c(boundaries_value, feederpatterns_value, eschoicesets_value,
                             mschoicesets_value, msproximity_value, hslottery_value,
                             setasides_value))
datc <- datc[complete.cases(datc), ]
datc_pam <- pam(datc, k=3)

patterns <- datc_pam$medoids
colnames(patterns) <- c("Boundary Change",
  "Feeder Pattern Change",
  "Elementary Choice Set",
  "Middle Choice Set",
  "Two Closest Middle",
  "Citywide High School Lottery",
  "Set-Asides for Low-Perf Areas")
patterns <- as.data.frame(patterns)
patterns$id <- 1:nrow(patterns)

patterns <- melt(as.data.frame(patterns), id.vars='id', variable.name='Question', value.name='Response')
patterns$id <- factor(patterns$id)

shinyServer(function(input, output) {
   
  output$wardHistPlot <- renderPlot({
     
    # generate and plot an rnorm distribution with the requested
    # number of observations
    pl <- ggplot(dat, aes_string(x=input$question)) +
        geom_histogram(binwidth=1) + facet_wrap(~ward, scales='free') + xlim(1,6)
    print(pl)
  })
  
  output$patternPlot <- renderPlot({
      pl <- ggplot(patterns, aes(Question, Response, group=id, color=id)) +
          geom_line() + 
          geom_point() +
          coord_flip()
      
  })
})
