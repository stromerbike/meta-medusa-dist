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
# openssh-sshd - ssh connection used during production
# bluez-tools - bt-adapter used during production for obtaining MAC
# iperf3 - used during production for bandwidth test
# medusa-version - used during production for obtaining version
IMAGE_INSTALL_append = " barebox dt-utils-barebox-state \
                         kernel-image kernel-devicetree \
                         openssh-sshd \
                         bluez-tools \
                         iperf3 \
                         medusa-version \
"

# Added packets from Stromer:
# busybox - contains a lot of tools in a single executable or in very small binaries (depending on CONFIG_FEATURE_INDIVIDUAL) while providing a small footprint
# tzdata - timezone database
# acl fuse-exfat - extended filesystem support
# systemd-analyze - debug information collection
# gdb ltrace perf strace - debugging
# gdbserver tcf-agent - low level debugging
# openssh-scp openssh-sftp-server - scp and sftp
# iftop iproute2-ss ppp-tools socat tcpdump - networking tools
IMAGE_INSTALL_append = " busybox \
                         tzdata tzdata-misc tzdata-africa tzdata-americas tzdata-antarctica tzdata-arctic tzdata-asia tzdata-atlantic tzdata-australia tzdata-europe tzdata-pacific \
                         acl fuse-exfat \
                         systemd-analyze \
                         gdb ltrace perf strace \
                         gdbserver tcf-agent \
                         openssh-scp openssh-sftp-server \
                         iftop iproute2-ss ppp-tools socat tcpdump \
                         bbu dtc fbgrab fbtest glibc-utils htop less lsof memtester mtd-utils-tests nano ncurses-tools nmon procps screen sudo systemd-extra-utils systemd-journal-upload tree tzcode \
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
