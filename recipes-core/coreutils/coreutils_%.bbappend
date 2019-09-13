bindir_progs_remove += "link nice printenv"
ALTERNATIVE_${PN} += "link nice printenv"
ALTERNATIVE_${PN}-doc += "link.1 nice.1 printenv.1"

do_install_append() {
    for i in link nice printenv; do mv ${D}${bindir}/$i ${D}${bindir}/$i.${BPN}; done
}

ALTERNATIVE_LINK_NAME[link] = "${bindir}/link"
ALTERNATIVE_TARGET[link] = "${bindir}/link.${BPN}"
ALTERNATIVE_LINK_NAME[link.1] = "${mandir}/man1/link.1"

ALTERNATIVE_LINK_NAME[nice] = "${base_bindir}/nice"
ALTERNATIVE_TARGET[nice] = "${bindir}/nice.${BPN}"
ALTERNATIVE_LINK_NAME[nice.1] = "${mandir}/man1/nice.1"

ALTERNATIVE_LINK_NAME[printenv] = "${base_bindir}/printenv"
ALTERNATIVE_TARGET[printenv] = "${bindir}/printenv.${BPN}"
ALTERNATIVE_LINK_NAME[printenv.1] = "${mandir}/man1/printenv.1"
