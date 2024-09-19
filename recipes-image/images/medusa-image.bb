# Original recipe core-image-full-cmdline
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL = " \
                  packagegroup-core-boot \
                  ${CORE_IMAGE_EXTRA_INSTALL} \
"
inherit core-image python3-dir
inherit populate_sdk_qt5_base

SUMMARY = ""
DESCRIPTION = "Medusa image"
LICENSE = "MIT"

# Added packets from and for manufacturer:
# dt-utils-barebox-state - linux packet for set/get shared barebox variables
# kernel-image - copy kernel into rootfs (boot directory)
# kernel-devicetree - copy dtb into rootfs (boot directory)
# kernel-modules - copy kernel modules into rootfs (lib directory)
# openssh-sshd - ssh connection used during production
# iperf3 - used during production for bandwidth test
# medusa-version - used during production for obtaining version
IMAGE_INSTALL:append = " dt-utils-barebox-state \
                         kernel-image kernel-devicetree kernel-modules \
                         openssh-sshd \
                         iperf3 \
                         medusa-version \
"

# Added packets from Stromer:
# busybox - contains a lot of tools in a single executable or in very small binaries (depending on CONFIG_FEATURE_INDIVIDUAL) while providing a small footprint
# rsyslog - logging
# tzdata - timezone database
# systemd-analyze - debug information collection
# gdb ldd ltrace strace - debugging
# gdbserver tcf-agent - low level debugging
# openssh-scp openssh-sftp-server - scp and sftp
# hostapd linux-firmware-rtl8192cu wireless-regdb-static wpa-supplicant - wifi
# iproute2-ss ppp-tools socat tcpdump - networking tools
# fbgrab kmsgrab - screen capturing tools
IMAGE_INSTALL:append = " busybox \
                         rsyslog \
                         tzdata-core tzdata-misc tzdata-africa \
                         tzdata-americas tzdata-antarctica tzdata-arctic tzdata-asia \
                         tzdata-atlantic tzdata-australia tzdata-europe tzdata-pacific \
                         systemd-analyze \
                         gdb ldd ltrace strace \
                         gdbserver tcf-agent \
                         openssh-scp openssh-sftp-server \
                         hostapd linux-firmware-rtl8188 linux-firmware-rtl8192cu wireless-regdb-static wpa-supplicant \
                         iproute2-ss ppp-tools socat tcpdump \
                         fbgrab kmsgrab \
                         dtc interceptty interceptty-nicedump libgpiod-tools nano sudo-sudo \
"

# Optional packages useful for development:
# perf - debugging (pulls in slang for tui)
# hl78xx-sft hl78xx-firmware-sft - mobile communication module downgrade
#IMAGE_INSTALL:append = " perf"
#IMAGE_INSTALL:append = " hl78xx-sft hl78xx-firmware-sft"

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

# Ensure that qmake and protoc are part of the SDK
TOOLCHAIN_HOST_TASK:append = " nativesdk-packagegroup-qt5-toolchain-host nativesdk-protobuf-compiler"

# Ensure that gtest and mkspecs (for cortexa7hf-neon-vfpv4-oe-linux-gnueabi) are part of the SDK
TOOLCHAIN_TARGET_TASK:append = " googletest qtbase-mkspecs"
