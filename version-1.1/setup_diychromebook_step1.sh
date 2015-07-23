#!/bin/bash

# ToDo / Remember
# make /etc/opt/chrome/policies/managed
# make /etc/opt/chrome/policies/recommended
# download default_policy.json to /etc/opt/chrome/policies/managed

# work in progress, use at your own risk
# assumptions:
#   1.  to be used on Dell D620's & Dell D820's
#   2.  assumes its being run as root
#   3.  assumes that the ubuntu-server distro is being used
# if you are behind a webfilter and need weblogin, try w3m
# quick link to master copy = http://goo.gl/eAgFfn
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
apt-get -y remove kpat ktorrent akregator kopete quassel firefox 
apt-get -y install git git-doc mc mutt
apt-get -y install ubuntu-wallpapers kde-wallpapers kde-wallpapers-default kdewallpapers peace-wallpapers tropic-wallpapers xubuntu-wallpapers
apt-get -y install kscreensaver screensaver-default-images
apt-get -y install kubuntu-restricted-extras
