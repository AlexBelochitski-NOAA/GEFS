#!/usr/bin/bash

 export STMP=/gpfs/dell2/stmp 
 export basedir=/gpfs/dell6/emc/modeling/noscrub/Alexei.A.Belochitski/
 export tmpdir=$STMP/$LOGNAME/filter 

 set +m

 module load NCO/4.7.0
 cd /gpfs/dell6/ptmp/Alexei.A.Belochitski/o/gefs-nnrad/com/gefs/dev/
 pwd
 mkdir -p training_set

# for DATE in 2017082300; do
 for DATE in 2017082300 2017122200 2018010100 2018011500 2018020100 2018021800 2018022800 2018031900 2018040800 2018042000 2018050100 2018052000 2018060500 2018062000 2018070500 2018072000 2018080300 2018081600 2018091700 2018092700 2018100600 2018102000 2018110200 2018111500 2018120100 2019040900 2019102600; do

     pdy=`echo  $DATE | cut -c 1-8 `
#     pushd gefs.$pdy/00/atmos/sfcsig/


# echo htar cqf /NCEPDEV/emc-global/2year/Alexei.A.Belochitski/GEFS_Radiation/raw_model_output_for_training_data/27Jun2021/gefs.${pdy}.tar  gefs.$pdy
# htar cqf /NCEPDEV/emc-global/2year/Alexei.A.Belochitski/GEFS_Radiation/raw_model_output_for_training_data/27Jun2021/gefs.${pdy}.tar  gefs.$pdy &

     for member in  "gec00" "gep01"; do

	 echo 
	 echo Concatenating along time dimenstion for ${pdy}, ${member}
	 ncrcat -h -O gefs.$pdy/00/atmos/sfcsig/${member}.t00z.sfcf???.subset.nc training_set/${member}.${pdy}.t00z.nc

     done #member

 done  #date
