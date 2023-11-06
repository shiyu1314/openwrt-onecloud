#!/bin/bash
#=================================================
sudo rm -rf feeds/packages/net/mosdns
sed -i "s/<%:Login%>/<%:Log in%>/" feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/sysauth.htm

