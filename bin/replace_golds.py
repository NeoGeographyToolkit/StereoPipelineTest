#!/usr/bin/env python


# Tool for replacing a bunch of gold folders at once
# - Use this to update all your failing gold folders to the latest version.

import os, sys, subprocess, re, common

# Get a list of all the contents of the test folder
THIS_FOLDER    = os.path.dirname(os.path.abspath(__file__))
TEST_FOLDER    = os.path.join(THIS_FOLDER, '..')

OLEG_FOLDER = '/home/oalexan1/projects/StereoPipelineTest/'


def replaceGold(f):
    '''Replace the gold folder with one from Oleg's directory'''

    # Get paths
    testFolder     = os.path.join(common.TEST_FOLDER, f)
    goldFolder     = os.path.join(testFolder,  'gold')
    olegFolder     = os.path.join(OLEG_FOLDER, f)
    olegGoldFolder = os.path.join(olegFolder,  'gold')

    cmd = 'rm -rf ' + goldFolder
    print cmd
    os.system(cmd)
    
    cmd = 'rsync -arv lunokhod1:' + olegGoldFolder +' ' + testFolder
    print cmd
    os.system(cmd)



# Extract the names of all the processes that failed
casesToReplace = common.getFailedTests()

# Process each of the folders
for f in casesToReplace:
    replaceGold(f)
