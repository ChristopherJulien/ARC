#! /bin/bash
home=`realpath "$(dirname "$0")"`
cd $home && sudo singularity build --sandbox leggedgym.sif leggedgym.def
