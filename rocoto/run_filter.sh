#!/usr/bin/bash

 export STMP=/gpfs/dell2/stmp 
 export ACCOUNT=GFS-DEV  
 export CUE2RUN=dev    
 export cputime=6:00
 export basedir=/gpfs/dell6/emc/modeling/noscrub/Alexei.A.Belochitski/gefs-nnrad/rocoto
 export tmpdir=$STMP/$LOGNAME/filter 

 set +m

 FRMIN=0
 FRMAX=240
 CHUNK=30

# FRMAX=24
# FRMAX=6
# CHUNK=6

 mkdir -p $tmpdir

# for DATE in 20171222 20180101 20180115 20180201 20180218 20180228 20180319 20180408 20180420 20180501 20180520 20180605 20180620 20180705 20180720 20180803 20180816 20180917 20180927 20181006 20181020 20181102 20181115 20181201 20190409 20191026; do

#for DATE in 20170823; do
#for DATE in 20171222 20180101; do
#for DATE in 20180115 20180201 20180218 20180228 20180319; do
#for DATE in 20180408 20180420 20180501 20180520 20180605 20180620 20180705 20180720 20180803 20180816; do
for DATE in 20180917 20180927 20181006 20181020 20181102 20181115 20181201 20190409 20191026; do

    for MEM in  "gec00" "gep01"; do

	for ((FHR=3; FHR<=FRMAX; FHR+=$CHUNK)) ; do 

	    (( FHRm=$FHR+$CHUNK-3 ))
  
	    if [[ $FHR == 3 ]] ; then
		(( FHRl=0 ))
	    else
		(( FHRl=$FHR ))
	    fi

	    outfile="filter-${DATE}-${MEM}-${FHRl}-${FHRm}".out
	    jobname="filter-${DATE}-${MEM}-${FHRl}-${FHRm}"

	    cat <<EOF | bsub #$jobname.sub
#!/bin/bash
#BSUB -P $ACCOUNT
#BSUB -e $tmpdir/$outfile
#BSUB -o $tmpdir/$outfile
#BSUB -J $jobname
#BSUB -q $CUE2RUN
#BSUB -W $cputime

$basedir/filter.batch $MEM $FHRl $FHRm $DATE

EOF

	done #FHR

# echo 
# echo Concatenating along time dimenstion for ${member}
# ncrcat -h -O ${member}.t00z.sfcf???.subset.nc ${member}.t00z.subset.nc
# echo

    done  # member
 done #date
