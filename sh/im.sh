#!/bin/bash

function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../
  cd .. && rm -rf $repodir
}

git_sparse_clone master https://github.com/shiyu1314/openwrt-packages luci-app-adguardhome

mv -f luci-app-adguardhome package

echo 'src-git dns https://github.com/sbwml/luci-app-mosdns' >>feeds.conf.default

sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default

./scripts/feeds update -a
rm -rf feeds/packages/net/mosdns
rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb}

curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

./scripts/feeds update -a
./scripts/feeds install -a

sed -i "s/192.168.1.1/192.168.3.10/" package/base-files/files/bin/config_generate
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

git_sparse_clone tini https://github.com/hauke/packages utils/tini/patches

cp -rf patches feeds/packages/utils/tini

ls feeds/packages/utils/tini/patches

sudo rm -rf package/base-files/files/etc/banner

sed -i "s/%D %V %C/%D $(TZ=UTC-8 date +%Y.%m.%d)/" package/base-files/files/etc/openwrt_release

sed -i "s/%R/by shiyu1314/" package/base-files/files/etc/openwrt_release


date=$(date +"%Y-%m-%d")
echo "                                                    " >> package/base-files/files/etc/banner
echo ".___                               __         .__" >> package/base-files/files/etc/banner
echo "|   | _____   _____   ____________/  |______  |  |" >> package/base-files/files/etc/banner
echo "|   |/     \ /     \ /  _ \_  __ \   __\__  \ |  |" >> package/base-files/files/etc/banner
echo "|   |  Y Y  \  Y Y  (  <_> )  | \/|  |  / __ \|  |__" >> package/base-files/files/etc/banner
echo "|___|__|_|  /__|_|  /\____/|__|   |__| (____  /____/" >> package/base-files/files/etc/banner
echo "          \/      \/                        \/      " >> package/base-files/files/etc/banner
echo " -----------------------------------------------------" >> package/base-files/files/etc/banner
echo "         %D ${date} by shiyu1314                     " >> package/base-files/files/etc/banner
echo " -----------------------------------------------------" >> package/base-files/files/etc/banner
echo "                                                      " >> package/base-files/files/etc/banner
