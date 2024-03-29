SUMMARY = "Sierra Wireless HL78xx XMODEM (delta) firmwares"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RRECOMMENDS_${PN} = "lrzsz"

SRC_URI = " \ 
            file://*.ua \
            file://SHA256SUMS \
"

FILES_${PN}_append = " ${base_libdir}/firmware/sierra-wireless/*"

do_install () {
    install -d ${D}/${base_libdir}/firmware/sierra-wireless
    install -m 0644 ${WORKDIR}/SHA256SUMS ${D}/${base_libdir}/firmware/sierra-wireless
    for file in $(find ${WORKDIR} -maxdepth 1 -type f -name "*.ua"); do
        install -m 0644 "$file" ${D}/${base_libdir}/firmware/sierra-wireless
    done
}
