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

# BBRv3 - linux-6.6/6.12
pushd target/linux/generic/backport-6.6
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
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
git_sparse_clone master https://github.com/openwrt/openwrt package/kernel/ubnt-ledbar
git_sparse_clone master https://github.com/openwrt/openwrt package/network/config/firewall4
git_sparse_clone master https://github.com/openwrt/openwrt package/libs/libnftnl
git_sparse_clone master https://github.com/openwrt/openwrt package/network/utils/nftables
git_sparse_clone master https://github.com/openwrt/packages net/siit
git_sparse_clone master https://github.com/openwrt/routing batman-adv



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
rm -rf package/kernel/ubnt-ledbar
rm -rf package/network/config/firewall4
rm -rf package/libs/libnftnl
rm -rf package/network/utils/nftables
rm -rf feeds/packages/net/siit
rm -rf feeds/routing/batman-adv
cp -rf batman-adv feeds/routing
cp -rf siit feeds/packages/net
cp -rf nftables package/network/utils
cp -rf libnftnl package/libs
cp -rf firewall4 package/network/config
cp -rf ubnt-ledbar package/kernel
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


pushd package/libs/openssl/patches
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0001-QUIC-Add-support-for-BoringSSL-QUIC-APIs.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0002-QUIC-New-method-to-get-QUIC-secret-length.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0003-QUIC-Make-temp-secret-names-less-confusing.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0004-QUIC-Move-QUIC-transport-params-to-encrypted-extensi.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0005-QUIC-Use-proper-secrets-for-handshake.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0006-QUIC-Handle-partial-handshake-messages.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0007-QUIC-Fix-quic_transport-constructors-parsers.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0008-QUIC-Reset-init-state-in-SSL_process_quic_post_hands.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0009-QUIC-Don-t-process-an-incomplete-message.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0010-QUIC-Quick-fix-s2c-to-c2s-for-early-secret.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0011-QUIC-Add-client-early-traffic-secret-storage.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0012-QUIC-Add-OPENSSL_NO_QUIC-wrapper.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0013-QUIC-Correctly-disable-middlebox-compat.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0014-QUIC-Move-QUIC-code-out-of-tls13_change_cipher_state.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0015-QUIC-Tweeks-to-quic_change_cipher_state.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0016-QUIC-Add-support-for-more-secrets.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0017-QUIC-Fix-resumption-secret.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0018-QUIC-Handle-EndOfEarlyData-and-MaxEarlyData.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0019-QUIC-Fall-through-for-0RTT.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0020-QUIC-Some-cleanup-for-the-main-QUIC-changes.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0021-QUIC-Prevent-KeyUpdate-for-QUIC.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0022-QUIC-Test-KeyUpdate-rejection.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0023-QUIC-Buffer-all-provided-quic-data.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0024-QUIC-Enforce-consistent-encryption-level-for-handsha.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0025-QUIC-add-v1-quic_transport_parameters.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0026-QUIC-return-success-when-no-post-handshake-data.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0027-QUIC-__owur-makes-no-sense-for-void-return-values.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0028-QUIC-remove-SSL_R_BAD_DATA_LENGTH-unused.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0029-QUIC-SSLerr-ERR_raise-ERR_LIB_SSL.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0030-QUIC-Add-compile-run-time-checking-for-QUIC.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0031-QUIC-Add-early-data-support.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0032-QUIC-Make-SSL_provide_quic_data-accept-0-length-data.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0033-QUIC-Process-multiple-post-handshake-messages-in-a-s.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0034-QUIC-Fix-CI.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0035-QUIC-Break-up-header-body-processing.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0036-QUIC-Don-t-muck-with-FIPS-checksums.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0037-QUIC-Update-RFC-references.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0038-QUIC-revert-white-space-change.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0039-QUIC-use-SSL_IS_QUIC-in-more-places.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0040-QUIC-Error-when-non-empty-session_id-in-CH.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0041-QUIC-Update-SSL_clear-to-clear-quic-data.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0042-QUIC-Better-SSL_clear.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0043-QUIC-Fix-extension-test.patch
    curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/openssl/quic/0044-QUIC-Update-metadata-version.patch
popd

# openssl urandom
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# nghttp3
rm -rf feeds/packages/libs/nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# ngtcp2
rm -rf feeds/packages/libs/ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

# add custom nft command support
pushd feeds/luci
    curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/firewall4/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
popd
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1

# cryptodev-linux
mkdir -p package/kernel/cryptodev-linux/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/cryptodev-linux/6.6/001-Fix-build-for-Linux-6.3-rc1.patch > package/kernel/cryptodev-linux/patches/001-Fix-build-for-Linux-6.3-rc1.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/cryptodev-linux/6.6/002-fix-build-for-linux-6.7-rc1.patch > package/kernel/cryptodev-linux/patches/002-fix-build-for-linux-6.7-rc1.patch

# gpio-button-hotplug
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/gpio-button-hotplug/fix-linux-6.6.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/gpio-button-hotplug/fix-linux-6.12.patch | patch -p1

# gpio-nct5104d
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/gpio-nct5104d/fix-build-for-linux-6.6.patch | patch -p1


mkdir -p feeds/packages/libs/dmx_usb_module/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/dmx_usb_module/900-fix-linux-6.6.patch > feeds/packages/libs/dmx_usb_module/patches/900-fix-linux-6.6.patch


# jool
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/jool/Makefile > feeds/packages/net/jool/Makefile || \
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/jool/Makefile.24 > feeds/packages/net/jool/Makefile

# mdio-netlink

mkdir -p feeds/packages/kernel/mdio-netlink/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/mdio-netlink/001-mdio-netlink-rework-C45-to-work-with-net-next.patch > feeds/packages/kernel/mdio-netlink/patches/001-mdio-netlink-rework-C45-to-work-with-net-next.patch


# ovpn-dco
mkdir -p feeds/packages/kernel/ovpn-dco/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/ovpn-dco/100-ovpn-dco-adapt-pre-post_doit-CBs-to-new-signature.patch > feeds/packages/kernel/ovpn-dco/patches/100-ovpn-dco-adapt-pre-post_doit-CBs-to-new-signature.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/ovpn-dco/900-fix-linux-6.6.patch > feeds/packages/kernel/ovpn-dco/patches/900-fix-linux-6.6.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/ovpn-dco/901-fix-linux-6.11.patch > feeds/packages/kernel/ovpn-dco/patches/901-fix-linux-6.11.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/ovpn-dco/902-fix-linux-6.12.patch > feeds/packages/kernel/ovpn-dco/patches/902-fix-linux-6.12.patch


# libpfring
rm -rf feeds/packages/libs/libpfring
mkdir -p feeds/packages/libs/libpfring/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/libpfring/Makefile > feeds/packages/libs/libpfring/Makefile

pushd feeds/packages/libs/libpfring/patches
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/libpfring/patches/0001-fix-cross-compiling.patch
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/libpfring/patches/100-fix-compilation-warning.patch
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/libpfring/patches/900-fix-linux-6.6.patch
popd

# nat46
mkdir -p package/kernel/nat46/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/nat46/100-fix-build-with-kernel-6.9.patch > package/kernel/nat46/patches/100-fix-build-with-kernel-6.9.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/nat46/101-fix-build-with-kernel-6.12.patch > package/kernel/nat46/patches/101-fix-build-with-kernel-6.12.patch


# packages
pushd feeds/packages
  curl -s https://github.com/openwrt/packages/commit/23a3ea2d6b3779cd48d318b95a3c72cad9433d50.patch | patch -p1
  curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/master/openwrt/patch/packages-patches/xr_usb_serial_common/900-fix-linux-6.6.patch > libs/xr_usb_serial_common/patches/900-fix-linux-6.6.patch
  curl -s https://github.com/openwrt/packages/commit/9975e855adcfc24939080a5e0279e0a90553347b.patch | patch -p1
  curl -s https://github.com/openwrt/packages/commit/c0683d3f012096fc7b2fbe8b8dc81ea424945e9b.patch | patch -p1
popd


# telephony
pushd feeds/telephony
  # dahdi-linux
  rm -rf libs/dahdi-linux
  git clone https://github.com/sbwml/feeds_telephony_libs_dahdi-linux libs/dahdi-linux
popd




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
