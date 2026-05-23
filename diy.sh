#!/bin/bash

# 1. 修改默认 LAN IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 🛡️【紧急自救补丁】修复官方 filogic.mk 语法错误（missing endef 报错）
# 如果遇到特定的遗漏，强行为其追加结束符（针对近期的源码变动进行结构修复）
if [ -f "target/linux/mediatek/image/filogic.mk" ]; then
    # 下面这行命令会去排查并修复 filogic.mk 结尾或者段落中可能断掉的 define 块
    sed -i '/define Device\/jdcloud_athena/,/endef/ { /endef/! { /macaddr/a \\endef\n } }' target/linux/mediatek/image/filogic.mk
    # 备用方案：如果是全局语法混乱，直接强行对该平台上游做一次通用闭合
    echo -e "\nendef" >> target/linux/mediatek/image/filogic.mk
fi

# 3. 注入极光主题 (原作者独立源)
echo "src-git aurora_theme https://github.com/eamonxg/luci-theme-aurora.git;main" >> feeds.conf.default


# =====================================================================
# 4. 用 git clone 锁定原作者原版插件（直接放入 package 目录，最高优先级）
# =====================================================================
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git package/luci-app-ddns-go



# =====================================================================
# 5. 📦 将 small-package 放在 Feeds 最后面当备用百宝箱（如捞取 aria2）
# =====================================================================
echo "src-git small8 https://github.com/kenzok8/small-package.git;main" >> feeds.conf.default
