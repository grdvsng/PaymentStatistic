from os.path import abspath, realpath, dirname
from sys import path 

# Не хватило времени обложить тестами.
'''
aplicationPath = dirname(dirname(realpath(__file__))) + "\\bin"
path.append(aplicationPath) 

from DataDownloader import *


urls = [	
	'http://www.gks.ru/bgd/free/B19_00/Main.htm',
	'http://www.gks.ru/bgd/free/B19_00/Main.htm'
	]

def _data_checker(url, ):
	test = HTMLParser(url)
	assert test() is 1
	print(test.data)

for url in urls:
	_data_checker(url)
'''