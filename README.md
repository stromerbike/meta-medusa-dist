This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Modifications:
- linux-common.inc: added DATETIME to vardepsexclude for KERNEL_IMAGE_BASE_NAME
- python3_3.7.2: Added python3-manifest-with-additions.json for defining more fine grained packages than python3-misc does. Also adopted paths for pyc only distribution.

Patches:
- [CVE-2017-1000251 (BlueBorne)](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e860d2c904d1a9f38a24eb44c9f34b8f915a6ea3)
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)
- [systemd /etc/localtime symlinks chasing](https://github.com/tramseyer/meta-medusa-dist/tree/master/recipes-core/systemd/systemd/chase_symlinks_etc_localtime.patch)

Fixed recipe version:
- [sumo: dt-utils 2016.08.0](https://github.com/PHYTEC-Messtechnik-GmbH/meta-phytec/commit/bd856199aaf116e828e354152f496344d26d25dd)
- [morty: linux-mainline 4.12.4-phy4](https://github.com/PHYTEC-Messtechnik-GmbH/meta-phytec/commit/c2cf1befc68f43dc06f2497fb09e450634c341fa)
- [rocko: tar 1.29](https://github.com/kraj/poky/commit/a38ab4ddb786b4d692d4ae891144da576cc190e3)

Busybox configuration (1.27.2):
- git clone https://github.com/mirror/busybox.git && cd busybox && git reset --hard 1_27_2 && make defconfig && make menuconfig
- set "Busybox Settings ---> Build shared libbusybox" to Y; Remark: Small binaries result in faster startup time.
- set "Busybox Settings ---> Include busybox applet" to N; Remark: Not needed.
- set "Busybox Library Tuning ---> Enable locale support (system needs locale for this to work)" to y.
- set "Busybox Library Tuning ---> Use libc routines for Unicode (else uses internal ones)" to y.
- set "Busybox Library Tuning ---> Range of supported Unicode characters" to 1114111.
- set "Busybox Library Tuning ---> Allow zero-width Unicode characters on output" to y.
- set "Busybox Library Tuning ---> Allow wide Unicode characters on output" to y.
- set "Archival Utilities ---> unlzma" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> lzcat" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> lzma -d" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> unxz" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> xzcat" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> xz -d" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> tar" to N; Remark: Not needed with tar.
- set "Archival Utilities ---> tar Support old tar header format" to N;
- set "Archival Utilities ---> tar Enable untarring of tarballs with checksums produced by buggy Sun tar" to N;
- set "Archival Utilities ---> tar Support GNU tar extensions (long filenames)" to N;
- set "Coreutils ---> groups" to N; Remark: Not needed with shadow-base.
- set "Console Utilities ---> clear" to N; Remark: Not needed with ncurses-tools.
- set "Console Utilities ---> reset" to N; Remark: Not needed with ncurses-tools.
- set "Finding Utilities  ---> grep" to N; Remark: Not needed with grep.
- set "Finding Utilities  ---> egrep" to N; Remark: Not needed with grep.
- set "Finding Utilities  ---> fgrep" to N; Remark: Not needed with grep.
- set "Init Utilities ---> bootchartd" to N; Remark: Not needed with systemd.
- set "Init Utilities ---> halt" to N; Remark: Not needed with systemd.
- set "Init Utilities ---> poweroff" to N; Remark: Not needed with systemd.
- set "Init Utilities ---> reboot" to N; Remark: Not needed with systemd.
- set "Init Utilities ---> init" to N; Remark: To avoid conflicts with systemd's runlevel.
- set "Init Utilities ---> linuxrc" to N; Remark: Not needed with systemd.
- set "Login/Password Management Utilities ---> getty" to N; Remark: Not needed with systemd/util-linux-agetty.
- set "Login/Password Management Utilities ---> login" to N; Remark: Not needed with shadow-base.
- set "Login/Password Management Utilities ---> su" to N; Remark: Not needed with shadow-base.
- set "Login/Password Management Utilities ---> sulogin" to N; Remark: Not needed with shadow-base/util-linux-sulogin.
- set "Linux Ext2 FS Progs ---> chattr" to N; Remark: Not needed.
- set "Linux Ext2 FS Progs ---> fsck" to N; Remark: Not needed.
- set "Linux Ext2 FS Progs ---> lsattr" to N; Remark: Not needed.
- set "Linux Module Utilities ---> depmod" to N; Remark: Not needed with systemd/kmod.
- set "Linux Module Utilities ---> insmod" to N; Remark: Not needed with systemd/kmod.
- set "Linux Module Utilities ---> lsmod" to N; Remark: Not needed with systemd/kmod.
- set "Linux Module Utilities ---> modinfo" to N; Remark: Not needed with systemd/kmod.
- set "Linux Module Utilities ---> modprobe" to N; Remark: Not needed with systemd/kmod.
- set "Linux Module Utilities ---> rmmod" to N; Remark: Not needed with systemd/kmod.
- set "Linux System Utilities ---> hwclock" to N; Remark: Not needed without RTC.
- set "Linux System Utilities ---> lspci" to N; Remark: Not needed without PCI.
- set "Linux System Utilities ---> mdev" to N; Remark: Not needed with systemd-udevd.
- set "Linux System Utilities ---> mke2fs" to N; Remark: Not needed.
- set "Linux System Utilities ---> mkfs.ext2" to N; Remark: Not needed.
- set "Linux System Utilities ---> mount" to N; Remark: Not needed with systemd/util-linux-mount.
- set "Linux System Utilities ---> rtcwake" to N; Remark: Not needed without RTC.
- set "Miscellaneous Utilities ---> beep" to N; Remark: Not needed without onboard speaker.
- set "Miscellaneous Utilities ---> chat" to N; Remark: To avoid conflicts with ppp.
- set "Miscellaneous Utilities ---> crond" to N; Remark: Not needed with systemd.
- set "Miscellaneous Utilities ---> crontab" to N; Remark: Not needed with systemd.
- set "Miscellaneous Utilities ---> fbsplash" to N; Remark: Not needed with fbv.
- set "Miscellaneous Utilities ---> inotifyd" to No; Remark: Not needed with inotify-tools.
- set "Miscellaneous Utilities ---> less" to No; Remark: Not needed with less.
- set "Miscellaneous Utilities ---> man" to No; Remark: Remark: Not needed.
- set "Miscellaneous Utilities ---> mt" to No; Remark: Remark: Not needed.
- set "Miscellaneous Utilities ---> nandwrite" to No; Remark: Not needed with mtd-utils-tests.
- set "Miscellaneous Utilities ---> nanddump" to No; Remark: Not needed with mtd-utils-tests.
- set "Miscellaneous Utilities ---> runlevel" to No; Remark: Not needed with systemd.
- set "Miscellaneous Utilities ---> watchdog" to No; Remark: Not needed with systemd.
- set "Networking Utilities ---> dnsd" to No; Remark: Not needed with systemd-resolved.
- set "Networking Utilities ---> httpd" to No; Remark: Not needed.
- set "Networking Utilities ---> ip" to No; Remark: Not needed with iproute2.
- set "Networking Utilities ---> ntpd" to No; Remark: Not needed with systemd-timesyncd.
- set "Networking Utilities ---> ssl_client" to No; Remark: Not needed (with openssl).
- set "Networking Utilities ---> wget" to No; Remark: Not needed with wget.
- set "Networking Utilities ---> udhcpd" to No; Remark: Not needed with systemd-networkd.
- set "Networking Utilities ---> udhcpc" to No; Remark: Not needed with systemd-networkd.
- set "Print Utilities ---> lpd" to No; Remark: Not needed.
- set "Print Utilities ---> lpr" to No; Remark: Not needed.
- set "Print Utilities ---> lpq" to No; Remark: Not needed.
- set "Mail Utilities ---> makemime" to No; Remark: Not needed.
- set "Mail Utilities ---> popmaildir" to No; Remark: Not needed.
- set "Mail Utilities ---> reformime" to No; Remark: Not needed.
- set "Mail Utilities ---> sendmail" to No; Remark: Not needed.
- set "Process Utilities ---> lsof" to N; Remark: To avoid hiding the full blown lsof.
- set "Runint Utilities ---> chpst" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> setuidgid" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> envuidgid" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> envdir" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> softlimit" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> runsv" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> runsvdir" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> sv" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> svc" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Shells ---> Choose which shell is aliased to 'sh' name" to none;
- set "Shells ---> ash" to N; Remark: Not needed with bash.
- set "Shells ---> cttyhack" to N; Remark: Not needed with systemd.
- set "Shells ---> hush" to N; Remark: Not needed with bash.
- set "System Logging Utilities ---> klogd to N"; Remark: Not needed with systemd-journald.
- set "System Logging Utilities ---> logger to N"; Remark: Not needed with systemd-journald.
- set "System Logging Utilities ---> logread to N"; Remark: Not needed with systemd-journald.
- set "System Logging Utilities ---> syslogd to N"; Remark: Not needed with systemd-journald.

Ideas and todo's for reducing boot time (to Gui):
- Set GPIO's to desired direction and possibly value already in device tree.
- https://elinux.org/Boot_Time
- https://elinux.org/Boot-up_Time_Reduction_Howto

Ideas for reducing boot time (to drivable vehicle)
- Make service (using cansend or better an own mini-application) sending CANopen SYNC messages to wake up nodes just after can0.service has been started.
