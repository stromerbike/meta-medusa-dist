FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://remove-installation-to-share.patch \
"

FILES:${PN}:append = " \
                       ${ROOT_HOME} \
                       /home/user/.config/btop/btop.conf \
"

do_install:append() {
    install -d ${D}${ROOT_HOME}/.config/btop
    echo disks_filter = \"/ /tmp /mnt/rfs_inactive /mnt/data /mnt/log /mnt/usb\" >> ${D}${ROOT_HOME}/.config/btop/btop.conf
    echo only_physical = False >> ${D}${ROOT_HOME}/.config/btop/btop.conf
    echo use_fstab = False >> ${D}${ROOT_HOME}/.config/btop/btop.conf
    echo net_iface = \"ppp0\" >> ${D}${ROOT_HOME}/.config/btop/btop.conf

    install -d ${D}/home/user/.config/btop
    echo disks_filter = \"/ /tmp /mnt/rfs_inactive /mnt/data /mnt/log /mnt/usb\" >> ${D}/home/user/.config/btop/btop.conf
    echo only_physical = False >> ${D}/home/user/.config/btop/btop.conf
    echo use_fstab = False >> ${D}/home/user/.config/btop/btop.conf
    echo net_iface = \"ppp0\" >> ${D}/home/user/.config/btop/btop.conf
}
