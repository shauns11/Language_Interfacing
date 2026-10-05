version 19.5 // (or version 19 if you do not have StataNow)
local a = 2
local b = 3

python:
from sfi import Scalar
def my_calcsum(num1, num2):
	my_result = num1 + num2
	Scalar.setValue("result", my_result)
end

python: my_calcsum(`a', `b')
display result