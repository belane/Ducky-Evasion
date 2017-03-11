!/usr/bin/env python

from os import walk, system
from time import sleep

usb_devices = "/dev/bus/usb"

init_devices = []
actual_devices = []

for (dirpath, dirnames, filenames) in walk(usb_devices):
	if filenames:
		init_devices.extend([dirpath,filenames])

while True:
	actual_devices = []
	for (dirpath, dirnames, filenames) in walk(usb_devices):
		if filenames:
			actual_devices.extend([dirpath,filenames])
	if sorted(init_devices) != sorted(actual_devices):
		print "LOCK!"
		#system("gdmflexiserver")
		system("loginctl lock-session 2")
		exit()
	sleep(0.5)