# Configuration for all tests.

import pytest, os, sys, re

# Option parser
def pytest_addoption(parser):
    parser.addoption("--config", dest="config_file", default="",
                      help="Choose the output resolution in meters per pixel on the ground (note that a coarse resolution may result in aliasing).")

# Parse options and store the config file
@pytest.fixture(scope="session")
def pytest_generate_tests(metafunc):

    # Parse the config file name and store it in an env variable.
    # TODO: There must be a better way.
    os.environ["CONFIG"] = metafunc.config.option.config_file

    os.environ["BASE_DIR"] = os.getcwd()

    # Read in all the tests. They start with "ss".
    # TODO: Find a better convention.
    count = 0
    tests = []
    for val in os.listdir(os.getcwd()):
        if not re.match('ss', val): continue
        if not os.path.isdir(val): continue
        if count >= 3: break # temporary debug code
        count = count + 1
        tests.append(val)

    if 'testName' in metafunc.fixturenames:
        metafunc.parametrize("testName", tests)

# Anywhere in string one finds $SOMETHING, replace it with os.environ[SOMETHING]
def replaceEnv(line):
    while 1:
        a = re.match('^(.*?)\$(\w+)(.*?)$', line)
        if not a: break
        if a.group(2) in os.environ:
            line = a.group(1) + os.environ[a.group(2)] + a.group(3)
        else:
            print("No such environmental variable: ", a.group(2))
    return line

# Parse the config file and save the variables we need to pass to the
# test
class TestSetup:
    def __init__(self):
        self.env={}
        self.skipTests={}

        configFile = os.environ["CONFIG"]
        with open(configFile) as f:
            lines = f.readlines()
            for line in lines:
                line = line.rstrip() # wipe the newline

                # Read the skipped tests
                if re.match("skipTests", line):
                    for skip in line.split(" "):
                        self.skipTests[skip] = 1

                # Expand and store the environmental variables
                a = re.match('export (\w+)=(.*?)$', line)
                if a:
                    os.environ[a.group(1)] = replaceEnv(a.group(2))


@pytest.fixture(scope="session", autouse=True)
def setup():
    return TestSetup()
