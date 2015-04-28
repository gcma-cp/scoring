#!/usr/bin/python
import os
import stat
from sys import argv
	rogueuser="Todd"
hashedpasswords = open("/etc/shadow")
passwdfile = open("/etc/passwd")
groups = open("/etc/group")
for x in rogueusers:
	if rogueuser in passwdfile:
		print("Rogue user detected")
	else:
		print("Rogue user deleted")

