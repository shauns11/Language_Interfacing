/*==============================================================================
    Project:    Language_Interfacing
    Author:     Shaun Scholes
    Date:       August 2026
    Purpose:    Integrating Stata and R in a do-file
    Input:      Commands
	Location:   "C:/Language_Interfacing/code/01. Version_control"
==============================================================================*/

*Set up (instructions.do):
!git config --global user.name "Shaun Scholes"
!git config --global user.email "s.scholes@ucl.ac.uk"
!git --version
cd "C:/"
!git clone https://github.com/shauns11/Language_Interfacing.git 
!git status
!git remote -v

*create new folders.
cd "C:/Language_Interfacing"
!mkdir "./code"
!mkdir "./code/input_code"
!mkdir "./data"
!mkdir "./dbnomics_python"
!mkdir "./output"

*Put scripts in code folder
cd "C:/Language_Interfacing"
!git status                           
!git add -- "./code" "./code/input_code"
!git status 
*Ready to commit:
*!git commit -m "Commit staged code changes"            
*!git push -u origin main             




