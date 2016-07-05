#!/usr/bin/env python


# Python utility functions
import os, sys, subprocess, re

# Get a list of all the contents of the test folder
THIS_FOLDER    = os.path.dirname(os.path.abspath(__file__))
TEST_FOLDER    = os.path.join(THIS_FOLDER, '..')


STATUS_INCOMPLETE = -1
STATUS_FAIL       =  0
STATUS_SUCCESS    =  1

def checkStatus(testName):
    '''Print the status for one test'''
    
    # Get paths
    testFolder = os.path.join(TEST_FOLDER, testName)
    statusPath = os.path.join(testFolder,  'output.txt')

    status = STATUS_INCOMPLETE

    # Parse the output file
    if not os.path.exists(statusPath):
        return status

    with open(statusPath, 'r') as handle:
        for line in handle:
            if 'Validation succeded' in line:
                status = STATUS_SUCCESS
                break
            if 'Validation failed' in line:
                status = STATUS_FAIL
                break
    return status


def getAllTests(confFile):
    '''Return a list of all test names'''
    
    skipTests = []
    if confFile:
        skipTests = loadSkipTests(confFile)

    rawList = os.listdir(TEST_FOLDER)
    output = []
    for f in rawList:  
        # Skip items that are not test case folders
        if len(f) < 4:
            continue;
        if f[:2] != "ss":
          continue
        
        if f in skipTests:
            continue
            
        output.append(f)
        
    return output  

def getFailedTests(confFile):
    '''Return a list of the names of all failed tests'''

    # Check the status on all of the tests
    allTests   = getAllTests(confFile)
    testStatus = [checkStatus(f) for f in allTests]

    # Extract the names of all the processes that failed
    failedTests = []
    for test, status in zip(allTests, testStatus):
        if status == STATUS_SUCCESS:
            continue
        failedTests.append(test)        
      
    return failedTests

def loadSkipTests(confPath):
    '''Loads a list of skip files in the configuration file'''

    tests = []    
    f = open(confPath, 'r')
    for line in f:
        if 'skipTests' not in line:
            continue
        tests = line.split() # Grabs some bogus names, but that should be ok.
        break
    return tests


