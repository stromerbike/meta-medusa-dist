# Original recipe core-image-full-cmdline
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL = " \
                  packagegroup-core-boot \
                  ${CORE_IMAGE_EXTRA_INSTALL} \
"
inherit core-image python3-dir

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
# acl fuse-exfat ntfs-3g - extended filesystem support
# systemd-analyze - debug information collection
# gdb ltrace perf strace - debugging
# gdbserver tcf-agent - low level debugging
# openssh-scp openssh-sftp-server - scp and sftp
# hostapd linux-firmware-rtl8192cu - wifi
# bind-utils iftop iproute2-ss iputils nmap ppp-tools socat tcpdump - networking tools
IMAGE_INSTALL_append = " busybox \
                         tzdata tzdata-misc tzdata-africa tzdata-americas tzdata-antarctica tzdata-arctic tzdata-asia tzdata-atlantic tzdata-australia tzdata-europe tzdata-pacific \
                         acl fuse-exfat ntfs-3g \
                         systemd-analyze \
                         gdb ltrace perf strace \
                         gdbserver tcf-agent \
                         openssh-scp openssh-sftp-server \
                         hostapd linux-firmware-rtl8192cu \
                         bind-utils iftop iproute2-ss iputils nmap ppp-tools socat tcpdump \
                         bbu dtc fbgrab fbtest glibc-utils htop interceptty less lsof memtester mtd-utils-tests nano ncurses-tools nmon rsyslog sudo systemd-extra-utils systemd-journal-upload \
"

# Revert installation of links in update-alternative scheme due to the following reasons:
# - In a non-interactively used system, there is no use of having alternatives since the
#   alternative with the highest priority will be used and all other alternatives are not.
# - The update-alternative scheme creates symlinks and thus increases the amount of files in the image.
#   Having more files in the images increases the time required to perform the installation of the image.
# Remark: Doing this as ROOTFS_POSTPROCESS_COMMAND to avoid having influence on the SDK.
resolve_symlinks_to_busybox() {
    cat ${IMAGE_ROOTFS}/etc/busybox.links | while read FILE; do
        # keep update-alternatives install scheme for
        # passwd and chpasswd to avoid conflicts with shadow
        if [ "$FILE" != "/usr/bin/passwd" ] && [ "$FILE" != "/usr/sbin/chpasswd" ]; then
            if [ -f ${IMAGE_ROOTFS}$FILE.busybox ]; then
                mv ${IMAGE_ROOTFS}$FILE.busybox ${IMAGE_ROOTFS}$FILE
            fi
        fi
    done
}
ROOTFS_POSTPROCESS_COMMAND += "resolve_symlinks_to_busybox; "

# Remove leftover files from python3.
remove_development_files() {
    rm -r ${IMAGE_ROOTFS}${libdir}/${PYTHON_DIR}/config-*
    rm -r ${IMAGE_ROOTFS}${includedir}
}
ROOTFS_POSTPROCESS_COMMAND += "remove_development_files; "

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
