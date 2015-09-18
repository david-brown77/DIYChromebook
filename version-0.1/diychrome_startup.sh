#! /bin/bash
#################################################################################################
#
# Script Name:    diychrome_startup.sh
# Script Usage:   This script acts as a init.d script for making a DoItYourself style chrome
#                 device.  Assumptions are that this a regular type linux installation, and
#                 that it is sane to copy a user called googletemplate to googleuser.
#
#                 Init actions are:
#                   start)
#                     - current googleuser folder is backed up and then googletemplate folder
#                       is copied
#                   stop)
#                     - all backups of googleuser folder older then 30 days is deleted as well
#                       check for enough free disk space & remove additional backups as necessary
#                   restart)
#                     - combines both start & stop functions
#                   force-reload)
#                     - combines both start & stop functions
#                   reload)
#                     - combines both start & stop functions
#                   status)
#                     - says status is not truely support because nothing to support
#                   *)
#                     - missing or incorrect parameter
#
#                  Optional ideas:
#                    Have this script run when user logs out of device (/etc/X11/Xreset)?
#                    Have this script run on cron with stop parameter.
#
#                  All parameters after the first are ignored.
#
# Script Updates:
#     201407141130 - rdegennaro@sscps.org - First added boilerplate stuff.
#     201407161547 - rdegennaro@sscps.org - Added nicer header comments.
#     201407161557 - rdegennaro@sscps.org - Cleanup comments, work on rename & copy
#     201407311527 - rdegennaro@sscps.org - Combined two other scripts to make this one
#
#################################################################################################

# Setup variables changed for script
vScriptName="diychrome_startup.sh"
vDesiredFreeSpace="10"

# Setup Date/Time variables.  Probably won't have to change.
vDateTimeYear=`date +%Y`
vDateTimeMonth=`date +%m`
vDateTimeDay=`date +%d`
vDateTimeHour=`date +%H`
vDateTimeMin=`date +%M`
vDateTimeSec=`date +%S`
vDateTimeYYYYMMDDHHMMSS=$vDateTimeYear$vDateTimeMonth$vDateTimeDay$vDateTimeHour$vDateTimeMin$vDateTimeSec
# Finish building log variables
vLogPath="/var/log/$vScriptName"
vLogFileOutput="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
vLogFileOutputFullPath="$vLogPath""/""$vLogFileOutput"
vLogFileError="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
vLogFileErrorFullPath="$vLogPath""/""$vLogFileError"

# Now do some initial setup
mkdir -p "$vLogPath"

# Function for swapping around google user directories
function fSetupHomeDir () {
  vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Start swapping of Google user directories."
  echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
  mv /home/googleuser /home/googleuser-aging-"$vDateTimeYYYYMMDDHHMMSS"
  cp -ar /home/googletemplate /home/googleuser
  chown -R googleuser:googleuser /home/googleuser
  vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Finished swapping of Google user directories."
  echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
}

function fClearAgedDirs () {
  # find free space
  vCurrentFreeSpace=`df -h | grep /dev/sda2 | grep -oe "[0-9]*\.\?[0-9]*G\s*[0-9]*%" | grep -oe "[0-9]*\.\?[0-9]*G"`
  vCurrentFreeSpace="${vCurrentFreeSpace%?}"

  # delete GoogleUser directories older then 30 days, super paranoid folks might want to comment out
  vDateInPastYear=`date +%Y --date="-30 day"`
  vDateInPastMonth=`date +%m --date="-30 day"`
  vDateInPastDay=`date +%d --date="-30 day"`
  vDateInPast="$vDateInPastYear""$vDateInPastMonth""$vDateInPastDay"
  find /home/googleuser-aging-* -maxdepth 0 -type d ! -newermt "$vDateInPast" | xargs -0 rm
  vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Removing GoogleUser directories older then 30 days."
  echo "$vNowMessage"
  echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

  # delete GoogleUser-aging directories until enough free space or there aren't any to do.
  if [ `echo "$vDesiredFreeSpace $vCurrentFreeSpace" | awk '{print ($1 > $2)}'` -eq 1 ];
    # not enough free space, so do stuff
    then
      vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - ""$vCurrentFreeSpace"" is less then ""$vDesiredFreeSpace"" so removing old GoogleUser directory."
      echo "$vNowMessage"
      echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

      #Need to add check for existing GoogleUser directory
      while [ `echo "$vDesiredFreeSpace $vCurrentFreeSpace" | awk '{print ($1 > $2)}'` -eq 1 ] && (ls /home/googleuser-aging-* &> /dev/null) 
        do
          # find, log & remove oldest GoogleUser directory
          vCurrentDirToRemove=`ls -ltdh /home/googleuser-aging-* | tail -1 | tr " " "\n" | tail -1`
          vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Removing the directory: ""$vCurrentDirToRemove""."
          echo "$vNowMessage"
          echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
          rm -R "$vCurrentDirToRemove"

          # update Current Space
          vCurrentFreeSpace=`df -h | grep /dev/sda2 | grep -oe "[0-9]*\.\?[0-9]*G\s*[0-9]*%" | grep -oe "[0-9]*\.\?[0-9]*G"`
          vCurrentFreeSpace="${vCurrentFreeSpace%?}"
          vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Free space is now ""$vCurrentFreeSpace""."
          echo "$vNowMessage"
          echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
      done
      # check to see if not enough free space & no GoogleUser directory, log warning
      if [ `echo "$vDesiredFreeSpace $vCurrentFreeSpace" | awk '{print ($1 < $2)}'` ] && ! (ls /home/googleuser-aging-* &> /dev/null) ;
        then
          vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - WARNING!!! ""$vCurrentFreeSpace"" is less then ""$vDesiredFreeSpace"" of desired free space and no old GoogleUser directory to delete."
          echo "$vNowMessage"
          echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
      fi

    # enough free space, so just log that it was checked
    else
      vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Nothing to process, free space is ""$vCurrentFreeSpace"" and desired free space is ""$vDesiredFreeSpace""."
      echo "$vNowMessage"
      echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
  fi
}

#write start of process
vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Start of processing."
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# process functions above in an init.d style
case "$1" in
  start)
    fSetupHomeDir
    ;;
  stop)
    fClearAgedDirs
    ;;
  restart|force-reload|reload)
    fClearAgedDirs
    fSetupHomeDir
    ;;
  status)
    echo "0"
    vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Not a service, so no status to report."
    echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    ;;
  *)
    echo "Missing or incorrect parameter."
    vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Missing or incorrect parameter."
    echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    ;;
esac

#write end of process
vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - End of processing."
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# cleanup older log files until do rolling log file by removing anything older 30 days
vDateInPastYear=`date +%Y --date="-30 day"`
vDateInPastMonth=`date +%m --date="-30 day"`
vDateInPastDay=`date +%d --date="-30 day"`
vDateInPast="$vDateInPastYear""$vDateInPastMonth""$vDateInPastDay"
find "$vLogPath" ! -newermt "$vDateInPast" -type f -print0 | xargs -0 rm
