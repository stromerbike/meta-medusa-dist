FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += " ccze curl grep iptraf-ng lnav medusa-version systemd (>= 236) wget"
