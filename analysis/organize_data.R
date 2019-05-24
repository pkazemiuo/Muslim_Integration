#' ---
#' title: "organize_data.R"
#' author: ""
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions

source("useful_functions.R")
setwd('~/soc312/Muslim_integration/analysis')
library(readr)
muslim_politics <- read.csv("input/pew_muslim_data.csv")

library(haven)
muslim_politics <- read_dta("input/Muslim-American-Final-Questionnaire/2017USMuslimPublicData - checked.dta")

muslim_politics$vote <- factor(ifelse(muslim_politics$rega!=1 | muslim_politics$pvote16a>2, NA,
                                      ifelse(muslim_politics$pvote16a==2, "No vote",
                                             ifelse(muslim_politics$pvote16b==1, "Trump",
                                                    ifelse(muslim_politics$pvote16b==2, "Clinton",
                                                           ifelse(muslim_politics$pvote16b==3, "Third party", NA))))),
                               levels=c("Clinton","Trump","Third party","No vote"))
table(muslim_politics$pvote16b, muslim_politics$vote, exclude=NULL)
table(muslim_politics$pvote16a, muslim_politics$vote, exclude=NULL)
table(muslim_politics$rega, muslim_politics$vote, exclude=NULL)

## a bunch of other stuff

analytical_data <- subset(muslim_politics, !is.na(vote),
                          select=c("vote"))

save(analytical_data, file="output/analytical_data.RData")

