do_install_append() {
    echo "noccp" >> ${D}${sysconfdir}/ppp/options
}
