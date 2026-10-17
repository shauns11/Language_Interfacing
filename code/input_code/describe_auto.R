setwd ("C:/Language_Interfacing/")
library(foreign)
auto<-read.dta("./data/auto.dta", convert.f=TRUE)
attributes(auto)