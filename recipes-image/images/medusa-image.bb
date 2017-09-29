# Original recipe core-image-full-cmdline
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL = " \
                  packagegroup-core-boot \
                  ${CORE_IMAGE_EXTRA_INSTALL} \
"
inherit core-image

SUMMARY = ""
DESCRIPTION = "Medusa image"
LICENCE = "MIT"

# Added packets from manufacturer:
# barebox - bootloader
# dt-utils-barebox-state - linux packet for set/get shared barebox variables
# kernel-image - copy kernel into rootfs (boot directory)
# kernel-devicetree - copy dtb into rootfs (boot directory)
# minicom - communication program
# lrzsz - transfer files via minicom
# systemd-analyze - debug information collection
IMAGE_INSTALL_append = " barebox dt-utils-barebox-state kernel-image kernel-devicetree \
                         minicom lrzsz systemd-analyze \
"

# Added packets from Stromer:
# busybox - contains a lot of tools while maintining a small footprint
# tzdata - timezone database
# gnupg pristine-tar-fwu - firmware update
# gdbserver tcf-agent - low level debugging
# strace - debugging
# openssh openssh-sftp-server - ssh and sftp
# busybox can-utils dtc evtest fbtest gps-utils htop nano rsync tree - convenience and troubleshooting tools
# python python-argparse python-json - python and some often used modules
IMAGE_INSTALL_append = " medusa-version \
                         busybox \
                         tzdata \
                         gdbserver tcf-agent \
                         perf strace \
                         openssh openssh-sftp-server \
                         dnsmasq hostapd iw wpa-supplicant linux-firmware-rtl8192cu rfkill \
                         can-utils dtc fbtest gps-utils htop iperf nano python tree \
"

# Do not install any locales
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "tar tar.gz ubifs"
