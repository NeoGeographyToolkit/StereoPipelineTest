StereoPipelineTest is a comprehensive, distributed, and fully
automated test suite for the Ames Stereo Pipeline (ASP). It attempts
to cover most, if not all, of the ways in which ASP can be used, and
the test suite should be updated regularly as more functionality is
added to ASP.

Usage: bin/run_tests.pl settings.conf

After the tests finish, a report is written to 'report.txt', and the
report is also emailed to the user.

A sample settings file is provided, named 'pfe.conf'. The settings
file has:

1. The tests to run (wildcard expressions are accepted).
2. The machines to distribute the runs across (they must be accessible
   via ssh and share disk storage).
3. How many processes to use on each machine (each process in turn uses 
   multiple threads).
4. If to do strict validatioin (that is, not allow, vs. allow, a small
   discrepancy between current and reference runs).
5. Environmental variables, such as the path to the ASP executables.

Each test needs to be in its own directory. A test is executed by
running the script 'run.sh' in that directory, which should create an
output directory named 'run'. A 'gold' directory must be present,
which has the reference run. At the conclusion of the run, the result in
the 'run' directory is compared to the reference in 'gold'. The test
will fail if the produced result is different or absent.

If a new test is added, the name of the test directory must be listed
in the settings file or match the wildcard pattern already present
there.

