#! /usr/bin/python
#
#

import cgi
import sys
sys.path.append('/home/pi/www/py')
from genfunctions import *

# uncomment to debug
#import cgitb
#cgitb.enable()

#import logging
#LOG_FILENAME = '/var/tmp/pp_www'
#logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG,)
#logging.debug('change.py called')

message=""
message=message+"Updating local media"

subprocess.call("/home/pi/processmail/processmedia.sh")
      
## Generate HTML

f = open('../stz/wait.stz', 'r')
for line in f:
	line = re.sub(r'\[\[-MESSAGE-\]\]', message, line)
        print line

f.close()

