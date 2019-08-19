FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-Add-Python-3.7-compatibility.patch \
"

DEPENDS = "protobuf python3 python3-setuptools-native"

RDEPENDS_${PN} += " python3-pickle"

DISTUTILS_BUILD_ARGS += "--cpp_implementation"
DISTUTILS_INSTALL_ARGS += "--cpp_implementation"

export PYTHONDONTWRITEBYTECODE = "1"

do_install_append_class-target() {
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -m compileall -b ${D}${PYTHON_SITEPACKAGES_DIR}
    find ${D}${PYTHON_SITEPACKAGES_DIR} -name "*.py" -delete
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/protobuf-*.egg-info
}
