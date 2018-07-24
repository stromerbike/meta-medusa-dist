FILES_${PN}_append = " ${ROOT_HOME}"

do_install_append () {
    install -d ${D}${ROOT_HOME}
    echo interface: ppp0 >> ${D}${ROOT_HOME}/.iftoprc
    echo dns-resolution: no >> ${D}${ROOT_HOME}/.iftoprc
    echo port-display: on >> ${D}${ROOT_HOME}/.iftoprc
    echo use-bytes: yes >> ${D}${ROOT_HOME}/.iftoprc
    echo show-totals: yes >> ${D}${ROOT_HOME}/.iftoprc
}
