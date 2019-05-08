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
