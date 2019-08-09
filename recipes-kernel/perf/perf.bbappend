PACKAGECONFIG_remove += "scripting"

do_install_append() {
    rm -r ${D}/${sysconfdir}/bash_completion.d
}
