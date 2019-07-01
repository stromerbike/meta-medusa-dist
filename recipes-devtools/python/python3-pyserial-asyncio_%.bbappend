do_install_append() {
    rm -r ${D}${PYTHON_SITEPACKAGES_DIR}/pyserial_asyncio-*.egg-info
}
