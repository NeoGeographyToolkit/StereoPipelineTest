# Run a test

import os, time, subprocess, pytest

def test_run(testName, setup):

    # Skip tests per the config file
    if testName in setup.skipTests:
        print("Will skip test: ", testName)
        return 1

    # Switch to the base directory
    os.chdir(os.environ["BASE_DIR"])

    if not os.path.isdir(testName):
        print("No such directory: ", testName)
        assert 0

    # Switch to the directory where the test will take place
    os.chdir(testName)

    #The log file
    logFile = "output.txt"

    # Open the log file and wipe it
    log = open(logFile, 'w')
    log.write('Starting test\n')
    log.close()

    # Re-open the file and append to it
    log = open(logFile, 'a')

    # Save the env for the test
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
