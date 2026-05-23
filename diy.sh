#!/bin/bash

# 1. 修改默认 LAN IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 注入极光主题 (原作者独立源)
echo "src-git aurora_theme https://github.com/eamonxg/luci-theme-aurora.git;main" >> feeds.conf.default


# =====================================================================
# 3. 🛡️ 【核心纯净流】用 git clone 强行锁定你最想要的原作者原版插件
#    直接放入 package 目录，拥有最高优先级，绝对不会被大杂烩源污染
# =====================================================================

# 锁定原版 OpenClash (最新 master 分支)
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# 锁定原版 ddns-go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git package/luci-app-ddns-go

# 锁定原版 Passwall (包含核心与界面)
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall

echo "src-git small8 https://github.com/kenzok8/small-package.git;main" >> feeds.conf.default
