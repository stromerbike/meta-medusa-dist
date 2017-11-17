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
# busybox - contains a lot of tools in a single executable while providing a small footprint
# coreutils util-linux - contains a lot of tools in separate small executables while providing fast execution time
# tzdata - timezone database
# gnupg pristine-tar-fwu - firmware update
# gdbserver tcf-agent - low level debugging
# perf strace - debugging
# openssh openssh-sftp-server - ssh and sftp
IMAGE_INSTALL_append = " busybox \
                         coreutils util-linux \
                         tzdata \
                         gdbserver tcf-agent \
                         perf strace \
                         openssh openssh-sftp-server \
                         dnsmasq hostapd iw wpa-supplicant linux-firmware-rtl8192cu rfkill \
                         can-utils dtc fbgrab fbtest gps-utils htop iperf3 nano procps python screen tree \
"

# Do not install any locales
IMAGE_LINGUAS = ""

# Define desired image types and select best compression
IMAGE_FSTYPES = "tar tar.gz tar.xz ubifs"
XZ_COMPRESSION_LEVEL = "-9"

# Ensure the member ordering in the created archive is uniform and reproducible (required for creating small delta updates)
IMAGE_CMD_TAR = "tar --sort=name"
