#!/bin/ksh

# EXPORT list here
set -x
export IOBUF_PARAMS=
export FORT_BUFFERED=TRUE
export MKL_CBWR=AVX
ulimit -s unlimited
ulimit -a

export ATP_ENABLED=0
export MALLOC_MMAP_MAX_=0
export MALLOC_TRIM_THRESHOLD_=134217728

export MPICH_ABORT_ON_ERROR=1
export MPICH_ENV_DISPLAY=1
export MPICH_VERSION_DISPLAY=1
export MPICH_CPUMASK_DISPLAY=1

export KMP_STACKSIZE=1024m
export KMP_AFFINITY=disabled
export OMP_NUM_THREADS=6

export MP_EUIDEVICE=sn_all
export MP_EUILIB=us
export MP_SHARED_MEMORY=no
export MEMORY_AFFINITY=core:6

export MP_TASK_AFFINITY=cpu:6
export MP_USE_BULK_XFER=yes
export MP_STDOUTMODE=unordered
export MPICH_ALLTOALL_THROTTLE=0
export MP_COREFILE_FORMAT=core.txt
export OMP_STACKSIZE=3G
export MP_COMPILER=intel

export NODES=10
export total_tasks=22
export OMP_NUM_THREADS=6
export taskspernode=4

export envir=${envir:-dev}
export RUN_ENVIR=${RUN_ENVIR:-dev}
export gefsmpexec_mpmd="mpirun -np $total_tasks /scratch3/NCEPDEV/nwprod/util/exec/mpiserial"
export aprun_gec00="mpirun -np 1"
export APRUNC="mpirun -np 1"

# CALL executable job script here
$SOURCEDIR/jobs/JGEFS_INIT_SEPARATE

