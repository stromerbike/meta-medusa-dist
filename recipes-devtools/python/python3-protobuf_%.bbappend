FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-Add-Python-3.7-compatibility.patch \
"

DEPENDS = "protobuf python3 python3-setuptools-native"

RDEPENDS_${PN} += " python3-pickle"

DISTUTILS_BUILD_ARGS += "--cpp_implementation"
DISTUTILS_INSTALL_ARGS += "--cpp_implementation"

do_install_append() {
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -O -m compileall ${D}${PYTHON_SITEPACKAGES_DIR}/google/protobuf
    ${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} -OO -m compileall ${D}${PYTHON_SITEPACKAGES_DIR}/google/protobuf
}
