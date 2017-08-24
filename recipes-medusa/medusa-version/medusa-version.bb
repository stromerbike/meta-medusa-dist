SUMMARY = "Stromer Medusa version"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PV = "${DISTRO_VERSION}"
PR = "${DISTRO_CODENAME}"
ERROR_QA_remove = "version-going-backwards"

do_install () {
    install -d ${D}${sysconfdir}
    "${DISTRO_CODENAME}-${DISTRO_VERSION}" > ${D}${sysconfdir}/medusa-version
}
