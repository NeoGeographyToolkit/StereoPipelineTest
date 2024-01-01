# Configuration for all tests. Each test is launched via test_run.py.

import pytest, os, sys, fnmatch, re

# Option parser
def pytest_addoption(parser):
    parser.addoption("--config", dest="config_file", default="",
                      help="Config file.")

# Parse options and store the config file
#@pytest.fixture(scope="session")
def pytest_generate_tests(metafunc):

    # Parse the config file name and store it in an env variable.
    # TODO: There must be a better way.
    os.environ["CONFIG"] = metafunc.config.option.config_file

    # Set the directory where all the test directories are located
    os.environ["BASE_DIR"] = os.getcwd()
    
    setup = TestSetup()

    # Read in all the tests. They start with "ss".
    # TODO: Find a better convention.
    count = 0
    tests = []
    for val in os.listdir(os.getcwd()):
        # Tests are in directories starting with 'ss'
        if not re.match('ss', val): continue
        if not os.path.isdir(val): continue
        #if count >= 3: break # temporary debug code
        count = count + 1
        if setup.checkIfRunTest(val): # Make sure this is on the runDirs list
            tests.append(val)

    # Create a test instance for every test name
    if 'testName' in metafunc.fixturenames:
        metafunc.parametrize("testName", tests)

# If anywhere in string one finds $SOMETHING, replace it with os.environ[SOMETHING]
def replaceEnv(line):
    while 1:
        a = re.match(r'^(.*?)\$(\w+)(.*?)$', line)
        if not a: break
        if a.group(2) in os.environ:
            line = a.group(1) + os.environ[a.group(2)] + a.group(3)
        else:
            print("No such environmental variable: ", a.group(2))
            line = a.group(1) + a.group(3)
    return line

# Parse the config file and save the variables we need to pass to the test
class TestSetup:
    def __init__(self):
        self.skipTests = {}
        self.runTests  = {}

        configFile = os.environ["CONFIG"]
        with open(configFile) as f:
            lines = f.readlines()
            for line in lines:
                line = line.rstrip() # wipe the newline

                # The tests to run. This can be a regexp.
                if re.match("runDirs", line):
                    for testName in line.split(" "):
                        self.runTests[testName] = 1

                # The tests to skip
                if re.match("skipTests", line):
                    for testName in line.split(" "):
                        self.skipTests[testName] = 1
                
                # Expand and store the environmental variables
                a = re.match(r'export (\w+)=(.*?)$', line)
                if a:
                    os.environ[a.group(1)] = replaceEnv(a.group(2))

    def checkIfRunTest(self, testName):
        '''
        Returns true if this test is indicated by the runDirs line in the config file,
        and if it is not in the skipTests line.
        '''
        for pattern in self.runTests:
            if testName in self.skipTests:
                return False
            # Note how we match a pattern in the tests to run
            if fnmatch.fnmatch(testName, pattern):
                return True
        return False

@pytest.fixture(scope="session", autouse=True)
def setup():
    return TestSetup()
