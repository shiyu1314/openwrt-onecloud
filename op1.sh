#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git dns https://github.com/sbwml/luci-app-mosdns' >>feeds.conf.default

svn co https://github.com/shiyu1314/openwrt-onecloud/trunk/target/linux/meson target/linux/meson

svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
