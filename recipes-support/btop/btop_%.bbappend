FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://remove-installation-to-share.patch \
"

FILES:${PN}:append = " ${ROOT_HOME}"

do_install:append() {
    install -d ${D}${ROOT_HOME}/.config/btop
    echo net_iface = \"ppp0\" >> ${D}${ROOT_HOME}/.config/btop/btop.conf
}
