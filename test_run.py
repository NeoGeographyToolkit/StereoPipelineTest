# Run a single test. The setup is done in conftest.py.

import os, sys, time, subprocess, pytest

def test_run(testName, setup):
    '''Function called for each test that is run.
       "setup" is populated by a TestSetup object from conftest.py'''

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

    # The log file where all the text output printed below will go to
    logFile = "output.txt"

    # Open the log file in write mode and wipe it
    logHandle = open(logFile, 'w')
    logHandle.write('Starting test\n')
    logHandle.close()

    # Re-open the file and append to it
    logHandle = open(logFile, 'a')

    # Save the env for the test
    a = subprocess.Popen(['env'], stdout = logHandle, stderr = logHandle, shell = False)
    exitcode = a.wait()

    # The script having the test to run
    cmd= ['./run.sh']

    # On Linux check memory usage and run time
    if 'linux' in sys.platform:
        fmt_str = cmd[0] + ': elapsed=%E ([hours:]minutes:sec.subsec), memory=%M (kb)'
        cmd = ['/usr/bin/time', '-f', fmt_str] + cmd
        
    # Run the test. Do not start a shell, as then the command must be a string
    # and not an array of strings.
    a = subprocess.Popen(cmd, stdout = logHandle, stderr = logHandle, shell = False)
    exitcode = a.wait()

    # Validate the test
    a = subprocess.Popen(['./validate.sh'], stdout = logHandle, stderr = logHandle, shell = False)
    exitcode = a.wait()

    # Must return 0 on success
    assert (exitcode == 0)
