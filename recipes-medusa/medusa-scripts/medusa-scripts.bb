SUMMARY = "Stromer Medusa scripts"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PV = "${DISTRO_VERSION}"
PR = "${DISTRO_CODENAME}"
ERROR_QA_remove = "version-going-backwards"

RDEPENDS_${PN} = "bash"

SRC_URI += " \
            file://switch-rfs.sh \
"

FILES_${PN}_append = " \
    ${sysconfdir}/scripts/ \
"

do_install () {    
    install -d ${D}${sysconfdir}/scripts
    install -m 0755 ${WORKDIR}/switch-rfs.sh ${D}${sysconfdir}/scripts/
}
