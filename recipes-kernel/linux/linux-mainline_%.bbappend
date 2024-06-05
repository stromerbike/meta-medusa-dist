FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/imx/sdma/sdma-imx6q.bin?id=20230404;downloadfilename=sdma-imx6q.bin;name=sdma-imx6q.bin \
            file://gpiolib-sysfs.c.patch \
            file://SiseriffLTStd-Regular.otf \
"

SRC_URI[sdma-imx6q.bin.sha256sum] = "7790c161b7e013a9dbcbffb17cc5d4cb63d952949a505647e4679f02d04c4784"

do_patch:append() {
    # Remark: Use convert of host system, since native imagemagick is unable to open magic.xml (maybe because it is built using --without-xml)
    os.system('/usr/bin/convert {0} -dither None -colors 224 -compress none -font {1}/SiseriffLTStd-Regular.otf -pointsize 18 -fill {6} -gravity south -annotate +0+18 "{2}\\n{3}{5}\\n{4}" {0}.convert' \
              .format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm'), d.getVar('WORKDIR', True), \
                      d.getVar('DISTRO_CODENAME', True), d.getVar('DISTRO_VERSION', True).split('-')[4], '-'.join(d.getVar('DISTRO_VERSION', True).split('-')[0:4]), \
                      ' DIRTY' if d.getVar('DISTRO_VERSION', True).endswith('-DIRTY') else '', 'red' if d.getVar('DISTRO_VERSION', True).endswith('-DIRTY') else 'white'))
    # In some cases passing -colors 224 to convert does result in more than 224 colors
    os.system('/usr/bin/ppmquant 224 {0}.convert > {0}.quant'.format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm')))
    os.system('/usr/bin/pnmnoraw {0}.quant > {0}'.format(os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm')))
}

do_compile:prepend() {
    mkdir -p ${S}/linux-firmware/imx/sdma/
    cp -arv ${WORKDIR}/sdma-imx6q.bin ${S}/linux-firmware/imx/sdma/
}
