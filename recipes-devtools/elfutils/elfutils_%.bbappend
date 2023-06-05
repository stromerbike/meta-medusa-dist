ALLOW_EMPTY:${PN} = "1"

FILES:${PN}-binutils += "\
    ${bindir}/eu-ar \
    ${bindir}/eu-elfcmp \
    ${bindir}/eu-elfcompress \
    ${bindir}/eu-elflint \
    ${bindir}/eu-findtextrel \
    ${bindir}/eu-make-debug-archive \
    ${bindir}/eu-ranlib \
    ${bindir}/eu-stack \
    ${bindir}/eu-strings \
    ${bindir}/eu-unstrip"

#do_install:append:class-target() {
#    find ${D}${libdir}/${BPN}/ -type f,l -not -name '*arm*' -delete
#}
