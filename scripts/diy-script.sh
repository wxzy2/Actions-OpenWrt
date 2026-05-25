#!/bin/bash
# --------------------------------------------------------
# 两个机型共用的自定义批处理脚本
# $1 传入的参数为矩阵中的设备名 (360v6 或 ax6600)
# --------------------------------------------------------

DEVICE=$1
echo "正在为设备 [ $DEVICE ] 执行自定义批处理步骤..."

# 1. 修改默认 IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 强制删除（拉黑）luci-app-attendedsysupgrade 插件避免编译
rm -rf feeds/luci/applications/luci-app-attendedsysupgrade
rm -rf package/feeds/luci/luci-app-attendedsysupgrade

# 3. 添加第三方插件仓库 (放置到 package/custom 目录下)
mkdir -p package/custom
cd package/custom

# ddns-go
git clone https://github.com/sirpdboy/luci-app-ddns-go.git

# openlist2 (SmartDNS/DNS相关或特定策略组，这里以常见源为例，若有原作者特定库请自行替换URL)
# git clone https://github.com/XXX/luci-app-openlist2.git 

# aria2 (Immortalwrt 自带，若需原作者最新版可专门引入，这里拉取常用精美控制台)
git clone https://github.com/sirpdboy/luci-app-aria2.git

# OpenClash (先删除自带的，再克隆原作者最新版)
rm -rf ../../feeds/luci/applications/luci-app-openclash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash.git

# HomeProxy (先删除自带的，再克隆原作者独立版)
rm -rf ../../feeds/luci/applications/luci-app-homeproxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy.git

# 极光主题 Aurora
git clone https://github.com/eamonxg/luci-theme-aurora.git

# 4. 针对不同机型的特定个性化源码处理 (用 if-else 区分)
cd ../../ # 返回源码主目录

if [ "$DEVICE" = "ax6600" ]; then
    echo "正在为 京东云雅典娜 额外添加 LED 屏幕控制插件..."
    # 雅典娜 LED 屏幕控制原作者仓库 (此处以目前主流的 jdyun-led/luci-app-jdcloud-led 为例，可按需修改URL)
    cd package/custom
    git clone https://github.com/Aisunsoft/luci-app-athena-led.git || git clone https://github.com/0236/luci-app-jdcloud-led.git
    cd ../../
elif [ "$DEVICE" = "360v6" ]; then
    echo "360v6 无特定独占源码，跳过此步。"
fi

echo "自定义批处理执行完毕！"