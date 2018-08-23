FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += " ccze grep iptraf-ng lnav medusa-version systemd (>= 236)"
