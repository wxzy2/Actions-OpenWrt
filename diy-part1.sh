#!/bin/bash

# 添加 kenzok8/small-package 软件源
echo "src-git small8 https://github.com/kenzok8/small-package" >> openwrt/feeds.conf.default
git clone --depth 1 https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora
