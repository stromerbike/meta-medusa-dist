do_install:append() {
    rm -r ${D}${datadir}/libinput
    rm ${D}${libexecdir}/libinput/*
}
