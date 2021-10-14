SUMMARY = "Sierra Wireless HL78xx sft (standalone) firmwares"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \ 
            file://AppFW_flash.bin \
            file://package_version \
            file://partmap.bin \
            file://sft \
            file://SHA256SUMS \
            file://sysHeader.bin.alt1250 \
            file://sysHeader_backup.bin.alt1250 \
            file://sysHeader_modem.bin.alt1250 \
            file://u-boot.bin \
            file://ue_lte.fw2 \
            file://ue_lte_2g.fw \
"

FILES_${PN}_append = " ${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0/*"

do_install () {
    install -d ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/AppFW_flash.bin ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/package_version ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/partmap.bin ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0755 ${WORKDIR}/SHA256SUMS ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/sysHeader.bin.alt1250 ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/sysHeader_backup.bin.alt1250 ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/sysHeader_modem.bin.alt1250 ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/u-boot.bin ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/ue_lte.fw2 ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
    install -m 0644 ${WORKDIR}/ue_lte_2g.fw ${D}/${base_libdir}/firmware/sierra-wireless/HL7802.4.3.9.0
}
