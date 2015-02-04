#!/bin/bash
#
# Author: 	David McElligott
# Last Revised: 02/03/2015
#	
# Description: 
# 	If a line doesn't already exist in the file append it
#
# Usage:
#	LINE - a string if not matched will be appended to file
#	SRC_FILE - the path to the file to search / add line  

LINE="deb http://dl.google.com/linux/chrome/deb/ stable main"
SRC_FILE="/etc/apt/sources.list.d/google-chrome.list"

grep -q -F "$LINE" $SRC_FILE \
	|| sudo sh -c echo $(echo "$LINE" >> $SRC_FILE)
