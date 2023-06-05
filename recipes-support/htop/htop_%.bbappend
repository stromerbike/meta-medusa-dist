FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://remove-desktop-file-and-icon.patch \
"

PACKAGECONFIG:remove = " delayacct"

# TODO: still required with patch?
FILES:${PN}:remove = " ${datadir}/icons/hicolor/scalable/apps/htop.svg"
