StereoPipelineTestSuite is a comprehensive, distributed, and fully automated test suite for the Ames Stereo Pipeline (ASP). It attempts to cover most, if not all, of the ways in which ASP can be used, and the test suite should be updated regularly as more functionality is added to ASP.

Usage: bin/run_tests.pl settings.conf

A sample settings file is provided, named 'pfe.conf'. The settings file should list the tests to run (wildcard expressions are accepted), the machines to distribute the runs accross (they must be accessible via ssh and share disk storage), and how many CPUs to use on each machine.

Each test needs to be in its own directory. The test is executed by running the script 'run.sh' in that directory, which should create an output directory named 'run'. A 'gold' directory must be present, which has the reference run. At the conclusion of the run, the DEM in the 'run' directory is compared to the reference in 'gold'. The test will fail if the produced DEM is different or absent.

The path to the executables invoked by 'run.sh' is obtained from user's .bashenv file.

If a new test is added, the name of the test directory must be listed in the settings file or match the wildcard pattern already present there.

