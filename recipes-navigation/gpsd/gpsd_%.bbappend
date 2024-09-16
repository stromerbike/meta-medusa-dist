SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-gpsd-service.patch \
            file://0001-gpsdctl-output-info-instead-of-error-on-action.patch \
"

do_install:append:class-target() {
    ${STAGING_BINDIR_NATIVE}/python3-native/python3 -m compileall -b -s ${D} ${D}${PYTHON_SITEPACKAGES_DIR}/gps
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${libdir}/gps-*.egg-info
    rm -r ${D}${libdir}/gps
    rm -r ${D}${datadir}/gpsd
}
