FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://jtag-pm.patch"

SRC_URI += "file://ppp-network.cfg"
SRC_URI += "file://usb-devices.cfg"
