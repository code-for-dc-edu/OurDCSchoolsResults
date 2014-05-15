
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
                             setasides_value, ward))
datc <- datc[complete.cases(datc), ]
colnames(datc) <- c("Boundary Change",
                        "Feeder Pattern Change",
                        "Elementary Choice Set",
                        "Middle Choice Set",
                        "Two Closest Middle",
                        "Citywide High School Lottery",
                        "Set-Asides for Low-Perf Areas", "Ward")

datc_long <- melt(cbind(datc, resp=rownames(datc)), variable.name='Question', value.name='Response')
datc_long <- subset(datc_long, Response>0)
datc_long <- mutate(datc_long,
                    Ward=as.numeric(str_extract(Ward, "\\d")))

datc_pam <- pam(datc, k=3)

patterns <- datc_pam$medoids

patterns <- as.data.frame(patterns)
patterns$id <- rownames(patterns)

patterns <- melt(patterns, id.vars='id', variable.name='Question', value.name='Response')

# ggplot(datc_long, aes(Question, Response, group=resp, color=Ward)) + 
#     geom_line(alpha=.2, position='jitter') +
#     coord_flip() + 
#     theme_bw() + theme(legend.position='none')

Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
}

shinyServer(function(input, output) {
   
  output$wardHistPlot <- renderPlot({
     
    # generate and plot an rnorm distribution with the requested
    # number of observations
    pl <- ggplot(dat, aes_string(x=input$question)) +
        geom_histogram(binwidth=1) + facet_wrap(~ward, scales='free') + xlim(1,6)
    print(pl)
  })
  
  output$patternPlot <- renderPlot({
      dat_to_plot <- if (input$ward == 'All') datc_long else subset(datc_long, Ward==input$ward)
      pl <- ggplot(dat_to_plot, aes(Question, Response, group=resp)) + 
          geom_line(alpha=.2, position='jitter') +
          stat_summary(aes(group=NULL), fun.y=Mode, geom='point', size=3, color='red') + 
          coord_flip() + 
          theme_bw() + theme(legend.position='none')
      print(pl)
      
  })
})
