FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://nfs.cfg \
            file://ppp-network.cfg \
            file://usb-devices.cfg \
            file://virtual-devices.cfg \
"
