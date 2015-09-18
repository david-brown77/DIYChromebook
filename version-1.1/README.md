# Introduction
This set of file & scripts are designed to alter a generic Linux distro such
that it has features similar to a Chromebook.  The implementation has the
following limits/caveats
1. It only works (soon) with Lubuntu and Kubuntu.
2. It does not integrate with the Google Admin Console (device settings).
3. A single user account/profile is set to auto-login at boot/reboot.
4. That same account is (intended to be) reset at logout/reboot.
3. Please look at JSON file for specific policies "forced" for Google Chrome.
4. A separate user account is expected to administer the device.

This is intended to be used at a school.  The initial files have been moved from
generic update/manage project to this dedicated project.

All copyrights reserved beyond GPL v3.0.

# Status / Overview
1. Version 1.1 is currently being worked on. Right now, concentrating on Kubuntu.
2. Ephemeral profiles would be nice, but Chrome crashes alot with this setting especially with starting after clearing a profile.
3. ?

# ToDo / Remember
1. Finish with Chrome policies, including user vs. machine (differentiate between generic & dedicated machines).
2. Separate out settings for specific user from whole machine?
3. Check to see if code setting googleuser user to automatically login works with KDE.
4. Disable akonadi & nepomuk (with script).
5. Setup panel with script?
6. Set login screen background.
7. Get & store icon for Google Chrome Launcher, put in panel as well.
8. Find better way to add webmin repositoryy so that dups aren't added if run twice


# Update

1. Log into system as "sscpslocal"
2. In terminal (Konsole or LX Terminal), sudo to root.
3. Type "/home/System/scripts/update_bruteforce.sh"

# Install/Initial Setup  [NOT DONE]
[[This process is being "tweaked" & formatted.]]

1. Install Ubuntu Server from CD or USB & reboot.  
  * (only if non-Server 14.04+ ) For D620/D820, use "xforcevesa" when booting.
  * Setup partitions as:
    * /dev/sda1 = swap (4GB)
    * /dev/sda2 = / (8GB, format ext4, label root)
  * computer name = TEMPLATE-DIYCHROME-D820 or TEMPLATE-DIYCHROME-D820 (which ever is appropriate)
  * UID/PWD = sscpslocal/<usual local admin pwd>
2. Do base installation:
  1. login as sscpslocal & sudo to root.
  2. Type in following commands:
    1. cd /root
    2. https://goo.gl/LTQvgk
    3. mv LTQvgk setup_diychromebook_step1.sh
    4. chmod a+x *.sh
    6. Edit setup_diychromebook_step1.sh and change the default password for "googleuser" to something appropriate.
    7. /root/setup_new_diychromebook2_step1.sh
  3. Look for questions as the script can't assume "yes" on some questions.
  4. Reboot
3. ????

# Old Instructions
3. Check to make sure automatically logged in as "Google User".
4. Start Google Chrome and check "Automatically send usage statistics and crash reports to Google".
5. DO NOT sign into Google Chrome.
6. Maximize the Google Chrome window.
7. Enabled web-based Google Chrome login:
  1. Enter "chrome://flags" in address bar.
  2. Find & enable "Enable pure web-based sign-in flows".
  3. Restart Google Chrome if asked.
8. Goto "Settings":
  1. On startup -> "Open a specific page or set of pages."
  2. On startup -> "Open a specific page or set of pages." -> Set pages:
    1. http://sscps.org/google_redirect (this is redirect to local login, purpose is to get past filter authentication).
  3. Appearance -> check "Show Home button"
  4. Appearance -> "Show Home button" -> Change to http://sscps.org/
  5. Appearance -> check "Always show the bookmarks bar"
  6. People -> uncheck "Enable Guest browsing".
  7. People -> uncheck "Let anyone add a person to Chrome".
  8. People -> Edit "Default" or "Person 1" or whatever the profile is named and:
    1. Change name to "Google User".
    2. Select an icon that looks school-ish (soccer ball?).
  9. Clear browser history "from beginning of time." 
9. Close Google Chrome, but DO NOT log-out.
10. Open PcManFM, from bookmarks on side, remove all but Downloads
11. Create template Google Chrome profile:
  1. With PCManFM still open.
  2. Tools -> "Open Current Folder in Terminal".
  3. In terminal window, type "su sscpslocal".
  4. In terminal window, type "sudo -s".
  5. /home/System/scripts/setup_new_diychromebook2_step2.sh
12. Logout & remove network cable.  
13. Login as sscpslocal & connect to WiFi SSIDs.  Be sure they are set as "System".
14. Goto https://localhost:10000, login as sscpslocal & update webmin.
15. Reboot & check that it all works (HINT, Google Chrome's history should be empty).
