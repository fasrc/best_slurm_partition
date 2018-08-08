#!/bin/bash

#SBATCH -J TensorFlow
#SBATCH -p serial_requeue # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 8000 # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH --export=ALL
#SBATCH -o Job.%N.%j.out # STDOUT
#SBATCH -e Job.%N.%j.err # STDERR

module load Anaconda3/5.0.1-fasrc01

python -c "import datetime; print(\"Date and time is: \" + str(datetime.datetime.now()))"
