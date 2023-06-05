bindir_progs:remove = " link"
ALTERNATIVE:${PN} += "link"
ALTERNATIVE:${PN}-doc += "link.1"

do_install:append() {
    for i in link; do mv ${D}${bindir}/$i ${D}${bindir}/$i.${BPN}; done
}

ALTERNATIVE_LINK_NAME[link] = "${bindir}/link"
ALTERNATIVE_TARGET[link] = "${bindir}/link.${BPN}"
ALTERNATIVE_LINK_NAME[link.1] = "${mandir}/man1/link.1"
