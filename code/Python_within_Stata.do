
/*==============================================================================
    Project:    Language_Interfacing
    Author:     Shaun Scholes
    Date:       August 2026
    Purpose:    Integrating Stata and Python in a do-file
    Input:      Commands
	Location:   "C:/Language_Interfacing/code/Python_within_Stata"
==============================================================================*/


cd "C:/Language_Interfacing"

!git add "./code/input_code/pyex.py" "./code/input_code/pyex1.do" "./code/input_code/pyex2.do" "./code/input_code/Python_script.py"
!git add "./code/Python_within_Stata.do" 

sysdir
capture log close  
set more off
clear
log using "./output/Python_within_Stata.log", replace

python search
python which pandas


*****************************
*Functions not using datasets
*do not use print - use return
*****************************

python:
def my_function():
  return("Hello from a function")
my_function()
end


*Example: input is fahrenheit.
python:
def fah_to_cels(fahrenheit):
  return (fahrenheit - 32) * 5 / 9
print(fah_to_cels(77))
print(fah_to_cels(78))
end

python:
def addtwo(x,y):
  return (x+y)*2
print(addtwo(4,5))
end


****************************
*argument is the array
*function is the mean
****************************
python:
import numpy as np
df = np.array([25.1, 25.2, 25.3, 25.4, 25.5])
def print_mean(x):
	a = np.mean(x)
	b = np.std(x)
	return(a)
	return(b)
	return(a+b)
print_mean(df)
end

*add two arrays
python:
import numpy as np
df1 = np.array([25.1, 25.2, 25.3, 25.4, 25.5])
df2 = np.array([25.1, 25.2, 25.3, 25.4, 25.5])

def add_array(x,y):
	df = x + y
	return(df)
	
add_array(df1,df2)
end

*sumproduct
python:
import numpy as np
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])

def sumproduct(x,y):
	result1 = np.sum(x * y)
	result2 = np.dot(x, y)
	return(result1,result2)
	
sumproduct(a,b)
end

*{python}
python:
x = 2 + 2
y = x*4
print(x)
print(y)
end

*{Python and Stata}
python:
word = 'Python'
word[0], word[-1]
len(word)
squares = [1,4,9,16,25]
squares
from math import pi
[str(round(pi, i)) for i in range(1,8)]

for i in range(3):
   print(i)

stata: sysuse auto, clear
stata: regress mpg weight foreign
end

*Run python scripts
python script "./code/input_code/Python_script.py"

*Run python code that has been used in these do-files.
clear all 
do "./code/input_code/pyex1.do"
clear all
do "./code/input_code/pyex2.do"


**********************************************
*using locals and then running python script
**********************************************

version 19.5 
local a = 2
local b = 3
python script "./code/input_code/pyex.py"
display result


version 19.5 
local a = 2
local b = 3
python script "./code/input_code/pyex.py", args(`a' `b')
display result


*==================
*Example
*==================

*Download data within Python.
*Export and analyse data in Stata.

clear
python:
import yfinance as yf
dowjones = yf.download("^DJI", start="2010-01-01", end="2019-12-31")
dowjones
dowjones.index
dowjones['dowdate'] = dowjones.index.astype(str)
dowjones['dowdate']
end

python:
from sfi import Data
Data.setObsTotal(len(dowjones))
end

*Prepare the data
python:
dates = dowjones["dowdate"].astype(str).str.slice(0, 10).tolist()
closes = dowjones[("Close", "^DJI")].astype(float).tolist()
volumes = dowjones[("Volume", "^DJI")].astype(int).tolist()
end

*Set observations and add variables
python:
Data.setObsTotal(len(dowjones))
Data.addVarStr("dowdate", 10)
Data.addVarDouble("dowclose")
Data.addVarInt("dowvolume")
end

*Store the data
python:
Data.store("dowdate", None, dates, None)
Data.store("dowclose", None, closes, None)
Data.store("dowvolume", None, volumes, None)
end

*{Stata}.
list in 1/5, abbreviate(9)
generate date = date(dowdate,"YMD")
list in 1/5, abbreviate(9)
format %tdCCYY-NN-DD date

list in 1/5, abbreviate(9)
format %16.0fc dowvolume

list in 1/5, abbreviate(9)
replace dowvolume = dowvolume/1000000
format %10.2fc dowvolume
label variable dowvolume "DJIA Volume (Millions of Shares)"
list in 1/5, abbreviate(9)

twoway (line dowclose date, lcolor(green) lwidth(medium))         ///
       (bar dowvolume date, fcolor(blue) lcolor(blue) yaxis(2)),  ///
       title("Dow Jones Industrial Average (2010 - 2019)")        ///
       xtitle("") ytitle("") ytitle("", axis(2))                  ///
       xlabel(, labsize(small) angle(horizontal))                 ///
       ylabel(5000(5000)30000,                                    ///
              labsize(small) labcolor(green)                      ///
              angle(horizontal) format(%9.0fc))                   ///
       ylabel(0(500)3000,                                         ///
              labsize(small) labcolor(blue)                       ///
              angle(horizontal) axis(2))                          ///
       legend(order(1 "Closing Price" 2 "Volume (millions)")      ///
              cols(1) position(10) ring(0))
			  
		graph close	  
			  

*===============================================================================
*Stata and python
*Ensuring python has the dataset you want via formatting; sample selection etc.
*===============================================================================

*{Stata}
sysuse auto, clear

python:
from sfi import Data
df = Data.get('foreign')
df
end

python:
from sfi import Data
df   = Data.get('foreign mpg rep78',
               range(46,56))
df
end

*{Stata}
generate touse = mpg<20

python:
from sfi import Data
df   = Data.get('foreign mpg rep78',
                     range(46,56),
                     "touse")
df
end

python:
from sfi import Data
df   = Data.get('foreign mpg rep78',
                     range(46,56),
                     "touse",
                     valuelabel=True)
df
end

python:
from sfi import Data
import numpy as np
df   = Data.get('foreign mpg rep78',
                     range(46,56),
                     "touse",
                     valuelabel=True,
                     missingval=np.nan)
df
end

*Convert the list object to a pandas data frame

python:
from sfi import Data
import numpy as np
import pandas as pd
df   = Data.get('foreign mpg rep78',
                     range(46,56),
                     "touse",
                     valuelabel=True,
                     missingval=np.nan)
df_python = pd.DataFrame(df)
df_python
end

python:
from sfi import Data
import numpy as np
import pandas as pd
df   = Data.get('foreign mpg rep78',
                     range(46,56),
                     "touse",
                     valuelabel=True,
                     missingval=np.nan)
df_python = pd.DataFrame(df,
                         columns=['foreign', 'mpg', 'rep78'])
df_python
end

*Begin the data frame index at 1

python:
from sfi import Data
import numpy as np
import pandas as pd
df   = Data.get('foreign mpg rep78',
                     range(46,56),
                     "touse",
                     valuelabel=True,
                     missingval=np.nan)
df_python = pd.DataFrame(df,
                         columns=['foreign', 'mpg', 'rep78'],
                         index=[np.arange(1, len(df)+1)])
df_python
end

*dictionary

python:
from sfi import Data
import pandas as pd
import numpy as np
df = Data.getAsDict('foreign mpg rep78',
                          range(46,56),
                          "touse",
                          valuelabel=True,
                          missingval=np.nan)
df
obs = len(next(iter(df.values()))) + 1
df_python = pd.DataFrame(df,
                         index=[np.arange(1, obs)])
df_python
end

*Just the basics to import Stata dataset into Python
python:
from sfi import Data
import pandas as pd
import numpy as np
df = Data.getAsDict('foreign mpg rep78',
                         None,
                         None,
                         valuelabel=False,
                         missingval=np.nan)
df_python = pd.DataFrame(df)
df_python
end

*=========================================================================================
*https://medium.com/the-stata-gallery/using-dbnomics-with-stata-and-python-df31c09203c6
*=========================================================================================

capture ssc install kountry 
capture ssc install dbnomics 
capture ssc install libjson
capture ssc install moss
capture ssc install lgraph

!mkdir "./dbnomics_python"
cd "./dbnomics_python"

python:
import dbnomics as db
df = db.fetch_series(
    'IMF','FDI',
    dimensions={'FREQ':['A'], 'INDICATOR':['FD_FD_IX']},
    max_nb_series=10000
)
end

// Create the excel file
python:
excel_filename = "FD_FD_IX.xlsx"
df.to_excel(excel_filename, index=False)
print("Saved:", excel_filename)
end

*{Stata}
import excel FD_FD_IX.xlsx, firstrow clear
drop frequency provider_code dataset_code dataset_name ///
 series_code series_name FREQ INDICATOR ///
 Frequency Indicator

// Use kountry and prepare the dataset 
kountry REF_AREA, from(iso2c)
rename NAMES_STD name
kountry REF_AREA, from(iso2c) to(imfn)
rename _IMFN_ imfcode
replace name="United Arab Emirates" if imfcode==466
replace name="Serbia" if imfcode==965
drop if imfcode==.
drop period
drop original_value
rename original_period period
rename value FD
order imfcode name period

// Prepare the data
destring period, replace
xtset imfcode period
xtdes

// Create the country groups (requires the ado-file 'group_dummy')
rename imfcode cn
rename cn imfcode 
*arbitrary grouping.
gen idc=imfcode<500
gen emg=imfcode>499

gen FDidc=FD if idc==1
gen FDemg=FD if emg==1

lab var FD "Full Sample"
lab var FDidc "Industrial Countries"
lab var FDemg "Emerging Markets"

// Use lgraph to draw time series graph with panel data
set scheme s1color
graph set window fontface "Palatino Linotype"

lgraph FD FDidc FDemg period, wide ///
 ti("Financial Development") xti("") yti("") ///
 note("`Note: Data from the IMF.'") xline(2008) ///
 text(0.5 2008 "{it:GFC}", box margin(small) fc(white)) ///
 name("FinDev", replace)
 
graph export "FinDev.png", as(png) width(4000) replace
graph close

*erase all files in output folder.
local folder "C:/Language_interfacing/dbnomics_python"

local files : dir "`folder'" files "*"
foreach f of local files {
    erase "`folder'/`f'"
}

cd "C:/Language_interfacing"

!git add "./code/Python_within_Stata.do" 
!git commit -m "Commit Python_within_Stata"             // commit the local changes
!git push -u origin main                                // push locally


di "Finished"
*Display date and time.
local date `c(current_date)'
local time `c(current_time)'
display _newline "Run `date' at `time'"


log close

































