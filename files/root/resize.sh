#!/bin/bash

resize2fs /dev/mmcblk1p2
echo "# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

exit 0">/etc/rc.local
rm -rf /root/resize.sh
