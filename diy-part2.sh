#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改openwrt登陆地址
sed -i 's/192.168.100.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改主机名字
sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate

# ttyd 自动登录（注释掉，避免出错）
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" package/feeds/packages/ttyd/files/ttyd.config

# 添加自定义软件包
echo '
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-adguardhome=y
CONFIG_PACKAGE_luci-app-openclash=y
' >> .config

# ========== 添加默认WiFi ==========
mkdir -p files/etc/config
cat > files/etc/config/wireless << 'EOF'
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
    option encryption 'psk2+ccmp'
    option key '12345678'
EOF

# 开机自动启用WiFi
chmod +x files/etc/rc.local
sed -i '/exit 0/d' files/etc/rc.local
echo "wifi up" >> files/etc/rc.local
