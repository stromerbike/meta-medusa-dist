FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://defconfig.cfg \
"

SRC_URI_remove = "file://syslog.cfg"

RRECOMMENDS_${PN} = ""

INSANE_SKIP_${PN} += "already-stripped"

do_install_append () {
    if grep -q "CONFIG_FEATURE_INDIVIDUAL=y" ${B}/.config; then
        # Revert installation of links in update-alternative scheme due to the following reasons:
        # - In a non-interactively used system, there is no use of having alternatives since the
        #   alternative with the highest priority will be used and all other alternatives are not.
        # - The update-alternative scheme creates symlinks and thus increases the amount of files in the image.
        #   Having more files in the images increases the time required to perform the installation of the image.
        cat busybox.links | while read FILE; do
            if [ -f ${D}$FILE.${BPN} ]; then
                mv ${D}$FILE.${BPN} ${D}$FILE
            fi
		done

        # keep update-alternatives install scheme for
        # passwd and chpasswd to avoid conflicts with shadow
        echo "/usr/bin/passwd" > ${D}${sysconfdir}/busybox.links
        echo "/usr/sbin/chpasswd" >> ${D}${sysconfdir}/busybox.links

        # use update-alternatives install scheme for busybox timeout to make it
        # distinguishable from coreutils timeout since it has an other syntax
        echo "/usr/bin/timeout" >> ${D}${sysconfdir}/busybox.links
    fi
}
