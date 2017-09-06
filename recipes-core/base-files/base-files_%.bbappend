FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

FILES_${PN}_append = " /mnt/"

do_install_append() {
    # required for read-only-rootfs
    install -d ${D}/mnt/sda
    install -d ${D}/mnt/sda1
}
