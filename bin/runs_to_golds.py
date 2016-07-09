#!/usr/bin/env python


# Tool for replacing a bunch of gold folders with run folders at once
# - Use this to declare all your tests a success!

import os, sys, subprocess, re, common


def runToGold(f):
    '''Replace the gold folder with one from Oleg's directory'''

    # Get paths
    testFolder = os.path.join(common.TEST_FOLDER, f)
    goldFolder = os.path.join(testFolder, 'gold')
    runFolder  = os.path.join(testFolder, 'run')
    

    cmd = 'rm -rf ' + goldFolder
    print cmd
    os.system(cmd)
    
    cmd = 'cp -r ' + runFolder +' '+ goldFolder
    print cmd
    os.system(cmd)



# Extract the names of all the processes that failed
casesToReplace = common.getFailedTests()

# Process each of the folders
for f in casesToReplace:
    runToGold(f)

