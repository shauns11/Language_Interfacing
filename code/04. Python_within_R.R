#=============================================================
#Project:    Language_Interfacing
#Author:     Shaun Scholes
#Date:       August 2026
#Purpose:    Run python script within R_Studio.
#Input:      Commands
#Location:   "C:/Language_Interfacing/code/04. Python_within_R.R"
#==============================================================
  
setwd("C:/Language_Interfacing")
library(reticulate)
library(haven)

os <- reticulate::import("os")
os$listdir(".")
py_eval("2 + 2")
#python script containing function ('add')
source_python("./code/input_code/add.py")
#use the function within R.
add(5, 10)

#============================
#import auto dataset into R.
#============================

py_config()
py_install("pandas")
py_require(c("pandas"))
df <- read_dta("./data/auto.dta")

# Convert labelled columns to ordinary R vectors before 
# passing data to python.

df[] <- lapply(df, function(x) {
  if (inherits(x, "haven_labelled")) {
    haven::zap_labels(x)
  } else {
    x
  }
})

source_python("./code/input_code/import_auto.py")

#select_data function.
auto_selected <- select_data(df)
auto_selected

#inspect_data function.
inspect_data(auto_selected)

#================
#version control.
#================
getwd()

system2("git", c("config", "--global", "user.name", "Shaun Scholes"))
system2("git", c("config", "--global", "user.email", "s.scholes@ucl.ac.uk"))


system2("git", c("rev-parse", "--show-toplevel"))
system2("git", c("status", "--short", "--branch"))
system2("git", c("config", "--get", "remote.origin.url"))
system2("git", c("remote", "-v"))

#stage.
system2("git", c(
  "add",
  "./code/",
  "./code/input_code/"
))

#commit.
system2(
  "git",
  args = c("commit", "-m", shQuote("Commit 4 (Python_within_R"))
)

#push to remote.
system2("git", c("push", "-u", "origin", "main"))
print(paste("Python within R finished at", format(Sys.time(),
                                                  "%Y-%m-%d %H:%M:%S")))









