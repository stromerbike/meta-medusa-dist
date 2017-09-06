FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://jtag-pm.patch \
            file://ppp-network.cfg \
            file://usb-devices.cfg \
            file://virtual-devices.cfg \
            file://wifi-devices.cfg \
"
