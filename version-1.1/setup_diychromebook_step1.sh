#!/bin/bash
# short URL = https://goo.gl/LTQvgk, CHANGE:  be sure to update to correct repository & make new link

# ToDo / Remember
# check to see if code setting googleuser user to automatically login works with KDE
# disable akonadi & nepomuk
# set login screen background
# modify panel, maybe in step 2 (after create home directory?)
# find better way to add webmin repositoryy so that dups aren't added if run twice
# make /etc/opt/chrome/policies/recommended
# define recommended policies

# work in progress, use at your own risk
# assumptions:
#   1.  assumes its being run as root
#   2.  only tested from kubuntu 14.04 and ubuntu server 14.04 installs
#   3.  
# if you are behind a webfilter and need weblogin, try w3m
#
# setup temp directory for rest of script
mkdir -p /root/setup
#
# should do all updates first
apt-get update
apt-get -y install aptitude
aptitude -y --full-resolver safe-upgrade
#
# install DE & clean out unnecessary apps for DIYChromebook
apt-get -y install kubuntu-desktop #needed only if use ubuntu server (certain iMacs, older machines)
apt-get -y remove kpat k3b kaddressbook kmail kontact korganizer krdc knotes
apt-get -y remove marble
apt-get -y remove firefox libreoffice* skanlite amarok* dragonplayer
apt-get -y remove kde-telepathy ktorrent akregator kopete quassel samba-common smbclient
apt-get -y install ubuntu-wallpapers kde-wallpapers kde-wallpapers-default kdewallpapers peace-wallpapers tropic-wallpapers xubuntu-wallpapers
apt-get -y install kscreensaver screensaver-default-images
apt-get -y install kubuntu-restricted-extras
#
# fix network interfaces so network-manager can manage it
mv /etc/network/interfaces /etc/network/interfaces.orig
cd /etc/network/
# CHANGE:  be sure to update to correct repository
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.1/interfaces
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
apt-get update
apt-get -y install webmin git git-doc mc mutt unzip
apt-get -f -y install
# download script for "unattended" updating 
cd /home/System/scripts/
# CHANGE:  be sure to update to correct repository
wget https://github.com/rdegennaro/DIYChromebook/blob/master/version-1.1/update_bruteforce.sh
chmod a+x /home/System/scripts/update_bruteforce.sh
#
# boot splash  theme
# need to be after desktop because that installs its own
apt-get -y install plymouth-theme-edubuntu
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
update-alternatives --set default.plymouth /lib/plymouth/themes/edubuntu-logo/edubuntu-logo.plymouth
update-grub
update-initramfs -u
#
# get SSCPS wallpapers
mkdir -p /root/setup/wallpapers
cd /root/setup/wallpapers
wget https://github.com/SSCPS/desktop-wallpapers/raw/master/wallpapers/SSCPS-Flags.zip
unzip /root/setup/wallpapers/SSCPS-Flags.zip -d /root/setup/wallpapers/
wget https://github.com/SSCPS/desktop-wallpapers/raw/master/wallpapers/SSCPS-Folders.zip
unzip /root/setup/wallpapers/SSCPS-Folders.zip -d /root/setup/wallpapers/
wget https://github.com/SSCPS/desktop-wallpapers/raw/master/wallpapers/SSCPS-Smiles.zip
unzip /root/setup/wallpapers/SSCPS-Smiles.zip -d /root/setup/wallpapers/
wget https://github.com/SSCPS/desktop-wallpapers/raw/master/wallpapers/SSCPS-Violinist.zip
unzip /root/setup/wallpapers/SSCPS-Violinist.zip -d /root/setup/wallpapers/
rm /root/setup/wallpapers/SSCPS-*.zip
mv /root/setup/wallpapers/SSCPS-* /usr/share/wallpapers/
chown -R root:root /usr/share/wallpapers/SSCPS*
chmod -R a-rwx /usr/share/wallpapers/SSCPS*
chmod -R a+rX /usr/share/wallpapers/SSCPS*
chmod -R o+w /usr/share/wallpapers/SSCPS*
#
# install Google Chrome & download/install policy
cd /root/setup
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb
apt-get -f -y install
mkdir -p /etc/opt/chrome/policies/managed
cd /etc/opt/chrome/policies/managed/
# CHANGE:  be sure to update to correct repository
wget https://raw.githubusercontent.com/rdegennaro/DIYChromebook/master/version-1.1/default_policy.json
#
# clean up everything
apt-get -y autoremove
apt-get clean
#
# setup "googleuser" account for generic Google Chrome use
# add user & password
adduser --home /home/googleuser --shell /bin/bash --disabled-password --gecos "Google User" googleuser
echo 'googleuser:ChangeThisToTheCorrectPassword' | chpasswd
# TODO - check to see if below sets googleuser user to automatically login with KDE
echo "" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "#added by DIYChromebook (v2) script" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "autologin-user=googleuser" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
echo "greeter-session=lightdm-gtk-greeter" >> /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
