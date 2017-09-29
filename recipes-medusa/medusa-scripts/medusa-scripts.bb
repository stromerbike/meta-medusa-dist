SUMMARY = "Stromer Medusa scripts"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

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
