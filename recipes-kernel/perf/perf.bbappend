PACKAGECONFIG:remove = " scripting"

do_install:append() {
    rm -r ${D}/${sysconfdir}/bash_completion.d
}
