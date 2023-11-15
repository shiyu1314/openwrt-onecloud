#!/bin/bash


mkdir -p turboacc_tmp package/turboacc

cd turboacc_tmp 
git clone https://github.com/chenmozhijin/turboacc -b package

cd ../package/turboacc

git clone https://github.com/fullcone-nat-nftables/nft-fullcone
git clone https://github.com/chenmozhijin/turboacc

mv ./turboacc/luci-app-turboacc ./luci-app-turboacc
rm -rf ./turboacc

cd ../..

cp -f turboacc_tmp/turboacc/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch ./target/linux/meson/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch
cp -f turboacc_tmp/turboacc/hack-6.1/953-net-patch-linux-kernel-to-support-shortcut-fe.patch ./target/linux/meson/hack-6.1/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
cp -f turboacc_tmp/turboacc/pending-6.1/613-netfilter_optional_tcp_window_check.patch ./target/linux/meson/pending-6.1/613-netfilter_optional_tcp_window_check.patch

rm -rf ./package/libs/libnftnl ./package/network/config/firewall4 ./package/network/utils/nftables

mkdir -p ./package/network/config/firewall4 ./package/libs/libnftnl ./package/network/utils/nftables

cp -r ./turboacc_tmp/turboacc/shortcut-fe ./package/turboacc
cp -RT ./turboacc_tmp/turboacc/firewall4-$(grep -o 'FIREWALL4_VERSION=.*' ./turboacc_tmp/turboacc/version | cut -d '=' -f 2)/firewall4 ./package/network/config/firewall4
cp -RT ./turboacc_tmp/turboacc/libnftnl-$(grep -o 'LIBNFTNL_VERSION=.*' ./turboacc_tmp/turboacc/version | cut -d '=' -f 2)/libnftnl ./package/libs/libnftnl
cp -RT ./turboacc_tmp/turboacc/nftables-$(grep -o 'NFTABLES_VERSION=.*' ./turboacc_tmp/turboacc/version | cut -d '=' -f 2)/nftables ./package/network/utils/nftables

rm -rf turboacc_tmp

echo "# CONFIG_NF_CONNTRACK_CHAIN_EVENTS is not set" >> target/linux/meson/config-6.1
echo "# CONFIG_SHORTCUT_FE is not set" >> target/linux/meson/config-6.1
