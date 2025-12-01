
# Add a feed source
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
# echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo.git;main" >> "feeds.conf.default"

# echo 'src-git smpackage https://github.com/kenzok8/small-package' >>feeds.conf.default
# sed -i '1i src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
# sed -i '2i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
# sed -i '3i src-git small https://github.com/kenzok8/small' feeds.conf.default
# echo 'src-git roacn https://github.com/roacn/openwrt-packages' >>feeds.conf.default

# sed -i '1i src-git homeproxy https://github.com/immortalwrt/homeproxy' feeds.conf.default

# 活动连接数修改
# sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
# 6.6连接数
# sed -i '/customized in this file/a fs.file-max=102400\nnet.ipv4.neigh.default.gc_thresh1=512\nnet.ipv4.neigh.default.gc_thresh2=2048\nnet.ipv4.neigh.default.gc_thresh3=4096\nnet.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf
# 6.6修正连接数（by ベ七秒鱼ベ）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf


sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default


# 添加额外插件
# git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
# git clone --depth=1 https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy
