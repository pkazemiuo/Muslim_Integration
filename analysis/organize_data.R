#' ---
#' title: "organize_data.R"
#' author: ""
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("useful_functions.R")

library(haven)
muslim_politics <- read_dta("input/Muslim-American-Final-Questionnaire/2017USMuslimPublicData - checked.dta")
