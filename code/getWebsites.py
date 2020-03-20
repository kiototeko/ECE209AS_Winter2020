from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import subprocess
import time
import os

protocol = "https://"
websites = [
"apple.com",
"www.google.com/search?q=h",
"youtube.com" #,
#"play.google.com",
#"microsoft.com",
]
"""
"support.google.com",
"www.blogger.com",
"adobe.com",
"wordpress.org"
]
"""
driver = webdriver.Firefox()

for idx,w in enumerate(websites):
	driver.get(protocol + w)
	if(idx < len(websites)-1):
		driver.execute_script("window.open('');")
		driver.switch_to.window(driver.window_handles[idx+1])
"""
for vol in [1, 10, 20, 30, 40, 50, 60]:
	subprocess.call(['amixer', 'sset', '"Master"', str(vol) + '%'])
	dpath = "/home/kiototeko/tareas/iotsec/python/samples_" + str(vol) + "/"
	if not os.path.exists(dpath):
		os.makedirs(dpath)
"""
#subprocess.call(['amixer', 'get', '"Master"'])
input()
dpath = "/home/kiototeko/tareas/iotsec/python/samples_env/"
for i in range(500,600):
	j = 0
	for window_handle in driver.window_handles:
		driver.switch_to.window(window_handle)	
		subprocess.check_call(['arecord', '-r', '96000', '-d', '5', '-f', 'S32_LE', dpath + str(j) + '_' + str(i) + '.wav'])
		j += 1


