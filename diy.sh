#!/bin/bash

# 1. 修改默认 LAN IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 注入极光主题 (luci-theme-aurora)
echo "src-git aurora_theme https://github.com/eamonxg/luci-theme-aurora.git;main" >> feeds.conf.default

# 3. 注入 ddns-go 核心源
echo "src-git ddnsgo https://github.com/sirpdboy/luci-app-ddns-go.git;main" >> feeds.conf.default

# 4. 注入 OpenClash 核心源
echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default

# 5. 注入常用精选插件集合源 (包含 passwall, aria2, smartdns 等)
echo "src-git small8 https://github.com/kenzok8/small-package.git;main" >> feeds.conf.default
