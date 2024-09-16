ALLOW_EMPTY:${PN} = "1"

FILES:${PN}-binutils += "\
    ${bindir}/eu-ar \
    ${bindir}/eu-elfclassify \
    ${bindir}/eu-elfcmp \
    ${bindir}/eu-elfcompress \
    ${bindir}/eu-elflint \
    ${bindir}/eu-findtextrel \
    ${bindir}/eu-make-debug-archive \
    ${bindir}/eu-objdump \
    ${bindir}/eu-ranlib \
    ${bindir}/eu-srcfiles \
    ${bindir}/eu-stack \
    ${bindir}/eu-strings \
    ${bindir}/eu-unstrip"
