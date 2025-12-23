#!/bin/bash

function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../
  cd .. && rm -rf $repodir
}

git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/network/config/firewall
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/network/config/firewall4
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/network/utils/fullconenat-nft
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/network/utils/fullconenat
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/network/utils/nftables
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/kernel/linux/modules
git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/libs/libnftnl
git_sparse_clone master https://github.com/immortalwrt/immortalwrt target/linux/generic
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-firewall

rm -rf package/network/{config/firewall,config/firewall4,utils/nftables}
rm -rf target/linux/generic
mv -v generic target/linux
mv -v target/linux/generic/kernel-6.12 include

mv -v {firewall,firewall4} package/network/config
mv -v {nftables,fullconenat,fullconenat-nft} package/network/utils
rm -rf package/libs/libnftnl
mv -v libnftnl package/libs
rm -rf package/kernel/linux/modules
mv -v modules package/kernel/linux


git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/emortal/automount

git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/emortal/autosamba

cp -rf {automount,autosamba} package


# kenrel Vermagic
sed -ie 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk
grep HASH include/kernel-6.12 | awk -F'HASH-' '{print $2}' | awk '{print $1}' | md5sum | awk '{print $1}' > .vermagic



git clone https://github.com/sbwml/autocore-arm package/autocore-arm -b openwrt-24.10 --depth 1

rm -rf package/autocore-arm/.git

git clone -b packages --depth 1 --single-branch https://github.com/shiyu1314/openwrt-feeds package/xd
git clone -b porxy --depth 1 --single-branch https://github.com/shiyu1314/openwrt-feeds package/porxy


rm -rf feeds/luci/applications/{luci-app-firewall,luci-app-dockerman,luci-app-samba4,luci-app-aria2}
rm -rf feeds/packages/{net/samba4,v2ray-geodata,mosdns,sing-box,aria2,ariang,adguardhome}
rm -f feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js

mv -v luci-app-firewall feeds/luci/applications

sed -i 's/libustream-mbedtls/libustream-openssl/' include/target.mk

# luci - fix compat translation
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

pushd feeds/luci
    patch -p1 < 0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch
    patch -p1 < 0002-luci-mod-status-displays-actual-process-memory-usage.patch
    patch -p1 < 0003-luci-mod-status-storage-index-applicable-only-to-val.patch
    patch -p1 < 0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch
    patch -p1 < 0005-luci-mod-system-add-refresh-interval-setting.patch
    patch -p1 < 0006-luci-mod-system-mounts-add-docker-directory-mount-po.patch
    patch -p1 < 0007-luci-mod-system-add-ucitrack-luci-mod-system-zram.js.patch
    patch -p1 < 0008-luci-mod-network-add-option-for-ipv6-max-plt-vlt.patch
    patch -p1 < 0004-luci-add-firewall-add-custom-nft-rule-support.patch
popd



# openssl urandom
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile


# fstools
rm -rf package/system/fstools
git clone https://github.com/sbwml/package_system_fstools -b openwrt-24.10 package/system/fstools
# util-linux
rm -rf package/utils/util-linux
git clone https://github.com/sbwml/package_utils_util-linux -b openwrt-24.10 package/utils/util-linux


patch -p1 < 100-openwrt-firewall4-add-custom-nft-command-support.patch

# openssl
OPENSSL_VERSION=3.0.17
OPENSSL_HASH=dfdd77e4ea1b57ff3a6dbde6b0bdc3f31db5ac99e7fdd4eaf9e1fbb6ec2db8ce
sed -ri "s/(PKG_VERSION:=)[^\"]*/\1$OPENSSL_VERSION/;s/(PKG_HASH:=)[^\"]*/\1$OPENSSL_HASH/" package/libs/openssl/Makefile

# nghttp3
rm -rf feeds/packages/libs/nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# ngtcp2
rm -rf feeds/packages/libs/ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

# curl - fix passwall `time_pretransfer` check
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

#golang 25.x
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

./scripts/feeds update -a
./scripts/feeds install -a


sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

sudo rm -rf package/base-files/files/etc/banner

sed -i "s/%D %V %C/%D %V $(TZ=UTC-8 date +%Y.%m.%d)/" package/base-files/files/etc/openwrt_release

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
