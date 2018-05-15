FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://cgroup.cfg \
            file://CVE-2017-1000251.patch \
            file://filesystems.cfg \
            file://i2c-devices.cfg \
            file://jtag-pm.patch \
            file://pca953x_irq.patch \
            file://ppp-network.cfg \
            file://SiseriffLTStd-Regular.otf \
            file://usb-devices.cfg \
            file://virtual-devices.cfg \
            file://wifi-devices.cfg \
"

KERNEL_MODULE_PROBECONF += " gpio-pca953x"
module_conf_gpio-pca953x = "blacklist gpio-pca953x"

do_patch_append() {
    # Remark: Use convert of host system, since native imagemagick is unable to open magic.xml (maybe because it is built using --without-xml)
    os.system('/usr/bin/convert {0} -dither None -colors 224 -compress none -font {1}/SiseriffLTStd-Regular.otf -pointsize 16 -fill white -gravity south -annotate +0+16 "{2}-{3}" {0}'\
              .format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm'), d.getVar('WORKDIR', True), \
                      d.getVar('DISTRO_CODENAME', True), d.getVar('DISTRO_VERSION', True).split('-')[4]))
}
