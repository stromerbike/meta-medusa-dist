do_install_append() {
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/haversine-*.egg-info
}
