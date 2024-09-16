PACKAGECONFIG:remove = " scripting"

do_install:append() {
    rm -r ${D}/${sysconfdir}/bash_completion.d
}

# trace command not available: missing audit-libs devel package at build time.
PACKAGES =+ "trace"
FILES:trace = "${bindir}/trace"
