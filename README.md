# OpenWRT Belkin RT3200 Snapshot Mesh (802.11s)
A simple script to initialize a fully fonctionnal Belkin RT3200 Mesh network capable for Openwrt. 

## Introduction
One shot script to configure a fresh SNAPSHOT installed operating system for Mesh networks.

*What it does :*
+ Fix the WIFI configuration
+ Remove the "mbedtls" and replace them with the openssl ones
+ Install necessary Kernel Modules (kmods) for networking and wireless card
+ Install Mesh tools
+ Install Luci with package manager on HTTP + HTTPS (with redirection)
+ Activate WEP and install bridger for Dumb Access Point
+ Enable software and hardware network buffering

## Usage
Note: Snapshot releases do not have luci, you need to connect with SSH as root to begin the installation process

```bash
# Allow scp 
ssh root@192.168.1.1 "opkg update && opkg install openssh-sftp-server"
# Copy the installation script
scp install.sh root@192.168.1.1:/tmp/
# Launch it remotly
ssh root@192.168.1.1 "chmod u+x /tmp/install.sh && /tmp/install.sh"
```

### Notes
This script will only work with recent snapshots like the *openwrt-mediatek-mt7622-linksys_e8450-ubi-squashfs-sysupgrade.itb* in the repository (2024-11-04 release)