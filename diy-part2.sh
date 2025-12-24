#!/bin/bash

# 1. 修改默认 IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 替换 Athena (雅典娜) 的 LED 驱动
rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led
chmod +x package/luci-app-athena-led/root/usr/sbin/athena-led

# 3. 彻底物理删除测速插件 (防止被 small-package 自动装回去)
rm -rf feeds/small8/luci-app-netspeedtest
rm -rf feeds/small8/speedtest-cli

# 4. 彻底物理删除在线升级插件
rm -rf feeds/luci/applications/luci-app-attendedsysupgrade
