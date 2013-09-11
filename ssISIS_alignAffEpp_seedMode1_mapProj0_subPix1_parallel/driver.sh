#PBS -S /bin/bash
#PBS -N cfd

# This example uses the Harpertown nodes
# User job can access ~7.6 GB of memory per Harpertown node.
# A memory intensive job that needs more than ~0.9 GB
# per process should use less than 8 cores per node
# to allow more memory per MPI process. This example
# asks for 64 nodes and 4 MPI processes per node.
# This request implies 64x4 = 256 MPI processes for the job.
##PBS -l select=64:ncpus=8:mpiprocs=4:model=har
#PBS -l select=2:ncpus=8
#PBS -l walltime=0:05:00
#PBS -j oe
#PBS -W group_list=s1219
#PBS -m e

n=160mpp
echo Job is $n >2 # let it go to stderr so that we can see it in the job report file
echo Job is $n

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi

. isis_setup.sh

rm -rfv run

parallel_stereo --nodes-list "$PBS_NODEFILE" --processes 2 --threads-multiprocess 8 --job-size-w 1024 --job-size-h 1024 ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 1 --entry-point 0 --stop-point 7 --debug > output_p2.txt 2>&1


