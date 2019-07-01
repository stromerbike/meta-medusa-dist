do_install_append() {
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/pyserial-*.egg-info
}
