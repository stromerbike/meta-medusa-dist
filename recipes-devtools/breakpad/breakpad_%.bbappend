PACKAGES =+ "${PN}-extra"
FILES:${PN}-extra = "\
                     ${bindir}/core2md \
                     ${bindir}/dump_syms \
                     ${bindir}/microdump_stackwalk \
                     ${bindir}/minidump-2-core \
                     ${bindir}/minidump_dump \
                     ${bindir}/pid2md \
"
