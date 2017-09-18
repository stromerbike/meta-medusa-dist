FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://CVE-2017-1000251.patch \
            file://debug.cfg \
            file://filesystems.cfg \
            file://jtag-pm.patch \
            file://ppp-network.cfg \
            file://usb-devices.cfg \
            file://virtual-devices.cfg \
            file://wifi-devices.cfg \
"
