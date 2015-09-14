# Introduction

# Update

1. Log into system as "sscpslocal"
2. In LX Terminal, sudo to root.
3. Type "/home/System/scripts/update_bruteforce.sh"

# Install/Initial Setup  [NOT DONE]
[[This process is being "tweaked" & formatted.]]

1. Install Ubuntu Server from USB & reboot.  
  * (only if non-Server 14.04+ ) For D620/D820, use "xforcevesa" when booting.
  * Setup partitions as:
    * /dev/sda1 = swap (4GB)
    * /dev/sda2 = / (10GB, format ext3, label root)
  * computer name = D620-DIYCHROME or D820-DIYCHROME (which ever is appropriate)
  * UID/PWD = sscpslocal/<usual local admin pwd>
2. Do base installation:
  1. login as sscpslocal & sudo to root.
  2. Type in following commands:
    1. mkdir -p /home/System/scripts
    2. cd /home/System/scripts
    3. wget http://goo.gl/eAgFfn
    4. mv TKB3Bg setup_new_diychromebook2.sh
    5. chmod a+x *.sh
    6. Edit setup_new_diychromebook2_step1.sh and change the default password for "googleuser" to something appropriate.
    7. /home/System/scripts/setup_new_diychromebook2_step1.sh
  3. Look for questions as the script can't assume "yes" on some questions.
  4. Reboot
3. Check to make sure automatically logged in as "Google User".
4. Start Chromium and check "Automatically send usage statistics and crash reports to Google".
5. DO NOT sign into Chromium.
6. Maximize the Chromium window.
7. (DEPRACTED in current version of Chromium) Enabled web-based Google Chrome login:
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
11. Run second stage of commands:
  1. With PCManFM still open.
  2. Tools -> "Open Current Folder in Terminal".
  3. In terminal window, type "su sscpslocal".
  4. In terminal window, type "sudo -s".
  5. /home/System/scripts/setup_new_diychromebook2_step2.sh
12. Fix up new windows:
  1. nano -w /home/googleuser/.config/openbox/lubuntu-rc.xml
  2. uncomment node at bottom that is <maximized>, include <application type="normal">
13. Logout & remove network cable.  
14. Login as sscpslocal & connect to WiFi SSIDs.  Be sure they are set as "System".
15. Goto https://localhost:10000, login as sscpslocal & refresh modules (webmin should be up to date from apt-get).
16. Reboot & check that it all works (HINT, Google Chrome's history should be empty).
