################################################################################
#
# rpi-firmware
#
################################################################################

#RPI_FIRMWARE_CUSTOM_VERSION = 7a661e021417ebd6552494006b64c3eb2ebca644
RPI_FIRMWARE_CUSTOM_VERSION = af994023ab491420598bfd5648b9dcab956f7e11
#RPI_FIRMWARE_CUSTOM_VERSION = 0f315f88ac91f9be93544bfd757f8d55ca4cf099
#RPI_FIRMWARE_CUSTOM_VERSION = b84b5f08db920a1cafb838bb2914b9dcf7c597da
RPI_FIRMWARE_CUSTOM_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_CUSTOM_VERSION))
RPI_FIRMWARE_CUSTOM_LICENSE = BSD-3c
RPI_FIRMWARE_CUSTOM_LICENSE_FILES = boot/LICENCE.broadcom
RPI_FIRMWARE_CUSTOM_INSTALL_IMAGES = YES

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_CUSTOM_INSTALL_DTBS),y)
define RPI_FIRMWARE_CUSTOM_INSTALL_DTB
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2708-rpi-b.dtb $(BINARIES_DIR)/rpi-firmware/bcm2708-rpi-b.dtb
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2708-rpi-b-plus.dtb $(BINARIES_DIR)/rpi-firmware/bcm2708-rpi-b-plus.dtb
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2709-rpi-2-b.dtb $(BINARIES_DIR)/rpi-firmware/bcm2709-rpi-2-b.dtb
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2710-rpi-3-b.dtb $(BINARIES_DIR)/rpi-firmware/bcm2710-rpi-3-b.dtb
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_CUSTOM_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_CUSTOM_INSTALL_DTB_OVERLAYS
	for ovldtb in  $(@D)/boot/overlays/*.dtbo; do \
		$(INSTALL) -D -m 0644 $${ovldtb} $(BINARIES_DIR)/rpi-firmware/overlays/$${ovldtb##*/} || exit 1; \
	done
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_CUSTOM_INSTALL_VCDBG),y)
define RPI_FIRMWARE_CUSTOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0700 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/bin/vcdbg \
		$(TARGET_DIR)/usr/sbin/vcdbg
endef
endif # INSTALL_VCDBG

define RPI_FIRMWARE_CUSTOM_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/rpi-firmware/bootcode.bin
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_CUSTOM_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_CUSTOM_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup.dat
	$(INSTALL) -D -m 0644 $(RPI_FIRMWARE_CUSTOM_PKGDIR)/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt $(BINARIES_DIR)/rpi-firmware/cmdline.txt
	$(RPI_FIRMWARE_CUSTOM_INSTALL_DTB)
	$(RPI_FIRMWARE_CUSTOM_INSTALL_DTB_OVERLAYS)
endef

$(eval $(generic-package))
