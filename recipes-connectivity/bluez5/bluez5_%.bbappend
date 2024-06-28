FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://bluetooth.service.in.patch \
            file://fix_coredump.patch \
            file://main.conf \
            file://TIInit_6.7.16.bts \
            file://TIInit_6.12.26.bts \
"

PACKAGECONFIG:remove = " \
    obex-profiles \
    a2dp-profiles \
    avrcp-profiles \
    hid-profiles \
    hog-profiles \
    udev \
"

PACKAGECONFIG[bap-profiles] = "--enable-bap,--disable-bap"
PACKAGECONFIG[bass-service] = "--enable-bass,--disable-bass"
PACKAGECONFIG[mcp-profiles] = "--enable-mcp,--disable-mcp"
PACKAGECONFIG[vcp-profiles] = "--enable-vcp,--disable-vcp"
PACKAGECONFIG[micp-profiles] = "--enable-micp,--disable-micp"
PACKAGECONFIG[csip-profiles] = "--enable-csip,--disable-csip"

NOINST_TOOLS_READLINE = " \
    tools/btmgmt \
"
NOINST_TOOLS_TESTING = ""
NOINST_TOOLS_BT  = ""

EXTRA_OECONF += "--localstatedir=/mnt/data/var"

FILES:${PN}:append = " ${base_libdir}/firmware/ti-connectivity/*.bts"

PACKAGES =+ "${PN}-misc"
FILES:${PN}-misc += " \
    ${bindir}/bccmd \
    ${bindir}/bluemoon \
    ${bindir}/ciptool \
    ${bindir}/mpris-proxy \
"

do_install:append() {
    install -d ${D}/${base_libdir}/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/TIInit_6.7.16.bts ${D}/${base_libdir}/firmware/ti-connectivity
    install -m 0644 ${WORKDIR}/TIInit_6.12.26.bts ${D}/${base_libdir}/firmware/ti-connectivity

    install -d ${D}/${sysconfdir}/bluetooth
    install -m 0644 ${WORKDIR}/main.conf ${D}/${sysconfdir}/bluetooth/
}
