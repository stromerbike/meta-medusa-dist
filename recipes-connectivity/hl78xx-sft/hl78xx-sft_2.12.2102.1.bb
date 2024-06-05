SUMMARY = "Sierra Wireless HL78xx standalone firmware upgrade tool sft"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \ 
            file://sft \
"

INSANE_SKIP:${PN} += "already-stripped"

do_install () {    
    install -d ${D}${bindir}
    install -m 755 ${WORKDIR}/sft ${D}${bindir}
}
