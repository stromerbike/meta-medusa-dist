DEPENDS = "protobuf python3 python3-setuptools-native"

RDEPENDS_${PN} += " python3-pickle"

DISTUTILS_BUILD_ARGS += "--cpp_implementation"
DISTUTILS_INSTALL_ARGS += "--cpp_implementation"
