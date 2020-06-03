FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://bluetooth.service.in.patch \
            file://main.conf \
            file://TIInit_6.7.16.bts \
"

PACKAGECONFIG_remove = " \
    obex-profiles \
    a2dp-profiles \
    avrcp-profiles \
    hid-profiles \
    hog-profiles \
    udev \
"

NOINST_TOOLS_READLINE = " \
    tools/btmgmt \
"
NOINST_TOOLS_TESTING = ""
NOINST_TOOLS_BT  = ""

EXTRA_OECONF += "--localstatedir=/mnt/data/var"

FILES_${PN}_append = " ${base_libdir}/firmware/ti-connectivity/*.bts"

PACKAGES =+ "${PN}-misc"
FILES_${PN}-misc += " \
    ${bindir}/bccmd \
    ${bindir}/bluemoon \
    ${bindir}/ciptool \
    ${bindir}/mpris-proxy \
"

do_install_append() {
    install -d ${D}/${base_libdir}/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/TIInit_6.7.16.bts ${D}/${base_libdir}/firmware/ti-connectivity

    install -m 0644 ${WORKDIR}/main.conf ${D}/${sysconfdir}/bluetooth/
}
