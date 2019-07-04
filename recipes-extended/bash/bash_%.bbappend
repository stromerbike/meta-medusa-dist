FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://.bashrc \
            file://.profile \
"

RDEPENDS_${PN} += " ccze grep iptraf-ng lnav medusa-version systemd (>= 236)"

FILES_${PN}_append = " ${ROOT_HOME}"

do_install_append() {
    install -d ${D}${ROOT_HOME}
    install -m 0644 ${WORKDIR}/.bashrc ${D}${ROOT_HOME}/.bashrc
    install -m 0644 ${WORKDIR}/.profile ${D}${ROOT_HOME}/.profile
    ln -sf /mnt/data/.bash_history ${D}${ROOT_HOME}/.bash_history
}
