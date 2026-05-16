#!/bin/bash
# 修改管理IP
sed -i 's/192.168.100.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 默认WiFi
mkdir -p files/etc/config
cat > files/etc/config/wireless << EOF
config wifi-device 'radio0'
        option type 'mac80211'
        option channel '6'
        option band '2g'
        option htmode 'HT20'
        option disabled '0'
        option country 'CN'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'iStoreOS-WiFi'
        option encryption 'psk2'
        option key '12345678'
EOF

# 开机启动WiFi
chmod +x files/etc/rc.local
sed -i '/exit 0/d' files/etc/rc.local
echo "wifi up" >> files/etc/rc.local
