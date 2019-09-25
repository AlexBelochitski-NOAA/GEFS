#!/bin/bash
###############################################################################
#                                                                             #
# This script concatenates  GRIB2 file for the MWW3 forecast model            #
# It is run as a child scipt interactively by the postprocessor.              #
#                                                                             #
# Remarks :                                                                   #
# - The necessary files are retrieved by the mother script.                   #
# - This script generates it own sub-directory 'grib_*'.                      # 
# - See section 0.b for variables that need to be set.                        # 
#                                                                             #
#                                                                July, 2007   #
# Last update : 05-05-2019                                                    #
#                                                                             #
###############################################################################

#
# ... Define directories
#
#
# --------------------------------------------------------------------------- #
# 0.  Preparations
# 0.a Basic modes of operation

  # set execution trace prompt.  ${0##*/} adds the script's basename
  PS4=" \${SECONDS} ${0##*/} L\${LINENO} + "
  set -x

  # Use LOUD variable to turn on/off trace.  Defaults to YES (on).
  export LOUD=${LOUD:-YES}; [[ $LOUD = yes ]] && export LOUD=YES
  [[ "$LOUD" != YES ]] && set +x

  cd $DATA
#  postmsg "$jlogfile" "Catting GRIB2 Files."   # commented to reduce unnecessary output to jlogfile

  grdID=$1  
  rm -rf grib_$grdID
  mkdir grib_$grdID
  err=$?
  if [ "$err" != '0' ]
  then
    set +x
    echo ' '
    echo '******************************************************************************* '
    echo '*** FATAL ERROR : ERROR IN multiwavegrib2_cat (COULD NOT CREATE TEMP DIRECTORY) *** '
    echo '******************************************************************************* '
    echo ' '
    [[ "$LOUD" = YES ]] && set -x
    postmsg "$jlogfile" "FATAL ERROR : ERROR IN multiwavegrib2_cat (Could not create temp directory)"
    exit 1
  fi

  cd grib_$grdID

# 0.b Define directories and the search path.
#     The tested variables should be exported by the postprocessor script.

  dtgrib=$2
  ngrib=$3
  GRIDNR=$4
  MODNR=$5
  gribflags=$6

  set +x
  echo ' '
  echo '+--------------------------------+'
  echo '!         Make GRIB files        |'
  echo '+--------------------------------+'
  echo "   Model ID         : $wavemodTAG"
  [[ "$LOUD" = YES ]] && set -x

  if [ -z "$YMDH" ] || [ -z "$cycle" ] || [ -z "$EXECwave" ] || [ -z "$EXECcode" ] || \
     [ -z "$COMOUT" ] || [ -z "$wavemodTAG" ] || [ -z "$SENDCOM" ] || \
     [ -z "$SENDDBN" ]
  then
    set +x
    echo ' '
    echo '***************************************************'
    echo '*** EXPORTED VARIABLES IN postprocessor NOT SET ***'
    echo '***************************************************'
    echo ' '
    [[ "$LOUD" = YES ]] && set -x
    postmsg "$jlogfile" "EXPORTED VARIABLES IN postprocessor NOT SET"
    exit 1
  fi

# 0.c Starting time for output

  ymdh=$YMDH
  tstart="`echo $ymdh | cut -c1-8` `echo $ymdh | cut -c9-10`0000"

  set +x
  echo "   Starting time    : $tstart"
  echo ' '
  [[ "$LOUD" = YES ]] && set -x

# 0.d sync important files

# 0.e Links to working directory

# --------------------------------------------------------------------------- #
# 1.  Generate GRIB file with all data

# 1.b Run GRIB packing program


  set +x
  echo "   Catting grib2 files ${COMOUT}/gridded/$wavemodTAG.$grdID.$cycle.f???.grib2"
  [[ "$LOUD" = YES ]] && set -x

  ln -sf ../$wavemodTAG.$grdID.$cycle.grib2 gribfile
  cat ${COMOUT}/gridded/$wavemodTAG.$grdID.$cycle.f???.grib2 >> gribfile
  err=$?

  if [ "$err" != '0' ]
  then
    set +x
    echo ' '
    echo '************************************************* '
    echo '*** FATAL ERROR : ERROR IN multiwavegrib2_cat *** '
    echo '************************************************* '
    echo ' '
    [[ "$LOUD" = YES ]] && set -x
    postmsg "$jlogfile" "FATAL ERROR : ERROR IN multiwavegrib2_cat"
    exit 3
  fi

# 1.e Save in /com

  if [ "$SENDCOM" = 'YES' ]
  then
    set +x
    echo "   Saving GRIB file as $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2"
    [[ "$LOUD" = YES ]] && set -x
    cp gribfile $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2
    
    if [ ! -f $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2 ]
    then
      set +x
      echo ' '
      echo '********************************************* '
      echo '*** FATAL ERROR : ERROR IN multiwavegrib2 *** '
      echo '********************************************* '
      echo ' '
      echo " Error in moving grib file $wavemodTAG.$grdID.$cycle.grib2 to com"
      echo ' '
      [[ "$LOUD" = YES ]] && set -x
      postmsg "$jlogfile" "FATAL ERROR : ERROR IN multiwavegrib2"
      exit 4
    fi

    echo "   Creating wgrib index of $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2"
    $WGRIB2 -s $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2 > $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2.idx

    if [ "$SENDDBN" = 'YES' ]
    then
      set +x
      echo "   Alerting GRIB file as $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2"
      echo "   Alerting GRIB index file as $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2.idx"
      [[ "$LOUD" = YES ]] && set -x
      $DBNROOT/bin/dbn_alert MODEL WAVE_GRIB_GB2 $job $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2
      $DBNROOT/bin/dbn_alert MODEL WAVE_GRIB_GB2_WIDX $job $COMOUT/gridded/$wavemodTAG.$grdID.$cycle.grib2.idx
    fi
  fi 

 
# --------------------------------------------------------------------------- #
# 3.  Clean up the directory

  set +x
  echo "   Removing work directory after success."
  [[ "$LOUD" = YES ]] && set -x

  cd ..
  mv -f grib_$grdID done.grib_$grdID 

  set +x
  echo ' '
  echo "End of multiwavegrib2_cat.sh at"
  date
  [[ "$LOUD" = YES ]] && set -x

# End of multiwavegrib2.sh -------------------------------------------------- #
