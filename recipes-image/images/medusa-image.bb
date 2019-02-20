# Original recipe core-image-full-cmdline
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL = " \
                  packagegroup-core-boot \
                  ${CORE_IMAGE_EXTRA_INSTALL} \
"
inherit core-image

SUMMARY = ""
DESCRIPTION = "Medusa image"
LICENSE = "MIT"

# Added packets from and for manufacturer:
# barebox - bootloader
# dt-utils-barebox-state - linux packet for set/get shared barebox variables
# kernel-image - copy kernel into rootfs (boot directory)
# kernel-devicetree - copy dtb into rootfs (boot directory)
# systemd-analyze - debug information collection
# iperf3 - used during production for bandwidth test
# medusa-version - used during production for optaining version
IMAGE_INSTALL_append = " barebox dt-utils-barebox-state \
                         kernel-image kernel-devicetree \
                         systemd-analyze \
                         iperf3 \
                         medusa-version \
"

# Added packets from Stromer:
# bareboximd - tool for reading out bootloader version information from within userspace
# busybox - contains a lot of tools in a single executable or in very small binaries (depending on CONFIG_FEATURE_INDIVIDUAL) while providing a small footprint
# coreutils util-linux - contains a lot of tools in separate small executables while providing fast execution time
# tzdata - timezone database
# gdbserver tcf-agent - low level debugging
# gdb perf strace - debugging
# openssh openssh-sftp-server - ssh and sftp
IMAGE_INSTALL_append = " \
                         bareboximd \
                         busybox \
                         coreutils util-linux \
                         tzdata tzdata-misc tzdata-posix tzdata-right tzdata-africa tzdata-americas tzdata-antarctica tzdata-arctic tzdata-asia tzdata-atlantic tzdata-australia tzdata-europe tzdata-pacific \
                         gdbserver tcf-agent \
                         gdb perf strace \
                         openssh openssh-sftp-server \
                         python3-requests-lite python3-urllib3-lite \
                         bridge-utils dnsmasq hostapd iw wpa-supplicant linux-firmware-rtl8192cu rfkill \
                         acl bluez-tools can-utils dtc fbgrab fbset fbtest glibc-utils gps-utils htop iftop iproute2-ss less lsof memtester mtd-utils-tests nano ncurses-tools nmon ppp-tools procps screen socat systemd-extra-utils tree \
"

# Define locales to be installed
IMAGE_LINGUAS = "en-us"

# Define desired image types and select best compression
IMAGE_FSTYPES = "tar tar.xz ubifs"
XZ_COMPRESSION_LEVEL = "-9"

# Ensure the member ordering in the created archive is uniform and reproducible (required for creating small delta updates)
IMAGE_CMD_TAR = "tar --sort=name"

# Create debug file system
#IMAGE_GEN_DEBUGFS = "1"
#IMAGE_FSTYPES_DEBUGFS = "tar.xz"
