FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig.cfg \
            file://libbb-mark-scripted_main-as-externally-visible.patch \
"

SRC_URI_remove = "file://syslog.cfg"

RRECOMMENDS_${PN} = ""

INSANE_SKIP_${PN} += "already-stripped"

do_install_prepend () {
    if grep -q "CONFIG_FEATURE_INDIVIDUAL=y" ${B}/.config; then
        install -d ${D}${base_sbindir} ${D}${sbindir}
    fi
}
