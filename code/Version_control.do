/*==============================================================================
    Project:    Language_Interfacing
    Author:     Shaun Scholes
    Date:       August 2026
    Purpose:    Integrating Stata and R in a do-file
    Input:      Commands
	Location:   "C:/Language_Interfacing/code/Version_control"
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
!mkdir "./output"

*version control.do in code folder

!git status                           // local changes now staged.
!git add --all
!git commit -m "Commit 1"             // commit the local changes
!git push -u origin main              // push locally


*move files from desktop to local.



