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

muslim_politics$vote <- factor(ifelse(muslim_politics$rega!=1 | muslim_politics$pvote16a>2, NA,
                                      ifelse(muslim_politics$pvote16a==2, "No vote",
                                             ifelse(muslim_politics$pvote16b==1, "Trump",
                                                    ifelse(muslim_politics$pvote16b==2, "Clinton",
                                                           ifelse(muslim_politics$pvote16b==3, "Third party", NA))))),
                               levels=c("Clinton","Trump","Third party","No vote"))
table(muslim_politics$pvote16b, muslim_politics$vote, exclude=NULL)
table(muslim_politics$pvote16a, muslim_politics$vote, exclude=NULL)
table(muslim_politics$rega, muslim_politics$vote, exclude=NULL)

muslim_politics$religion <- factor(ifelse(muslim_politics$qe3==9, NA,
                                          ifelse(muslim_politics$qe3==4, "Not at all important",
                                                 ifelse(muslim_politics$qe3==3, "Not too important",
                                                        ifelse(muslim_politics$qe3==2, "Somewhat Important",
                                                               ifelse(muslim_politics$qe3==1, "Very Important", NA))))),
                                          levels=c("Very Important", "Somewhat Important", "Not too important", "Not at all important"))
table(muslim_politics$qe3)
table(muslim_politics$religion)
table(muslim_politics$father_birthregion2)
muslim_politics$generation <- factor(ifelse(muslim_politics$respondent_birthregion2!=1, "First Generation",
                                            ifelse((muslim_politics$father_birthregion2!=1&muslim_politics$mother_birthregion2!=1), "Second Generation", 
                                                   ifelse(((muslim_politics$father_birthregion2!=1&muslim_politics$mother_birthregion2==1)|(muslim_politics$father_birthregion2==1&muslim_politics$mother_birthregion2!=1)), "2.5 Generation",    
                                                   "Third Generation"))),
levels=c("First Generation", "Second Generation", "2.5 Generation", "Third Generation"))
table(muslim_politics$generation)

muslim_politics$denom <- factor(ifelse(muslim_politics$qz1rec==9, NA,
                                       ifelse(muslim_politics$qz1rec==5, "Non-Denominational",
                                              ifelse(muslim_politics$qz1rec==3, "Other",
                                                     ifelse(muslim_politics$qz1rec==2, "Sunni",
                                                            "Shia")))),
levels=c("Shia","Sunni","Other","Non-Denominational"))

table(muslim_politics$father_birthregion2, muslim_politics$mother_birthregion2)

## a bunch of other stuff

muslim_politics$age <- factor(ifelse(muslim_politics$agerec>12, NA, 
                                     ifelse(muslim_politics$agerec<4, "18-29",
                                            ifelse(muslim_politics$agerec<8, "30-49", "50+"))),
                              levels=c("18-29", "30-49", "50+"))

analytical_data <- subset(muslim_politics, !is.na(vote),
                          select=c("vote","generation","religion",
                                   "respondent_birthregion2", "denom","age"))

save(analytical_data, file="output/analytical_data.RData")

#analytical_data$generation.n <- as.numeric(as.character(analytical_data$generation))
#analytical_data$religion.n <- as.numeric(as.character(analytical_data$religion))

#interact <-lm(vote ~ generation.n + religion.n + generation.n*religion.n, data = analytical_data)

model.lpm <- lm(vote=="Trump"~generation + religion + generation*religion, data= analytical_data)

summary(model.lpm)
