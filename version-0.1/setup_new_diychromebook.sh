# work in progress, use at your own risk
# assumes that the LXLE distro is being used
apt-get update
apt-get -y install aptitude
aptitude -y --full-resolver safe-upgrade
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java7-installer
apt-get -y install mc mutt git git-doc
apt-get -y install lubuntu-restricted-extras
apt-get -y remove zeitgeist
apt-get -y remove deja-dup catfish keepass* parcellite fehlstart typhoon xpad
apt-get -y remove anki marble-qt aisleriot biniax2 chromium-bsu primrose solarwolf swell-foop numptyphysics pipewalker
apt-get -y remove teeworlds dreamchess criticalmass flobopuyo gweled hex-a-hop hexalate lbreakout2 ltris mahjongg
apt-get -y remove gnome-hearts gnome-mastermind gnomine gnome-mahjongg gnome-mines
apt-get -y remove gimp mirage shotwell simple-image-reducer simple-scan totem
apt-get -y remove firefox btsync* claws-mail* filezilla* gitso linphone pidgin steam-launcher transmission* uget x11vnc xchat
apt-get -y remove arista audacity guayadeque* guvcview minitube openshot* pithos vokoscreen
apt-get -y remove fbreader osmo xfburn homebank libreoffice* gnome-dictionary
apt-get -y remove flashplugin-installer
apt-get -y install flashplugin-installer
apt-get -y autoremove
apt-get clean
