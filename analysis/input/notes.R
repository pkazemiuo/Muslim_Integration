

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




library(readr)
muslim_politics <- read.csv("muslim")

###REGA=1: if they're registered to vote
###PvOTE16a 
table(muslim_politics$rega, muslim_politics$pvote16a)
#the people that didn't respond won't matter because they weren't registered to vote anyway'
#the one and the 6 in that category would be missing values (first line, 3 and 4 column)

muslim_politics$vote <- ifelse(muslim_politics$rega!=1, & muslim_politics$pvote16a>2, NA,
                               ifelse(muslim_politics$pvote16a==2, "No Vote",
                                      ifelse(muslim_politics$pvote16b==1, "Trump",
                                             ifelse(muslim_politics$pvote16b==2, "Clinton",
                                                    ifelse(muslim_politics$pvote16b==3, "Third Party", NA)))))),
levels=c("Clinton", "Trump", "Third Party", "No Vote")

table(muslim_politics$pvote16b, muslim_politics$vote, exclude=NULL)
#the missing values are because they didn't vote because they wren't registered

table(muslim_politics$pvote16a, muslim_politics$vote, exclude=NULL)

table(muslim_politics$rega, muslim_politics$vote, exclude=NULL)
#here the missing values in the first column is bc they refused to answer the question at a later point


## analytical data will be a subset of muslim politics and it'll drop all the missing values because they will have to have voted to be part of my analytical project. I'm only keeping the variables I need and dropping all the others
analytical_data <- subset(muslim_politics, !is.na)