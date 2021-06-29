#!/bin/tcsh

foreach dir (` ls -1d gefs.*`)

    set date=`echo $dir | awk '{print substr ( $1,6,8 )}'`
    echo mkdir -p $dir/00/atmos/cfssst
    mkdir -p $dir/00/atmos/cfssst
    echo cp /gpfs/dell2/emc/modeling/noscrub/Alexei.A.Belochitski/gefs12ics/2tsst/TMPsfc.${date}00.24hr.anom.grb $dir/00/atmos/cfssst
    cp /gpfs/dell2/emc/modeling/noscrub/Alexei.A.Belochitski/gefs12ics/2tsst/TMPsfc.${date}00.24hr.anom.grb $dir/00/atmos/cfssst

end
