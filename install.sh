#/bin/env ash
set -e

# Script for installing a ready to go Belkin RT2000 with full mesh support with Openssh
# 
# Tested with version "SNAPSHOT openwrt-24.10 branch 24.298.52515~e34c268" gathered on the 4th of November 2024. 
# sha256sum: 7b8b840a81a89fefa5754f355725c34bb7c7c2cdb57d39972bba127e151bb566
#

# Prepare
opkg update

# Fix Wifi configuration
echo "config wifi-device 'radio0'
	option type 'mac80211'
	option path 'platform/18000000.wmac'
	option channel 'auto'
	option band '2g'
	option htmode 'HT40'
	option txpower '20'
	option cell_density '0'

config wifi-iface 'default_radio0'
	option device 'radio0'
	option network 'lan'
	option mode 'ap'
	option ssid 'OpenWrt'
	option encryption 'none'
	option disabled '1'

config wifi-device 'radio1'
	option type 'mac80211'
	option path '1a143000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0'
	option cell_density '0'
	option country 'US'
	option htmode 'HE40'
	option band '5g'
	option channel 'auto'
	option disabled '1'

config wifi-iface 'default_radio1'
	option device 'radio1'
	option network 'lan'
	option mode 'ap'
	option ssid 'OpenWrt'
	option encryption 'none'
	option disabled '1'

" > /etc/config/wireless

# Replace libustream by openssl one
opkg --cache /tmp/ --download-only install libustream-openssl20201210
opkg remove libustream-mbedtls20201210
opkg --cache /tmp/ install libustream-openssl20201210

# Install Luci
opkg install luci

# Install Luci HTTPS openssl
opkg update
opkg install luci-ssl-openssl
/etc/init.d/uhttpd restart
uci set uhttpd.main.redirect_https=1
uci commit uhttpd
service uhttpd reload

# Remove "mbedtls" related packages
opkg remove wpad-basic-mbedtls
opkg remove libmbedtls21

# Install Openssl and Mesh
opkg update
opkg install wpad-mesh-openssl
opkg install mesh11sd

# Install required kernel modules
opkg update
opkg install kmod-mt7915-firmware
opkg install kmod-nft-bridge

# Enable WED
echo 'options mt7915e wed_enable=Y' >> /etc/modules.conf
# Install Bridger for WED + Dumb Access Point
opkg update
opkg install bridger

# Enable Buffering
{ head -n 5 /etc/config/firewall; echo -e "\toption flow_offloading\t'1'"; echo -e "\toption flow_offloading_hw\t'1'"; tail -n +6 /etc/config/firewall; } > /tmp/firewall
mv -f /tmp/firewall /etc/config/firewall
/etc/init.d/firewall restart

# Install Luci package manager
opkg install luci-app-opkg

# BONUS: Install Statistics
# opkg install luci-app-statistics

# Reboot an Enjoy
reboot



