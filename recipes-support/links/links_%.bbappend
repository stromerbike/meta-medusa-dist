FILES_${PN}_append = " ${ROOT_HOME}"

do_install_append () {
    install -d ${D}${ROOT_HOME}/.links
}
