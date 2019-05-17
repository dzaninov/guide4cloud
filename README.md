# cloud

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
