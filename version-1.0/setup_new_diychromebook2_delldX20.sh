# work in progress, use at your own risk
# assumptions:
#   1.  to be used on Dell D620's & Dell D820's
#   2.  assumes its being run as root
#   3.  assumes that the ubuntu-server distro is being used
# if you are behind a webfilter and need weblogin, try w3m
# quick link to master copy = https://goo.gl/cJXEWD
#
# setup temp directory for rest of script
mkdir -p /root/setup
mkdir -p /home/System/scripts
#
# should do all updates first
apt-get update
apt-get -y install aptitude
aptitude -y --full-resolver safe-upgrade
#
# install DE & clean out unnecessary apps for DIYChromebook
#apt-get -y install lubuntu-desktop menulibre lubuntu-restricted-extras lubuntu-icon-theme lubuntu-lxpanel-icons lubuntu-artwork-14-04 edubuntu-wallpapers
apt-get -y install lubuntu-desktop menulibre edubuntu-wallpapers
apt-get -y remove abiword audacious byobu cups evince evolution firefox galculator gnome-mplayer gnumeric guvcview
apt-get -y remove leafpad mplayer2 mtpaint nautilus
apt-get -y remove pidgin postfix samba-common smbclient simple-scan sylpheed transmission
apt-get -y remove unity-scope-scopes unity-scope-mediascanner2 unity-scope-click unity-plugin-scopes
apt-get -y remove ubuntuone-client-data ubuntuone-credentials-common ubuntu-purchase-service
apt-get -y remove vim vim.tiny vim-common wvdial xfburn xmms2 xpad xterm yelp zeitgeist
#
# release eth0 from server-based management, only after network-manager is installed
cd /root/setup
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/interfaces
mv /etc/network/interfaces /etc/network/interfaces.orig
cp /root/setup/interfaces /etc/network/interfaces
#
# install tools
# setup repository for webmin
echo "" >> /etc/apt/sources.list
echo "# repositories added for webmin installation/update" >> /etc/apt/sources.list
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
cd /root/setup
wget http://www.webmin.com/jcameron-key.asc
apt-key add /root/setup/jcameron-key.asc
# setup repository for java
add-apt-repository -y ppa:webupd8team/java
# update app lists & install
apt-get update
apt-get -y install mc mutt git git-doc oracle-java7-installer xmlstarlet webmin
apt-get -f -y install
# download script for "unattended" updating 
cd /home/System/scripts/
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/update_bruteforce.sh
chmod a+x /home/System/scripts/update_bruteforce.sh
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/setup_new_diychromebook2_step2.sh
chmod a+x /home/System/scripts/setup_new_diychromebook2_step2.sh
#
# setup login stuff (theme & sessions)
# change lightdm background
sed -i 's#background=/usr/share/backgrounds/warty-final-ubuntu.png#background=/usr/share/backgrounds/edubuntu_wire.png#g' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's#background=/usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png#background=/usr/share/backgrounds/edubuntu_wire.png#g' /etc/lightdm/lightdm-gtk-greeter.conf
# remove guest session
sh -c 'printf "[SeatDefaults]\nallow-guest=false\n" >/usr/share/lightdm/lightdm.conf.d/50-no-guest.conf'
sh -c 'printf "[SeatDefaults]\nuser-session=LXDE\n" >/usr/share/lightdm/lightdm.conf.d/50-user-session.conf'
# remove extra sessions
rm /usr/share/xsessions/openbox.desktop
rm /usr/share/xsessions/Lubuntu-Netbook.desktop
#
# setup default panel, theme, etc.
# set default panel via copying the skel directory
mkdir -p /etc/skel/.config/lxpanel/LXDE/panels/
mkdir -p /etc/skel/.config/lxpanel/default/panels/
mkdir -p /etc/skel/.config/lxpanel/Lubuntu/panels/
cd /etc/skel/.config/lxpanel/LXDE/panels/
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/panel
cd /etc/skel/.config/lxpanel/default/panels/
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/panel
cd /etc/skel/.config/lxpanel/Lubuntu/panels/
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/panel
# change default background - probably don't need the first two since copying default panel from github
sed -i 's#backgroundfile=/usr/share/lxpanel/images/background.png#backgroundfile=/usr/share/backgrounds/edubuntu-getexcited.jpg#g' /usr/share/lxpanel/profile/default/panels/panel
sed -i 's#backgroundfile=/usr/share/lxpanel/images/background.png#backgroundfile=/usr/share/backgrounds/edubuntu-getexcited.jpg#g' /usr/share/lxpanel/profile/LXDE/panels/panel
sed -i 's#backgroundfile=/usr/share/lxpanel/images/lubuntu-background.png#backgroundfile=/usr/share/backgrounds/edubuntu-getexcited.jpg#g' /usr/share/lxpanel/profile/Lubuntu/panels/panel
sed -i 's#/usr/share/lxde/wallpapers/lxde_blue.jpg#/usr/share/backgrounds/edubuntu-getexcited.jpg#g' /usr/share/lxde/pcmanfm/LXDE.conf
sed -i 's#wallpaper=/usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png#wallpaper=/usr/share/backgrounds/edubuntu-liquid-blue.jpg#g' /etc/xdg/pcmanfm/lubuntu/pcmanfm.conf
sed -i 's#wallpaper=/usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png#wallpaper=/usr/share/backgrounds/edubuntu-liquid-blue.jpg#g' /etc/xdg/pcmanfm/default/pcmanfm.conf
# change default icon theme, actually left over from when tried installing just LXDE
sed -i 's#sNet/IconThemeName=nuoveXT2#sNet/IconThemeName=lubuntu#g' /etc/xdg/lxsession/LXDE/desktop.conf
# change some openbox settings
sed -i 's#<number>2</number>#<number>1</number>#g' /usr/share/lxde/openbox/rc.xml
sed -i 's#<name>Onyx</name>#<name>Clearlooks</name>#g' /usr/share/lxde/openbox/rc.xml
sed -i 's#<number>2</number>#<number>1</number>#g' /usr/share/lubuntu/openbox/rc.xml
sed -i 's#<name>Lubuntu-default</name>#<name>Clearlooks</name>#g' /usr/share/lubuntu/openbox/rc.xml
#
# this stuff was to modify default panel, but doesn't work quite as I thought/want
# keeping because it doesn't hurt to modify them
# fix time in panel - probably not needed since copying default panel from github
sed -i 's/fontcolor=#ffffff/fontcolor=#000000/g' /usr/share/lxpanel/profile/default/panels/panel
sed -i 's/ClockFmt=%R/ClockFmt=%l:%M %p/g' /usr/share/lxpanel/profile/default/panels/panel
sed -i 's/fontcolor=#ffffff/fontcolor=#000000/g' /usr/share/lxpanel/profile/LXDE/panels/panel
sed -i 's/ClockFmt=%R/ClockFmt=%l:%M %p/g' /usr/share/lxpanel/profile/LXDE/panels/panel
sed -i 's/fontcolor=#ffffff/fontcolor=#000000/g' /usr/share/lxpanel/profile/Lubuntu/panels/panel
sed -i 's/ClockFmt=%R/ClockFmt=%l:%M %p/g' /usr/share/lxpanel/profile/Lubuntu/panels/panel
# change "start button" icon - probably not needed since copying default panel from github
sed -i 's#/usr/share/lxpanel/images/my-computer.png#/usr/share/icons/lubuntu/places/48/start-here.svg#g' /usr/share/lxpanel/profile/default/panels/panel
sed -i 's#/usr/share/lxpanel/images/my-computer.png#/usr/share/icons/lubuntu/places/48/start-here.svg#g' /usr/share/lxpanel/profile/LXDE/panels/panel
sed -i 's#/usr/share/lxpanel/images/my-computer.png#/usr/share/icons/lubuntu/places/48/start-here.svg#g' /usr/share/lxpanel/profile/Lubuntu/panels/panel
#
# boot splash  theme, need to be after lubuntu-desktop because that installs its own
# might require file edits before in /etc/default/grub, should check what lubuntu-desktop does to it
apt-get -y install plymouth-theme-edubuntu
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
update-alternatives --set default.plymouth /lib/plymouth/themes/edubuntu-logo/edubuntu-logo.plymouth
update-grub
update-initramfs -u
#
# install Google Chrome & download/install policy (policy part is BUSTED because of BUG in chrome)
#cd /root/setup
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#dpkg -i google-chrome*.deb
#apt-get -f -y install
#mkdir -p /etc/opt/chrome/policies/managed
#cd /etc/opt/chrome/policies/managed/
#wget https://raw.githubusercontent.com/SSCPS/TechTools-Linux/master/diychromebook2/device_policy.json
#
# install Chromium, flash & policies; not using Google Chrome because it freezes on some older laptops
apt-get -y install chromium-browser pepperflashplugin-nonfree
mkdir -p /etc/opt/chrome/policies/managed
cd /etc/opt/chrome/policies/managed/
# CHANGE:  be sure to update to correct repository
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.0/device_policy.json
#
# clean up everything
apt-get -y autoremove
apt-get clean
#
# setup "googleuser" account for generic Google Chrome use
# add user & password
adduser --home /home/googleuser --shell /bin/bash --disabled-password --gecos "Google User" googleuser
echo 'googleuser:ChangeThisToTheCorrectPassword' | chpasswd
# set googleuser user to automatically login
echo "" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "#added by DIYChromebook (v2) script" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "autologin-user=googleuser" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "greeter-session=lightdm-gtk-greeter" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
#
#another possible thing is to add chrome apps launcher to panel
