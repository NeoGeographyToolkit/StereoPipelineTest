StereoPipelineTest is a comprehensive, distributed, and fully
automated test suite for the Ames Stereo Pipeline (ASP). It attempts
to cover most, if not all, of the ways in which ASP can be used, and
the test suite should be updated regularly as more functionality is
added to ASP.

== Installation ==

StereoPipelineTest uses the Python pytest framework to run the tests.
It can be installed as follows:

    conda create -n pytest pytest pytest-xdist pytest-timeout

== Usage ==

Sample invocation: 

  $HOME/miniconda3/envs/pytest/bin/python   \
    $HOME/miniconda3/envs/pytest/bin/pytest \
    -n <num cpu> -q -s -r a --tb=no         \
    --config <settings file>                \
    > report.txt

Here, <num cpu> is how many processes to use. 

The files conftest.py and test_run.py control the behavior of pytest.

This tool allows one to run just a subset of the tests. For example,
to run all tests whose directory names have the string 'CSM', append
to the above command: 
  
  -k CSM

To run several tests whose directory names are test1, test2, test3,
use:

  -k 'test1 or test2 or test3'

== More details == 

A sample settings file is provided, named
'release_lunokhod1.conf'. This file has:

1. The tests to run (wildcard expressions are accepted). It usually
   looks like: runDirs = ss*
2. The machines to distribute the runs across (they must be accessible
   via ssh and share disk storage).
3. How many processes to use on each machine (each process in turn uses 
   multiple threads).
4. Environmental variables, such as the path to the ASP executables.
5. A list of tests and maximum error per test for each to pass. If a
   test is not listed here, it will still be run, but it will fail if the
   maximum error is > 0.

Each test needs to be in its own directory. A test is executed by
running the script 'run.sh' in that directory, which should create an
output directory named 'run'. A 'gold' directory must be present,
which has the reference run. At the conclusion of the run, the result in
the 'run' directory is compared to the reference in 'gold'. The test
will fail if the produced result is different or absent.

If a new test is added, the name of the test directory must be listed
in the settings file or match the wildcard pattern already present
there. Each test must have a 'run.sh' file, and a validation script,
named 'validate.sh'. The 'validate.sh' script must return exit status
0 on successful validation, and non-zero otherwise.

The output of 'run.sh', its elapsed time, and maximum memory usage of
the programs launched by it, as well as the output of 'validate.sh',
are all written to a file called 'output.txt' in run's
directory. Also, most ASP tools write log files, which would be found
in both the current 'run' directory and reference ('gold') directory.

When tests fail, which is inevitable when something changes, and the
new results are deemed acceptable, the 'gold' reference directory
needs to be updated by copying the output from the 'run' directory. 

If the processes is terminated before all tests finish, the last result
for each test can be seen by running bin/check_status.py.

== Troubleshooting ==

If pytest is not found, try running 

  source [BINARY_BUILDER_DIR]/auto_build/utils.sh

If the --timeout or -n options are missing, that means pytest-xdist or
pytest-timeout were not installed or cannot be found.

== Tools ==

There are a number of utilities in the main and bin/ folders which can
be useful for working with tests.  These include:

runs_to_golds.py:
   Convert all run folders to gold folders or pass in a
  single test name to just convert the folders for that test.

check_status.py:
  Tries to print the last run status of each test.  Use
  the "--conf-file" argument to limit the list to non-disabled tests.

== Running tests in the cloud ==

The script

  StereoPipeline/.github/workflows/build_test.sh

builds ASP and runs the tests for Mac in the cloud. The latest test results are
saved, together with the build, as an artifact. The artifact can be fetched, and
the reference test results updated (or new tests added) with the script:

  StereoPipeline/.github/workflows/update_mac_tests.sh
