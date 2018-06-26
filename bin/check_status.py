#!/usr/bin/env python


# Tool for printing the last test result of each test case

import os, sys, optparse, common



def printTest(test, status, skipSuccess):
    '''Pretty print the result of one test'''

    if status == common.STATUS_INCOMPLETE:
        text      = 'INCOMPLETE'
        colorCode = '\033[93m'
    if status == common.STATUS_FAIL:
        text      = 'FAIL'
        colorCode = '\033[91m'
    if status == common.STATUS_SUCCESS:
        text      = 'PASS'
        colorCode = '\033[92m'
    if status == common.STATUS_NO_GOLD:
        text      = 'NO GOLD'
        colorCode = '\033[94m'

    # Print the result in the selected color
    END_COLOR_CODE = '\033[0m'
    if not skipSuccess:
        print colorCode + text + ' <=== ' + test + END_COLOR_CODE
    else:
       if (status != common.STATUS_SUCCESS):
           print colorCode + test + END_COLOR_CODE


def main(argsIn):

    try:
        usage = "usage: registration_processor.py [--help]\n  "
        parser = optparse.OptionParser(usage=usage)

        parser.add_option("--skip-successful", dest="skipSuccess", action="store_true", default=False,
                          help="Do not display successful tests.")
        parser.add_option("--conf-file", dest="confFile", default=None,
                          help="Specify configuration file to load skipped tests from.")

        (options, args) = parser.parse_args(argsIn)

    except optparse.OptionError, msg:
        raise Usage(msg)


    # Check the status on all of the tests
    allTests   = common.getAllTests(options.confFile)
    testStatus = [common.checkStatus(f) for f in allTests]

    # Pretty print the results
    for test, status in zip(allTests, testStatus):
        printTest(test, status, options.skipSuccess)



# Run main function if file used from shell
if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))



