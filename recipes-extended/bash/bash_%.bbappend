FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://.bashrc \
            file://.profile \
"

RDEPENDS_${PN} += " grep"

FILES_${PN}_append = " /home/root/"

do_install_append() {
    install -d ${D}/home/root
    install -m 0644 ${WORKDIR}/.bashrc ${D}/home/root/.bashrc
    install -m 0644 ${WORKDIR}/.profile ${D}/home/root/.profile
}
