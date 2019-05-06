FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://can-devices.cfg \
            file://cgroup.cfg \
            file://CVE-2017-1000251.patch \
            file://filesystems.cfg \
            file://network.cfg \
            file://SiseriffLTStd-Regular.otf \
            file://usb-devices.cfg \
            file://virtual-devices.cfg \
            file://wifi-devices.cfg \
"

do_patch_append() {
    # Remark: Use convert of host system, since native imagemagick is unable to open magic.xml (maybe because it is built using --without-xml)
    os.system('/usr/bin/convert {0} -dither None -colors 224 -compress none -font {1}/SiseriffLTStd-Regular.otf -pointsize 16 -fill {5} -gravity south -annotate +0+16 "{2}-{3}{4}" {0}.convert'\
              .format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm'), d.getVar('WORKDIR', True), \
                      d.getVar('DISTRO_CODENAME', True), d.getVar('DISTRO_VERSION', True).split('-')[4], \
                      '-DIRTY' if d.getVar('DISTRO_VERSION', True).endswith('-DIRTY') else '', 'red' if d.getVar('DISTRO_VERSION', True).endswith('-DIRTY') else 'white'))
    # In some cases passing -colors 224 to convert does result in more than 224 colors
    os.system('/usr/bin/ppmquant 224 {0}.convert > {0}.quant'.format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm')))
    os.system('/usr/bin/pnmnoraw {0}.quant > {0}'.format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm')))
}
