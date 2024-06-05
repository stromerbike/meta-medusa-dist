SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://gpsd.service.patch \
            file://gpsdctl-output-info-instead-of-error-on-action.patch \
"

do_install:append:class-target() {
    ${STAGING_BINDIR_NATIVE}/python3-native/python3 -m compileall -b ${D}${PYTHON_SITEPACKAGES_DIR}/gps
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${libdir}/gps-*.egg-info
}
