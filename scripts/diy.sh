#!/bin/bash
# =====================================================
# 通用 DIY 脚本（360v6 / ax6600 共用）- 优化版
# =====================================================

STAGE=${1:-post}
DEVICE=${2:-unknown}

pre() {
  echo "===== DIY Pre Stage (feeds 前) ====="

  cat > feeds.conf.default << 'EOF'
src-git nss_packages https://github.com/VIKINGYFY/nss-packages.git
src-git packages https://github.com/immortalwrt/packages.git
src-git luci https://github.com/immortalwrt/luci.git
src-git routing https://github.com/openwrt/routing.git
src-git telephony https://github.com/openwrt/telephony.git
src-git video https://github.com/openwrt/video.git
EOF

  echo "feeds.conf.default 已正确生成（包含 nss_packages）"
}

post() {
  echo "===== DIY Post Stage (feeds 后) ====="

  # ── 默认 IP ───────────────────────────────────────────────
  sed -i 's/192.168.1.1/10.1.1.1/g' \
    package/base-files/files/bin/config_generate

  # ── 主机名（按机型区分）──────────────────────────────────
  if [ "$DEVICE" = "ax6600" ]; then
    sed -i 's/ImmortalWrt/AX6600/g' \
      package/base-files/files/bin/config_generate
  else
    sed -i 's/ImmortalWrt/360v6/g' \
      package/base-files/files/bin/config_generate
  fi

  # ── 时区 ──────────────────────────────────────────────────
  sed -i "s/'UTC'/'CST-8'/g" \
    package/base-files/files/bin/config_generate

  # ── Aurora 主题 ───────────────────────────────────────────
  git clone --depth=1 -b master \
    https://github.com/eamonxg/luci-theme-aurora \
    package/luci-theme-aurora

  # ── ddns-go ───────────────────────────────────────────────
  git clone --depth=1 \
    https://github.com/sirpdboy/luci-app-ddns-go \
    package/luci-app-ddns-go

  # ── OpenClash ─────────────────────────────────────────────
  git clone --depth=1 -b master \
    https://github.com/vernesong/OpenClash \
    package/luci-app-openclash

  # ── openlist2 ─────────────────────────────────────────────
  git clone --depth=1 \
    https://github.com/sbwml/luci-app-openlist2 \
    package/luci-app-openlist2

  # ── homeproxy ─────────────────────────────────────────────
  git clone --depth=1 \
    https://github.com/immortalwrt/homeproxy \
    package/luci-app-homeproxy

  # ── aria2 ─────────────────────────────────────────────────
  rm -rf /tmp/luci-sparse
  git clone --depth=1 --filter=blob:none --sparse \
    https://github.com/openwrt/luci /tmp/luci-sparse
  cd /tmp/luci-sparse
  git sparse-checkout set applications/luci-app-aria2
  cp -r applications/luci-app-aria2 \
    $GITHUB_WORKSPACE/openwrt/package/luci-app-aria2
  cd $GITHUB_WORKSPACE/openwrt

  # ── AX6600 LED ────────────────────────────────────────────
  if [ "$DEVICE" = "ax6600" ]; then
    git clone --depth=1 \
      https://github.com/NONGFAH/luci-app-athena-led \
      package/luci-app-athena-led
  fi

  # ── 清理不需要的插件 ──────────────────────────────────────
  find package feeds -type d -name "luci-app-attendedsysupgrade" \
    -exec rm -rf {} + 2>/dev/null || true

  echo "DIY Post 阶段完成"
}

case "$STAGE" in
  pre) pre ;;
  post) post ;;
esac