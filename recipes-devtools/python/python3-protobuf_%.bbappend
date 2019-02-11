FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-Add-Python-3.7-compatibility.patch \
"

DEPENDS = "protobuf python3 python3-setuptools-native"

RDEPENDS_${PN} += " python3-pickle"

DISTUTILS_BUILD_ARGS += "--cpp_implementation"
DISTUTILS_INSTALL_ARGS += "--cpp_implementation"
