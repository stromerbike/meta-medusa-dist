This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Modifications:
- python3_3.12.3: Added python3-manifest-with-additions.json for defining more fine grained packages than python3-misc does. Also adopted paths for pyc only distribution.

Notes:
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)

Fixed recipe version:
- [honister: pv 1.6.6](https://github.com/openembedded/meta-openembedded/commit/c61dc077bbd81260e4f167fa2251643ba0ba6974) to avoid issue https://github.com/a-j-wood/pv/issues/23
- [rocko: tar 1.29](https://github.com/kraj/poky/commit/a38ab4ddb786b4d692d4ae891144da576cc190e3) to avoid having to introduce a new delta firmware package file format version

Busybox configuration (1.36.1):
- git clone https://git.busybox.net/busybox && cd busybox && git reset --hard 1_36_1 && make defconfig && make menuconfig
- set "Settings ---> Include busybox applet" to N; Remark: Not needed.
- set "Settings ---> Enable locale support (system needs locale for this to work)" to y.
- set "Settings ---> Use libc routines for Unicode (else uses internal ones)" to y.
- set "Settings ---> Range of supported Unicode characters" to 1114111.
- set "Settings ---> Allow zero-width Unicode characters on output" to y.
- set "Settings ---> Allow wide Unicode characters on output" to y.
- set "Archival Utilities ---> unlzma" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> lzcat" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> lzma -d" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> unxz" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> xzcat" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> xz -d" to N; Remark: Not needed with xz.
- set "Archival Utilities ---> lzop" to N; Remark: Not needed with lzop.
- set "Archival Utilities ---> tar" to N; Remark: Not needed with tar.
- set "Archival Utilities ---> tar Support old tar header format" to N;
- set "Archival Utilities ---> tar Enable untarring of tarballs with checksums produced by buggy Sun tar" to N;
- set "Archival Utilities ---> tar Support GNU tar extensions (long filenames)" to N;
- set "Coreutils ---> Support %[num]N nanosecond format specifier" to y.
- set "Coreutils ---> groups" to N; Remark: Not needed with shadow-base.
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
- set "Linux System Utilities ---> lsusb" to N; Remark: Not needed with usbutils.
- set "Linux System Utilities ---> mdev" to N; Remark: Not needed with systemd-udevd.
- set "Linux System Utilities ---> mke2fs" to N; Remark: Not needed.
- set "Linux System Utilities ---> mkfs.ext2" to N; Remark: Not needed.
- set "Linux System Utilities ---> mount" to N; Remark: Not needed with systemd/util-linux-mount.
- set "Linux System Utilities ---> nologin" to N; Remark: Not needed with shadow-base.
- set "Linux System Utilities ---> rtcwake" to N; Remark: Not needed without RTC.
- set "Linux System Utilities ---> umount" to N; Remark: Not needed with systemd/util-linux-umount.
- set "Miscellaneous Utilities ---> beep" to N; Remark: Not needed without onboard speaker.
- set "Miscellaneous Utilities ---> chat" to N; Remark: To avoid conflicts with ppp.
- set "Miscellaneous Utilities ---> crond" to N; Remark: Not needed with systemd.
- set "Miscellaneous Utilities ---> crontab" to N; Remark: Not needed with systemd.
- set "Miscellaneous Utilities ---> fbsplash" to N; Remark: Not needed with fbv.
- set "Miscellaneous Utilities ---> man" to N; Remark: Remark: Not needed.
- set "Miscellaneous Utilities ---> mt" to N; Remark: Remark: Not needed.
- set "Miscellaneous Utilities ---> runlevel" to N; Remark: Not needed with systemd.
- set "Miscellaneous Utilities ---> rx" to N; Remark: Not needed with lrzsz.
- set "Miscellaneous Utilities ---> watchdog" to N; Remark: Not needed with systemd.
- set "Networking Utilities ---> dnsd" to N; Remark: Not needed with systemd-resolved.
- set "Networking Utilities ---> ftpd" to N; Remark: Not needed.
- set "Networking Utilities ---> httpd" to N; Remark: Not needed.
- set "Networking Utilities ---> ntpd" to N; Remark: Not needed with systemd-timesyncd.
- set "Networking Utilities ---> ssl_client" to N; Remark: Not needed with openssl.
- set "Networking Utilities ---> wget" to N; Remark: Not needed with wget.
- set "Networking Utilities ---> udhcpd" to N; Remark: Not needed with systemd-networkd.
- set "Networking Utilities ---> udhcpc" to N; Remark: Not needed with systemd-networkd.
- set "Networking Utilities ---> udhcpc6" to N; Remark: Not needed with systemd-networkd.
- set "Print Utilities ---> lpd" to N; Remark: Not needed.
- set "Print Utilities ---> lpr" to N; Remark: Not needed.
- set "Print Utilities ---> lpq" to N; Remark: Not needed.
- set "Mail Utilities ---> makemime" to N; Remark: Not needed.
- set "Mail Utilities ---> popmaildir" to N; Remark: Not needed.
- set "Mail Utilities ---> reformime" to N; Remark: Not needed.
- set "Mail Utilities ---> sendmail" to N; Remark: Not needed.
- set "Runint Utilities ---> chpst" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> setuidgid" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> envuidgid" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> envdir" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> softlimit" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> runsv" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> runsvdir" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> sv" to N; Remark: Not needed with systemd.
- set "Runint Utilities ---> svc" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> svok" to N; Remark: To avoid conflicts with daemontools(-encore) / Not needed with systemd.
- set "Runint Utilities ---> svlogd" to N; Remark: Not needed with systemd.
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
- If the above is not possible, set direction to "low" / "high" instead of "out" followed by a "0" / "1" (generally a good idea to ensure glitch free operation).
- https://elinux.org/Boot_Time
- https://elinux.org/Boot-up_Time_Reduction_Howto

Ideas for reducing boot time (to drivable vehicle)
- Make service (using cansend or better an own mini-application) sending CANopen SYNC messages to wake up nodes just after can0.service has been started.
