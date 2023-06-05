FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://.bashrc \
            file://.bashrc_user \
            file://.profile \
"

RDEPENDS:${PN} += " ccze curl grep iptraf-ng lnav medusa-version systemd wget"

FILES:${PN}:append = " \
                      ${ROOT_HOME} \
                      /home/user/.bashrc \
                      /home/user/.profile \
"

do_install:append() {
    install -d ${D}${ROOT_HOME}
    install -m 0644 ${WORKDIR}/.bashrc ${D}${ROOT_HOME}/.bashrc
    install -m 0644 ${WORKDIR}/.profile ${D}${ROOT_HOME}/.profile
    ln -sf /mnt/data/.bash_history ${D}${ROOT_HOME}/.bash_history

    install -d ${D}/home/user/
    install -m 0644 ${WORKDIR}/.bashrc_user ${D}/home/user/.bashrc
    install -m 0644 ${WORKDIR}/.profile ${D}/home/user/.profile
}
