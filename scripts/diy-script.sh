#!/bin/bash
# =====================================================
# 通用 DIY 脚本（360v6 / ax6600 严格隔离版）
# 用法: bash diy.sh [pre|post] [device]
# =====================================================

STAGE=${1:-post}
DEVICE=${2:-unknown}

pre() {
  # ── 覆盖 feeds.conf.default，包含 NSS 加速库 ────────────
  echo "src-git nss_packages https://github.com/VIKINGYFY/nss-packages.git" > feeds.conf.default
  echo "src-git packages https://github.com/immortalwrt/packages.git"      >> feeds.conf.default
  echo "src-git luci https://github.com/immortalwrt/luci.git"              >> feeds.conf.default
  echo "src-git routing https://github.com/openwrt/routing.git"            >> feeds.conf.default
  echo "src-git telephony https://github.com/openwrt/telephony.git"        >> feeds.conf.default
}

post() {
  # ── 1. 强制替换为 openlist2 官方要求的 Golang 24.x 版本 ──
  echo "正在替换兼容的 Golang 24.x 版本..."
  rm -rf feeds/packages/lang/golang 2>/dev/null || true
  git clone --depth=1 -b 24.x \
    https://github.com/sbwml/packages_lang_golang \
    feeds/packages/lang/golang

  # ── 2. 基础系统配置修改 ──────────────────────────────────
  # 默认 IP
  sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate
  # 默认时区
  sed -i 's/timezone_hint.*/timezone_hint="Asia\/Shanghai"/' package/base-files/files/bin/config_generate
  sed -i 's/timezone=.*/timezone="CST-8"/' package/base-files/files/bin/config_generate

  # ── 3. 全局公共插件克隆（两台机型可能都会用到的基础池） ──
  git clone --depth=1 -b master https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora
  git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
  git clone --depth=1 -b master https://github.com/vernesong/OpenClash package/luci-app-openclash
  git clone --depth=1 https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy

  # ── 4. 严格的机型硬件与逻辑隔离 ──────────────────────────
  if [ "$DEVICE" = "ax6600" ]; then
    echo "▶ 正在为 AX6600 注入专属插件..."
    # ax6600 专属 LED
    git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
    # ax6600 专属 openlist2
    git clone --depth=1 https://github.com/sbwml/luci-app-openlist2 package/luci-app-openlist2
    
  elif [ "$DEVICE" = "360v6" ]; then
    echo "▶ 正在为 360v6 注入专属插件..."
    # 只有 360v6 才去拉取 aria2，防止污染 ax6600
    git clone --depth=1 --filter=blob:none --sparse https://github.com/openwrt/luci /tmp/luci-sparse
    cd /tmp/luci-sparse
    git sparse-checkout set applications/luci-app-aria2
    cp -r applications/luci-app-aria2 $GITHUB_WORKSPACE/openwrt/package/luci-app-aria2
    cd $GITHUB_WORKSPACE/openwrt
  fi

  # ── 5. 安全的清理逻辑（绝不盲删 INCLUDE） ────────────────
  echo "正在执行源码安全清理..."
  # 移除垃圾组件（只删明确不需要的文件夹，绝不在 .config 里盲删包含 INCLUDE_ 的行）
  find package feeds -type d -name "luci-app-attendedsysupgrade" -exec rm -rf {} + 2>/dev/null || true
  find package feeds -type d -name "*xray*" -exec rm -rf {} + 2>/dev/null || true
  find package feeds -type f -name "Makefile" -exec grep -l "xray" {} \; | xargs -I {} dirname {} | xargs rm -rf 2>/dev/null || true

  # 仅仅移除明确不需要的 passwall 残留配置项
  sed -i '/CONFIG_PACKAGE_luci-app-passwall/d' openwrt/.config 2>/dev/null || true
}

case "$STAGE" in
  pre)  pre  ;;
  post) post ;;
esac
