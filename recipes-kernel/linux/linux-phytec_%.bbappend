FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "imagemagick-native python3-pillow-native"

SRC_URI += " \
            https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/imx/sdma/sdma-imx6q.bin?id=20230404;downloadfilename=sdma-imx6q.bin;name=sdma-imx6q.bin \
            file://0001-print-warning-as-info-in-gpiolib-sysfs.c.patch \
            file://SiseriffLTStd-Regular.otf \
"

SRC_URI[sdma-imx6q.bin.sha256sum] = "7790c161b7e013a9dbcbffb17cc5d4cb63d952949a505647e4679f02d04c4784"

do_postprocess_logo() {  
export LOGO_PATH="${STAGING_KERNEL_DIR}/drivers/video/logo/logo_stromer_clut224.ppm"
nativepython3 <<EOF
import os
from PIL import Image
# Limit colors to 224, convert to RGB and save as ASCII PPM (P3)
logo_rgb = Image.open(os.environ.get('LOGO_PATH')).quantize(colors=224).convert("RGB")
with open(os.environ.get('LOGO_PATH'), 'w') as f:
    f.write(f"P3\n{logo_rgb.width} {logo_rgb.height}\n255\n")
    for y in range(logo_rgb.height):
        for x in range(logo_rgb.width):
            r, g, b = logo_rgb.getpixel((x, y))
            f.write(f"{r} {g} {b} ")
        f.write("\n")
EOF
}

python do_process_logo() {
    os.system('{0} {1} -dither None -colors 224 -compress none -font {2}/SiseriffLTStd-Regular.otf -pointsize 18 -fill {7} -gravity south -annotate +0+18 "{3}\\n{4}{6}\\n{5}" {1}' \
              .format(d.getVar('STAGING_BINDIR_NATIVE', True) + "/convert.im7", os.path.join(d.getVar('STAGING_KERNEL_DIR', True), 'drivers' , 'video', 'logo', 'logo_stromer_clut224.ppm'), \
                      d.getVar('WORKDIR', True), d.getVar('DISTRO_CODENAME', True), d.getVar('DISTRO_VERSION', True).split('-')[4], '-'.join(d.getVar('DISTRO_VERSION', True).split('-')[0:4]), \
                      ' DIRTY' if d.getVar('DISTRO_VERSION', True).endswith('-DIRTY') else '', 'red' if d.getVar('DISTRO_VERSION', True).endswith('-DIRTY') else 'white'))
    bb.build.exec_func('do_postprocess_logo', d)
}

addtask process_logo after do_patch do_prepare_recipe_sysroot before do_compile

do_compile:prepend() {
    mkdir -p ${S}/linux-firmware/imx/sdma/
    cp -arv ${WORKDIR}/sdma-imx6q.bin ${S}/linux-firmware/imx/sdma/
}
