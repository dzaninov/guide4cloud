# Personal Cloud

## OS Setup
t3.nano with Ubuntu 18.04
```
sudo bash
ufw allow 22/tcp
ufw enable
ufw logging off     # use logging only for debugging

apt update
apt dist-upgrade    # keep local

dpkg-reconfigure tzdata

echo us > /etc/hostname

cat <<EOT > /etc/hosts
127.0.0.1       localhost
10.100.100.100  us.example.com us
EOT

reboot
```

## Add swap
```
dd if=/dev/zero of=/swap bs=1M count=1024
mkswap /swap
chmod 600 /swap
swapon /swap

vi /etc/fstab
---------------------------------------------------
/swap  swap  swap  defaults  0 0
---------------------------------------------------
```

## Stop journald from storing logs in memory
```
vi /etc/systemd/journald.conf
---------------------------------------------------
Storage=none
---------------------------------------------------
service systemd-journald restart
```

## Remove amazon-ssm-agent and snapd
```
snap remove amazon-ssm-agent
apt remove snapd
find /etc/systemd -name '*snapd*' -exec rm {} \;
rm -rf /var/lib/snapd
reboot
```

## Install nice to have software
```
apt install apt-file jq mailutils nmap petit traceroute
apt-file update
```

## Remove and disable what you don't need
```
apt remove popularity-contest
systemctl disable lvm2-monitor.service
systemctl disable lvm2-lvmetad.socket
systemctl disable lvm2-lvmpolld.socket
systemctl disable iscsid.socket
```
