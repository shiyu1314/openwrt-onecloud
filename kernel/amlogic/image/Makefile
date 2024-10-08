#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

# 定义 FAT32 参数
FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

define Build/boot-script
	# 创建 U-Boot 脚本并复制到 boot 分区
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "boot.scr" -d boot.txt $(KDIR)/boot.scr
endef

define Build/emmc-common
	$(RM) -f $@.boot
	mkfs.fat -C $@.boot $(FAT32_BLOCKS)

	mkdir -p $(KDIR)/boot.fat

	$(CP) $(KDIR)/boot.scr $(KDIR)/boot.fat/boot.scr
	mcopy -i $@.boot $(KDIR)/boot.scr ::
	$(CP) $(IMAGE_KERNEL) $(KDIR)/boot.fat/uImage
	mcopy -i $@.boot $(KDIR)/boot.fat/uImage ::

	$(foreach dts,$(shell echo $(DEVICE_DTS)),$(CP) $(DTS_DIR)/$(dts).dtb $(KDIR)/boot.fat/dtb;)
	mcopy -i $@.boot $(KDIR)/boot.fat/dtb ::

	$(RM) -rf $(KDIR)/boot.fat

	# 调用 gen_aml_emmc_img.sh 生成 eMMC 镜像
	./gen_aml_emmc_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

### 设备定义 ###
define Device/Default
  FILESYSTEMS := ext4
  IMAGES := emmc_burn.img
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL_LOADADDR := 0x01080000
  KERNEL_NAME := Image
  KERNEL := kernel-bin | uImage none
  PROFILES = Default $$(DEVICE_NAME)
endef

define Device/thunder-onecloud
  DEVICE_DTS := meson8b-onecloud
  DEVICE_TITLE := Thunder OneCloud
  KERNEL_LOADADDR := 0x00208000
  IMAGE/emmc_burn.img := boot-script onecloud | emmc-common $$(DEVICE_NAME)
endef

ifeq ($(SUBTARGET),meson8b)
  TARGET_DEVICES += thunder-onecloud
endif

$(eval $(call BuildImage))
