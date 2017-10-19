FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://CVE-2017-1000251.patch \
            file://filesystems.cfg \
            file://i2c-devices.cfg \
            file://jtag-pm.patch \
            file://pca953x_irq.patch \
            file://ppp-network.cfg \
            file://usb-devices.cfg \
            file://virtual-devices.cfg \
            file://wifi-devices.cfg \
"

KERNEL_MODULE_PROBECONF += " gpio-pca953x"
module_conf_gpio-pca953x = "blacklist gpio-pca953x"
