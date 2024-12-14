#!/bin/sh

# 调整分区大小
parted /dev/mmcblk1 resizepart 2 100%

# 设置loop设备
losetup /dev/loop0 /dev/mmcblk1p2

# 检查文件系统
e2fsck -f -y /dev/loop0

# 调整文件系统大小
resize2fs -f /dev/loop0

# 同步数据
sync

# 提示用户是否重启
echo "所有操作已完成。是否现在重启系统以使更改生效？(y/n): \c"
read response

# 使用 case 语句来处理用户输入
case "$response" in
    [yY]|[yY][eE][sS])
        echo "正在重启系统..."
        reboot
        ;;
    *)
        echo "请在稍后手动重启系统以应用更改。"
        ;;
esac
