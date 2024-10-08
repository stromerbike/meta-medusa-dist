SUMMARY = "Stromer Medusa scripts"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

RDEPENDS:${PN} = "bash bluez5 dt-utils-barebox-state python3-core python3-json"
RRECOMMENDS:${PN} = "hl78xx-firmware-xmodem"
RSUGGESTS:${PN} = "hl78xx-firmware-sft hl78xx-sft"

SRC_URI += " \
            file://ble-revision.sh \
            file://hl78xx-update.sh \
            file://hl78xx-update-check.sh \
            file://hl78xx-update-revert.sh \
            file://hl78xx-usbcomp.sh \
            file://hl78xx-usbcomp-revert.sh \
            file://hlxxxx-common.sh \
            file://hostname.sh \
            file://systemd-journald-json-decode-ansi-escape.py \
"

FILES:${PN}:append = " \
    ${sysconfdir}/scripts/ \
"

do_install() {
    install -d ${D}${sysconfdir}/scripts
    install -m 0755 ${WORKDIR}/ble-revision.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hl78xx-update.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hl78xx-update-check.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hl78xx-update-revert.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hl78xx-usbcomp.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hl78xx-usbcomp-revert.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hlxxxx-common.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/hostname.sh ${D}${sysconfdir}/scripts/
    install -m 0755 ${WORKDIR}/systemd-journald-json-decode-ansi-escape.py ${D}${sysconfdir}/scripts/
}
