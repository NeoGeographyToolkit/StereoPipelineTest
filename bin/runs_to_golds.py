#!/usr/bin/env python


# Tool for replacing gold folders with run folders.
# - Use this to declare tests a success (gold becomes the current run output).
# - Pass one or more test names; each must be a single test-directory name.

import os, sys, shutil, common


def runToGold(f):
    '''Replace a test's gold folder with its run folder.'''

    # Guard: a test name is a single directory name, never a path or a joined
    # list of names. Refuse a malformed argument (for example a space-joined
    # list that a caller's shell failed to word-split, as zsh does not split
    # unquoted variables) rather than acting on it.
    if (not f) or (' ' in f) or ('/' in f) or (f in ('.', '..')):
        sys.exit('ERROR: bad test name (no spaces, slashes, or joined lists): [%s]' % f)

    testFolder = os.path.join(common.TEST_FOLDER, f)
    goldFolder = os.path.join(testFolder, 'gold')
    runFolder  = os.path.join(testFolder, 'run')

    if not os.path.isdir(testFolder):
        sys.exit('ERROR: no such test folder: ' + testFolder)
    if not os.path.isdir(runFolder):
        sys.exit('ERROR: no run folder to copy from: ' + runFolder)

    # Pure-Python file operations (no shell), each taking a single path, so a
    # name can never be word-split into a multi-path remove.
    if os.path.isdir(goldFolder):
        shutil.rmtree(goldFolder)
    shutil.copytree(runFolder, goldFolder)
    print 'Updated gold from run: ' + f


# Get the list of folders to update
if len(sys.argv) > 1:
    casesToReplace = sys.argv[1:]
else:
    # Extract the names of all the processes that failed
    casesToReplace = common.getFailedTests()


# Process each of the folders
for f in casesToReplace:
    runToGold(f)
