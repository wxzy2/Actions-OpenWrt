#!/bin/bash
# --------------------------------------------------------
# 两个机型共用的自定义批处理脚本 (已修正 Aria2 及依赖冲突)
# --------------------------------------------------------

DEVICE=$1
echo "正在为设备 [ $DEVICE ] 执行自定义批处理步骤..."

# 1. 修改默认 IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 强制删除（拉黑）luci-app-attendedsysupgrade 插件避免编译
rm -rf feeds/luci/applications/luci-app-attendedsysupgrade
rm -rf package/feeds/luci/luci-app-attendedsysupgrade

# 3. 添加第三方公共插件仓库 (放置到 package/custom 目录下)
mkdir -p package/custom
cd package/custom

# ddns-go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git

# OpenClash (先彻底清理自带 feeds 目录以防同名冲突)
rm -rf ../../feeds/luci/applications/luci-app-openclash
rm -rf ../../package/feeds/luci/luci-app-openclash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash.git

# HomeProxy (先彻底清理自带 feeds 目录以防同名冲突)
rm -rf ../../feeds/luci/applications/luci-app-homeproxy
rm -rf ../../package/feeds/luci/luci-app-homeproxy
git clone --depth=1 https://github.com/immortalwrt/homeproxy.git

# 极光主题 Aurora
git clone --depth=1 https://github.com/eamonxg/luci-theme-aurora.git

# 4. 针对不同机型的特定个性化源码处理
cd ../../ 

if [ "$DEVICE" = "ax6600" ]; then
    echo "正在为 京东云雅典娜 额外添加 LED 屏幕控制插件..."
    cd package/custom
    # 雅典娜原作者最新的屏显控制插件
    git clone --depth=1 https://github.com/Aisunsoft/luci-app-athena-led.git
    cd ../../
elif [ "$DEVICE" = "360v6" ]; then
    echo "360v6 无特定独占源码，跳过此步。"
fi

echo "自定义批处理执行完毕！"
