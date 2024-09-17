SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-gpsd-service.patch \
            file://0001-gpsdctl-output-info-instead-of-error-on-action.patch \
"

RDEPENDS:gps-utils = "gps-utils-cgps"
PACKAGES =+ "gps-utils-cgps"
FILES:gps-utils-cgps = "${bindir}/cgps"

RDEPENDS:gps-utils = "gps-utils-gpsmon"
PACKAGES =+ "gps-utils-gpsmon"
FILES:gps-utils-gpsmon = "${bindir}/gpsmon"

RDEPENDS:gps-utils = "gps-utils-gpspipe"
PACKAGES =+ "gps-utils-gpspipe"
FILES:gps-utils-gpspipe = "${bindir}/gpspipe"

do_install:append:class-target() {
    ${STAGING_BINDIR_NATIVE}/python3-native/python3 -m compileall -b -s ${D} ${D}${PYTHON_SITEPACKAGES_DIR}/gps
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${libdir}/gps-*.egg-info
    rm -r ${D}${libdir}/gps
    rm -r ${D}${datadir}/gpsd
}

RRECOMMENDS:gps-utils:remove = " gps-utils-python"
