/*==============================================================================
    Project:    Language_Interfacing
    Author:     Shaun Scholes
    Date:       August 2026
    Purpose:    Integrating Stata and R in a do-file
    Input:      Commands
	Location:   "C:/Language_Interfacing/code/R_within_Stata"
==============================================================================*/


cd "C:/Language_Interfacing"
!git status
!git add "./code/R_within_Stata.do"
!git add "./code/input_code/describe_auto.r"

sysdir
capture log close  
set more off
clear

log using "./output/R_within_Stata.log", replace

*Example using RSource.
global Rterm_path `"C:/Program Files (x86)/R/R-4.6.1/bin/x64/Rterm.exe"'       // R executable
global Rterm_options `"--vanilla"'
sysuse auto, clear
describe, full
saveold "./data/auto.dta", v(12) replace

*{R}
rsource, terminator(END_OF_R)
setwd ("C:/Language_Interfacing/")
library(foreign);
auto<-read.dta("./data/auto.dta", convert.f=TRUE);
attributes(auto);
q();
END_OF_R


*Example using RSource (run R script)
*{Stata}
global Rterm_path `"C:/Program Files (x86)/R/R-4.6.1/bin/x64/Rterm.exe"'
global Rterm_options `"--vanilla"'
rsource using  "./code/input_code/describe_auto.r"

****************************
*using rcall
****************************

*Communication from R to Stata

*{R}
rcall clear             
rcall: a <- 100
rcall: a
*{Stata}
display r(a)
        
rcall clear             
rcall: str <- "Hello World"
display r(str)
       
rcall: str <- c("Hello", "World")
display r(str)
        
rcall: v <- c(1,2,3,4,5)
display r(v)
       
rcall: A = matrix(1:6, nrow=2, byrow = TRUE)
mat list r(A)

rcall: mylist <- list(a=c(1:10))
display r(mylist_a)
    
rcall: l <- T
display r(l)
  

*Communication from Stata to R

*{Stata}
global a 99
*{R}
rcall: (a <- $a)
       
scalar a = 50
rcall: (a <- st.scalar(a))
       
matrix A = (1,2\3,4)
matrix B = (96,96\96,96)
rcall: C <- st.matrix(A) + st.matrix(B)
rcall: C
*mat list r(C)
       
sysuse auto, clear
rcall: dep <- st.var(price)
rcall: pre <- st.var(mpg)
rcall: lm(dep~pre)

rcall: data <- st.data("C:/Program Files/StataNow19/ado/base/a/auto.dta")
rcall: dim(data)

*If the filename is not specified, the function passes the currently loaded data to R.
sysuse auto, clear
rcall: data <- st.data()
rcall: dim(data)
    
*dataset from R to Stata
clear
rcall: st.load(cars)
list in 1/2
desc 

di "Finished"
*Display date and time.
local date `c(current_date)'
local time `c(current_time)'
display _newline "Run `date' at `time'"

!git add --all
!git commit -m "Commit R_within_Stata"             // commit the local changes
!git push -u origin main                           // push locally

!git fetch
!git status

log close























