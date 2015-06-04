#!/usr/bin/env python


# Tool for printing the last test result of each test case

import os, sys

# Get a list of all the contents of the test folder
THIS_FOLDER    = os.path.dirname(os.path.abspath(__file__))
TEST_FOLDER    = os.path.join(THIS_FOLDER, '..')
folderContents = os.listdir(TEST_FOLDER)

for f in folderContents:

    # Skip items that are not test case folders
    if len(f) < 4:
        continue;
    if f[:2] != "ss":
      continue

    # Get paths
    testFolder = os.path.join(TEST_FOLDER, f)
    statusPath = os.path.join(testFolder,  'status.txt')

    # Parse the status file
    # - It should look something like this: done lunokhod1 Fail 6:31.75
    if not os.path.exists(statusPath):
        status    = 'INCOMPLETE'
        colorCode = '\033[93m'
    else:
        with open(statusPath, 'r') as handle:
            statusLine = handle.readline()
        if 'Fail' in statusLine:
            status    = 'FAIL'
            colorCode = '\033[91m'
        elif 'Pass' in statusLine:
            status    = 'PASS'
            colorCode = '\033[92m'
        else:
            status    = 'UNKNOWN'
            colorCode = '\033[93m'

    # Print the result in the selected color
    END_COLOR_CODE = '\033[0m'
    print colorCode + status + ' <=== ' + f + END_COLOR_CODE

