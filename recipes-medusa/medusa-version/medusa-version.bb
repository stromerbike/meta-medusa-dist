SUMMARY = "Stromer Medusa version"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PV = "${DISTRO_VERSION}"
PR = "${DISTRO_CODENAME}"
ERROR_QA_remove = "version-going-backwards"

do_install () {
    install -d ${D}${sysconfdir}
    echo "${DISTRO_CODENAME}-${DISTRO_VERSION}" > ${D}${sysconfdir}/medusa-version
}
