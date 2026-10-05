version 19.5 
local a = 2
local b = 3

python:
from sfi import Scalar
def my_calcsum(num1, num2):
	my_result = num1 + num2
	Scalar.setValue("result", my_result)

my_calcsum(`a', `b')
end

display result

