#!/usr/bin/env python


# Tool for replacing a bunch of gold folders at once
# - Use this to update all your failing gold folders to the latest version.

import os, sys, subprocess, re

# Get a list of all the contents of the test folder
THIS_FOLDER    = os.path.dirname(os.path.abspath(__file__))
TEST_FOLDER    = os.path.join(THIS_FOLDER, '..')

OLEG_FOLDER = '/home/oalexan1/projects/StereoPipelineTest/'

# Call check_stats to find all the failed tests
checkPath = os.path.join(THIS_FOLDER, 'check_status.py')
cmd = ['python', checkPath]
p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
textOutput, err = p.communicate()

# Extract the names of all the processes that failed
casesToReplace = []
for line in textOutput.split('\n'):
    #if 'FAIL' not in line:
    #    continue
    # Extract the name portion
    startPos = 0#line.rfind('=')+1
    name = line[startPos:]
    # Strip out weird color characters
    name = re.sub('[^_A-Za-z0-9.]+', '',name)
    name = re.sub('0m+', '',name) # Clean a '0m' that shows up at the end of the line
    name = re.sub('91m', '',name) # Clean a '91m' that shows up at the start of the line

    if len(name) > 4:
        casesToReplace.append(name.strip())

#print casesToReplace
#raise Exception('DEBUG')

for f in casesToReplace:

    # Skip items that are not test case folders
    if len(f) < 4:
        continue;
    if f[:2] != "ss":
      continue

    # Get paths
    testFolder     = os.path.join(TEST_FOLDER, f)
    goldFolder     = os.path.join(testFolder,  'gold')
    olegFolder     = os.path.join(OLEG_FOLDER, f)
    olegGoldFolder = os.path.join(olegFolder,  'gold')


    cmd = 'rm -rf ' + goldFolder
    print cmd
    os.system(cmd)
    
    cmd = 'cp -r ' + olegGoldFolder +' '+ goldFolder
    print cmd
    os.system(cmd)

