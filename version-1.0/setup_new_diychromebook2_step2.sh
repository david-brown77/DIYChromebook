# work in progress, use at your own risk
# assumptions:
#   1.  to be used on Dell D620's & Dell D820's
#   2.  assumes its being run as root
#   3.  assumes that the ubuntu-server distro is being used
#   4.  this script is run AFTER the additional manual steps are done after the first script
#
# remove non essential directories, change Desktop so can't write to it
#chown root:root /home/googleuser/Desktop
#chmod go-rwx /home/googleuser/Desktop
rm -Rv /home/googleuser/Desktop
ln -s /home/googleuser/Downloads /home/googleuser/Desktop
rm -Rv /home/googleuser/Documents
rm -Rv /home/googleuser/Music
rm -Rv /home/googleuser/Pictures
rm -Rv /home/googleuser/Public
rm -Rv /home/googleuser/Templates
rm -Rv /home/googleuser/Videos
#
# not doing this with simpler method
# create the default template directory to be used for Google Chrome profile
#cp -ar /home/googleuser/.config/google-chrome /home/googleuser/.config/google-chrome-template
#chown -R root:root /home/googleuser/.config/google-chrome-template
#
# get & setup script for cleanup of googleuser Google Chrome profile
cd /home/System/scripts/
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/googleuser_cleanup.sh
chmod a+x /home/System/scripts/googleuser_cleanup.sh
mkdir -p /home/googleuser/.googleuser-aging/logs
#
# setup cleanup googleuser user  logout
echo "" >> /usr/share/lightdm/lightdm.conf.d/50-user-session.conf
echo "#added by DIYChromebook (v2) script" >> /usr/share/lightdm/lightdm.conf.d/50-user-session.conf
echo "session-cleanup-script = /home/System/scripts/googleuser_cleanup.sh" >> /usr/share/lightdm/lightdm.conf.d/50-user-session.conf
echo "session-setup-script = /home/System/scripts/googleuser_cleanup.sh" >> /usr/share/lightdm/lightdm.conf.d/50-user-session.conf
echo "" >> /etc/lightdm/lightdm-gtk-greeter.conf
echo "#added by DIYChromebook (v2) script" >> /etc/lightdm/lightdm-gtk-greeter.conf
echo "session-cleanup-script = /home/System/scripts/googleuser_cleanup.sh" >> /etc/lightdm/lightdm-gtk-greeter.conf
echo "session-setup-script = /home/System/scripts/googleuser_cleanup.sh" >> /etc/lightdm/lightdm-gtk-greeter.conf
#
# set googleuser_cleanup.sh be run at startup, in case hard power down.
echo "#! /bin/bash" >> /etc/init.d/googleuser_cleanup
echo "/home/System/scripts/googleuser_cleanup.sh" >> /etc/init.d/googleuser_cleanup
chmod ugo+x /etc/init.d/googleuser_cleanup
update-rc.d googleuser_cleanup defaults
#
# now set Google Chrome browser to automatically start at login for googleuser user
mkdir -p /home/googleuser/.config/lxsession/Lubuntu
chown googleuser:googleuser /home/googleuser/.config/lxsession
chown googleuser:googleuser /home/googleuser/.config/lxsession/Lubuntu
echo "/usr/bin/chromium-browser" >> /home/googleuser/.config/lxsession/Lubuntu/autostart
#
