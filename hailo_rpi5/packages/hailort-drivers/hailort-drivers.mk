################################################################################
#
# hailort-drivers
#
################################################################################

HAILORT_DRIVERS_VERSION = v4.20.0
HAILORT_DRIVERS_SITE = https://github.com/hailo-ai/hailort-drivers.git
HAILORT_DRIVERS_SITE_METHOD = git
HAILORT_DRIVERS_GIT_SUBMODULES = YES
HAILORT_DRIVERS_LICENSE = GPL-2.0
HAILORT_DRIVERS_LICENSE_FILES = LICENSE
HAILORT_DRIVERS_DEPENDENCIES = linux hailort

define HAILORT_DRIVERS_BUILD_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D)/linux/pcie modules
endef

define HAILORT_DRIVERS_INSTALL_TARGET_CMDS
	# Remove old driver if it exists
	rm -f $(TARGET_DIR)/lib/modules/*/kernel/drivers/media/pci/hailo/hailo_pci.ko
	# Install new driver
	$(INSTALL) -D -m 0644 $(@D)/linux/pcie/hailo_pci.ko \
		$(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/media/pci/hailo/hailo_pci.ko
	# Update module dependencies
	depmod -a -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
endef

$(eval $(kernel-module))
$(eval $(generic-package))