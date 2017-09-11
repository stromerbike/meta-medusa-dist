PACKAGECONFIG_append = " libinput"
PACKAGECONFIG_DEFAULT = "udev widgets libs"

QT_QPA_DEFAULT_PLATFORM ??= "eglfs"

# Set default QT_QPA_PLATFORM for all phytec boards
do_configure_prepend() {
        # adapt qmake.conf to our needs
        sed -i 's!load(qt_config)!!' ${S}/mkspecs/linux-oe-g++/qmake.conf

        # Insert QT_QPA_PLATFORM into qmake.conf
        cat >> ${S}/mkspecs/linux-oe-g++/qmake.conf <<EOF

QT_QPA_DEFAULT_PLATFORM = ${QT_QPA_DEFAULT_PLATFORM}

load(qt_config)

EOF
}
