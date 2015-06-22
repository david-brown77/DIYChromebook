#! /bin/bash
#################################################################################################
#
# Script Name:    diychrome_login.sh
# Script Usage:   This script is designed to run when a user is auto-logged in.  It is for making
#                 a DoItYourself style chrome device.  Assumptions are:
#                   1.  This a regular type linux installation using LXDE.
#                   2.  Script is owned by root so users can't change.
#                   3.  Backup & clearing of Chrome config, ~/Downloads & Trash is a good idea.
#                   4.  All other non-hidden directories in ~ can be marked read-only.
#
#
# Script Updates:
#     201407141130 - rdegennaro@sscps.org - First added boilerplate stuff.
#     201407161547 - rdegennaro@sscps.org - Added nicer header comments.
#     201407161557 - rdegennaro@sscps.org - Cleanup comments, work on rename & copy
#     201407311527 - rdegennaro@sscps.org - Combined two other scripts to make this one
#     201409181555 - rdegennaro@sscps.org - Converted from old rc idea to this one
#
#################################################################################################

# Setup variables changed for script
vScriptName="diychrome_login.sh"
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
  mkdir -p /home/googleuser/Downloads
  cp -ar /home/googleuser/.config/google-chrome-template /home/googleuser/.config/google-chrome
  vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Finish backup of Google user directories."
  echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
}

#write start of process
vNowMessage=`date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`" - Start of processing."
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

#call functions to do things
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
