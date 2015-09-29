# Run a test

import os, time, subprocess, pytest

def test_run(testName, setup):

    # Skip tests per the config file
    if testName in setup.skipTests:
        print("Will skip test: ", testName)
        return 1

    if not os.path.isdir(testName):
        print("No such directory: ", testName)
        assert 0

    # Switch to the directory where the test will take place
    os.chdir(testName)

    #The output file
    outFile = "./output.txt"

    # Open the log file and wipe it
    log = open(outFile, 'w')
    log.write('Starting test\n')
    log.close()

    # Re-open the file and append to it
    log = open(outFile, 'a')

    # Save the enf
    a = subprocess.Popen(["env"], stdout=log, stderr=log, shell=True)
    exitcode = a.wait()

    # Run the test
    a = subprocess.Popen(["./run.sh"], stdout=log, stderr=log, shell=True)
    exitcode = a.wait()

    # Validate the test
    a = subprocess.Popen(["./validate.sh"], stdout=log, stderr=log, shell=True)
    exitcode = a.wait()

    # Must return 0 on success
    assert ( exitcode == 0 )
