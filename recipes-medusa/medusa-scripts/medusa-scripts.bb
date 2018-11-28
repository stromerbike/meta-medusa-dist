SUMMARY = "Stromer Medusa scripts"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

RDEPENDS_${PN} = "bash"
RRECOMMENDS_${PN} = "dt-utils-barebox-state"

SRC_URI += " \
            file://hostname.sh \
"

FILES_${PN}_append = " \
    ${sysconfdir}/scripts/ \
"

do_install () {
    install -d ${D}${sysconfdir}/scripts
    install -m 0755 ${WORKDIR}/hostname.sh ${D}${sysconfdir}/scripts/
}
