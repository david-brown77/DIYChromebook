# do updates without "looking" & cleanup afterwards
# quick link to master copy = http://goo.gl/V8GjhV
apt-get update
aptitude -y --full-resolver safe-upgrade
apt-get -y autoremove
apt-get clean
