#!/usr/bin/env python


# Print the geodiff error statistics (if applicable) for each failing test

import os, sys, subprocess, re, optparse, common


# Handle arguments
try:
    usage = "usage: check_failing_stats.py [--help]\n  "
    parser = optparse.OptionParser(usage=usage)
    
    parser.add_option("--conf-file", dest="confFile", default=None,
                      help="Specify configuration file to load skipped tests from.")
    parser.add_option("--min-value", dest="minValue", default=0.0, type="float",
                      help="Display only tests with statistics greater than this.")
    (options, args) = parser.parse_args(sys.argv)

except optparse.OptionError, msg:
    raise Usage(msg)

# Extract the names of all the processes that failed
failedTests = common.getFailedTests(options.confFile)


def extractNumbersFromString(text):
    '''Find all the floating point numbers in a string'''
    parts = re.findall(r'[+-]?[0-9.]+', text)
    return [float(x) for x in parts]

def getTestStats(f, minValue):
    '''Print the stats for a single test'''

    # Get paths
    testFolder = os.path.join(common.TEST_FOLDER, f)
    goldFolder = os.path.join(testFolder, 'gold')
    runFolder  = os.path.join(testFolder, 'run')
    goldDem    = os.path.join(goldFolder, 'run-DEM.tif')
    runDem     = os.path.join(runFolder,  'run-DEM.tif')

    if os.path.exists(goldDem) and os.path.exists(runDem):
        binPath = os.path.join(common.TEST_FOLDER, 'bin/print_geodiff_stats.sh')
        cmd = [binPath, goldDem, runDem]
        #print cmd
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        text, err = p.communicate()
    else:
        text = ''
        err  = 'Both DEM files not present!'
    
    if len(err) > 5:
        print f + ' ---> ' + err.strip()
    else:
        # Check if any of the numbers in the string is greater than our target value
        numbers = extractNumbersFromString(text)
        over = False
        for n in numbers:
            if n > minValue:
                over = True
    
        if over: # Print output
            text = text.replace('Minimum', 'Min').replace('Maximum', 'Max')    
            print f + ' ---> ' + text.strip()
        


# Call the above function on all the failed tests
for f in failedTests:
    getTestStats(f, options.minValue)

