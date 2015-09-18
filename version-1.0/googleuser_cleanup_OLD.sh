#! /bin/bash
#################################################################################################
#
# Script Name:    googluser_cleanup.sh
# Script Usage:   This script is designed to clean out backed up directories create by
#                 diychrome_login.sh.  It is another piece for making a DoItYourself style chrome
#                 device.  Assumptions are:
#                   1.  This a regular type linux installation using LXDE.
#                   2.  Script is owned by root so users can't change.
#                   3.  Backup & clearing of ~/.config/google-chrome & ~/Downloads is a good idea.
#                   4.  Removing all backups older then 30 days is a good idea.
#                   5.  Removing all backups so free space is over vDesiredFreeSpace is a good
#                       idea.
#
#
# Script Updates:
#     201407141130 - rdegennaro@sscps.org - First added boilerplate stuff.
#     201407161547 - rdegennaro@sscps.org - Added nicer header comments.
#     201407161557 - rdegennaro@sscps.org - Cleanup comments, work on rename & copy
#     201407311527 - rdegennaro@sscps.org - Combined two other scripts to make this one
#     201409181555 - rdegennaro@sscps.org - Converted from old rc idea to this one
#     201503031701 - rdegennaro@sscps.org - Converted two old diychromebook scripts to this
#
#################################################################################################

# Setup variables changed for script
vScriptName="googluser_cleanup.sh"
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
#vLogPath="/var/log/$vScriptName"
vLogPath="/home/googleuser/.googleuser-aging/logs"
vLogFileOutput="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
vLogFileOutputFullPath="$vLogPath""/""$vLogFileOutput"
vLogFileError="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
vLogFileErrorFullPath="$vLogPath""/""$vLogFileError"

# Now do some initial setup
mkdir -p "$vLogPath"

function fClearAgedDirs () {
  # find free space
  vCurrentFreeSpace=`df -h | grep /dev/sda2 | grep -oe "[0-9]*\.\?[0-9]*G\s*[0-9]*%" | grep -oe "[0-9]*\.\?[0-9]*G"`
  vCurrentFreeSpace="${vCurrentFreeSpace%?}"

  # delete GoogleUser directories older then 30 days, super paranoid folks might want to comment out
  vDateInPastYear=`date +%Y --date="-30 day"`
  vDateInPastMonth=`date +%m --date="-30 day"`
  vDateInPastDay=`date +%d --date="-30 day"`
  vDateInPast="$vDateInPastYear""$vDateInPastMonth""$vDateInPastDay"
  find /home/googleuser/.googleuser-aging/* -maxdepth 0 -type d ! -newermt "$vDateInPast" | xargs -0 rm
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
          vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - WARNING!!! ""$vCurrentFreeSpace"" is less then ""$vDesiredFreeSpace"" of desired free space."
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

# Function for backup of certain googleuser directories
function fBackupHomeSubDirs () {
  vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Start backup of Google user sub directories."
  echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
  mkdir -p /home/googleuser/.googleuser-aging/"$vDateTimeYYYYMMDDHHMMSS"
  mv /home/googleuser/Downloads /home/googleuser/.googleuser-aging/"$vDateTimeYYYYMMDDHHMMSS"/
  mv /home/googleuser/.config/google-chrome /home/googleuser/.googleuser-aging/"$vDateTimeYYYYMMDDHHMMSS"/
  cp /home/googleuser/.local/share/Trash /home/googleuser/.googleuser-aging/"$vDateTimeYYYYMMDDHHMMSS"/
  rm -R /home/googleuser/.local/share/Trash/expunged/*
  rm -R /home/googleuser/.local/share/Trash/files/*
  rm -R /home/googleuser/.local/share/Trash/info/*
  cp -ar /home/googleuser/.config/google-chrome-template /home/googleuser/.config/google-chrome
  chown -R googleuser:googleuser /home/googleuser/.config/google-chrome
  vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Finish backup of Google user directories."
  echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
}

#write start of process
vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Start of processing."
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

#first make sure enough free space, then cleanup Google Chrome directory
fClearAgedDirs
fBackupHomeSubDirs

#write end of process
vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - End of processing."
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# cleanup older log files until do rolling log file by removing anything older 30 days
vDateInPastYear=`date +%Y --date="-30 day"`
vDateInPastMonth=`date +%m --date="-30 day"`
vDateInPastDay=`date +%d --date="-30 day"`
vDateInPast="$vDateInPastYear""$vDateInPastMonth""$vDateInPastDay"
find "$vLogPath" ! -newermt "$vDateInPast" -type f -print0 | xargs -0 rm
