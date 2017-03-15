FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://.bashrc \
"

FILES_${PN}_append = " /home/root/"

do_install_append() {
    install -d ${D}/home/root
    install -m 0644 ${WORKDIR}/.bashrc ${D}/home/root/.bashrc
}
