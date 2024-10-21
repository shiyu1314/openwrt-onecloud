#!/bin/bash

rm -rf target/linux/generic

git clone https://github.com/sbwml/target_linux_generic -b main target/linux/generic --depth=1

# kernel - 6.x
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/tags/kernel-6.6 > include/kernel-6.6

# kenrel Vermagic
sed -ie 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk
grep HASH include/kernel-6.6 | awk -F'HASH-' '{print $2}' | awk '{print $1}' | md5sum | awk '{print $1}' > .vermagic


# kernel modules
rm -rf package/kernel/linux
git checkout package/kernel/linux
pushd package/kernel/linux/modules
    rm -f [a-z]*.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/block.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/can.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/crypto.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/firewire.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/fs.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/gpio-cascade.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/hwmon.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/i2c.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/iio.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/input.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/leds.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/lib.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/multiplexer.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/netdevices.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/netfilter.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/netsupport.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/nls.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/other.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/pcmcia.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/sound.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/spi.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/usb.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/video.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/virt.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/w1.mk
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openwrt-6.x/modules/wpan.mk
popd

function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../
  cd .. && rm -rf $repodir
}

echo 'src-git xd https://github.com/shiyu1314/openwrt-packages' >>feeds.conf.default
echo 'src-git mihomo https://github.com/morytyann/OpenWrt-mihomo' >>feeds.conf.default

git_sparse_clone $REPO_BRANCH https://github.com/immortalwrt/immortalwrt package/emortal
git_sparse_clone $REPO_BRANCH https://github.com/immortalwrt/immortalwrt package/utils/mhz
git_sparse_clone $REPO_BRANCH https://github.com/immortalwrt/luci modules/luci-base
git_sparse_clone $REPO_BRANCH https://github.com/immortalwrt/luci modules/luci-mod-status
git_sparse_clone $REPO_BRANCH https://github.com/immortalwrt/packages net/chinadns-ng
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
git_sparse_clone master https://github.com/openwrt/luci applications/luci-app-alist
git_sparse_clone master https://github.com/openwrt/packages net/alist
git_sparse_clone master https://github.com/openwrt/packages lang/golang
git_sparse_clone master https://github.com/openwrt/packages net/uwsgi
git_sparse_clone master https://github.com/openwrt/openwrt package/network/config/firewall4
git_sparse_clone master https://github.com/openwrt/openwrt package/libs/libnftnl
git_sparse_clone master https://github.com/openwrt/openwrt package/network/utils/nftables
git_sparse_clone master https://github.com/openwrt/openwrt package/kernel/ubnt-ledbar



git clone -b master --depth 1 --single-branch https://github.com/jerrykuku/luci-theme-argon package/xd/luci-theme-argon
git clone -b master --depth 1 --single-branch https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone -b v5-lua --depth 1 --single-branch https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

./scripts/feeds update -a
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/modules/luci-base
rm -rf feeds/luci/modules/luci-mod-status
rm -rf feeds/packages/lang/golang
rm -rf package/network/config/firewall4
rm -rf package/libs/libnftnl
rm -rf package/network/utils/nftables
rm -rf package/kernel/ubnt-ledbar
cp -rf ubnt-ledbar package/kernel
cp -rf nftables package/network/utils
cp -rf libnftnl package/libs
cp -rf firewall4 package/network/config
cp -rf golang feeds/packages/lang
cp -rf mhz package/utils/
cp -rf chinadns-ng package
cp -rf luci-app-alist feeds/luci/applications
cp -rf alist feeds/packages/net
cp -rf luci-app-openclash package
cp -rf emortal package
cp -rf luci-base feeds/luci/modules
cp -rf luci-mod-status feeds/luci/modules/
rm -rf feeds/packages/net/uwsgi
cp -rf uwsgi feeds/packages/net
sed -i 's/+luci-light //g' feeds/luci/collections/luci/Makefile
pushd feeds/luci
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/luci/0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch | patch -p1
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/luci/0002-luci-mod-status-displays-actual-process-memory-usage.patch | patch -p1
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/luci/0003-luci-mod-status-storage-index-applicable-only-to-val.patch | patch -p1
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/luci/0005-luci-mod-system-add-refresh-interval-setting.patch | patch -p1
popd

pushd feeds/packages
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/nginx-util/0001-nginx-util-fix-compilation-with-GCC13.patch | patch -p1
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/nginx-util/0002-nginx-util-move-to-pcre2.patch | patch -p1
popd

# nginx - latest version
rm -rf feeds/packages/net/nginx
git clone https://github.com/sbwml/feeds_packages_net_nginx feeds/packages/net/nginx -b "$REPO_BRANCH"
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/net/nginx/files/nginx.init

# nginx - ubus
sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 300;' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - uwsgi timeout & enable brotli
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/luci.locations > feeds/packages/net/nginx/files-luci-support/luci.locations
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/nginx/openwrt-23.05-uci.conf.template > feeds/packages/net/nginx-util/files/uci.conf.template

# uwsgi - fix timeout
sed -i '$a cgi-timeout = 600' feeds/packages/net/uwsgi/files-luci-support/luci-*.ini
sed -i '/limit-as/c\limit-as = 5000' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
# disable error log
sed -i "s/procd_set_param stderr 1/procd_set_param stderr 0/g" feeds/packages/net/uwsgi/files/uwsgi.init

# uwsgi - performance
sed -i 's/threads = 1/threads = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/processes = 3/processes = 4/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/cheaper = 1/cheaper = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini

# rpcd - fix timeout
sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
sed -i 's#20) \* 1000#60) \* 1000#g' feeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

# add custom nft command support
pushd feeds/luci
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/firewall4/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
popd
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1


./scripts/feeds update -a
./scripts/feeds install -a

sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

sudo rm -rf package/base-files/files/etc/banner

sed -i "s/%D %V %C/%D $(TZ=UTC-8 date +%Y.%m.%d)/" package/base-files/files/etc/openwrt_release

sed -i "s/%R/by $OP_author/" package/base-files/files/etc/openwrt_release

date=$(date +"%Y-%m-%d")
echo "                                                    " >> package/base-files/files/etc/banner
echo "  _______                     ________        __" >> package/base-files/files/etc/banner
echo " |       |.-----.-----.-----.|  |  |  |.----.|  |_" >> package/base-files/files/etc/banner
echo " |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|" >> package/base-files/files/etc/banner
echo " |_______||   __|_____|__|__||________||__|  |____|" >> package/base-files/files/etc/banner
echo "          |__|" >> package/base-files/files/etc/banner
echo " -----------------------------------------------------" >> package/base-files/files/etc/banner
echo "         %D ${date} by $OP_author                     " >> package/base-files/files/etc/banner
echo " -----------------------------------------------------" >> package/base-files/files/etc/banner
