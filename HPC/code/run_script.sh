#!/bin/bash

#PBS -l walltime=12:00:00

#PBS -l select=1:ncpus=1:mem=1gb

module load anaconda3/personal

echo "R is about to run"

cp $HOME/run_files/ts920_HPC_2023_main.R $TMPDIR

R --vanilla < $HOME/run_files/ts920_HPC_2022_neutral_cluster.R

mv cluster_output* $HOME/output_files/

echo "R has finished running"