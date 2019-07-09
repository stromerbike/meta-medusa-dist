This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

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
- set "Init Utilities ---> init" to N; Remark: To avoid conflicts with systemd's runlevel.
- set "Init Utilities ---> linuxrc" to N; Remark: Not needed with systemd.
- set "Linux System Utilities ---> hwclock" to N; Remark: Not needed without RTC.
- set "Linux System Utilities ---> mdev" to N; Remark: Not needed with systemd-udevd.
- set "Miscellaneous Utilities ---> chat" to N; Remark: To avoid conflicts with ppp.
- set "Network Utilities" ---> httpd" to No; Remark: Not needed.
- set "Network Utilities" ---> udhcpd" to No; Remark: Not needed with systemd-networkd.
- set "Network Utilities" ---> udhcpc" to No; Remark: Not needed with systemd-networkd.
- set "Process Utilities ---> lsof" to N; Remark: To avoid hiding the full blown lsof.
- set "Runint Utilities ---> setuidgid" to N; Remark: To avoid conflicts with daemontools(-encore).
- set "Runint Utilities ---> envuidgid" to N; Remark: To avoid conflicts with daemontools(-encore).
- set "Runint Utilities ---> envdir" to N; Remark: To avoid conflicts with daemontools(-encore).
- set "Runint Utilities ---> softlimit" to N; Remark: To avoid conflicts with daemontools(-encore).
- set "Runint Utilities ---> svc" to N; Remark: To avoid conflicts with daemontools(-encore).
- set "System Logging Utilities ---> klogd to N"; Remark: Not needed with systemd-journald.
- set "System Logging Utilities ---> logger to N"; Remark: Not needed with systemd-journald.
- set "System Logging Utilities ---> logread to N"; Remark: Not needed with systemd-journald.
- set "System Logging Utilities ---> syslogd to N"; Remark: Not needed with systemd-journald.

Ideas and todo's for reducing boot time (to Gui):
- Strip down Qt to a bare minimum via QT_CONFIG_FLAGS in qtbase_%.bbappend.
- Set GPIO's to desired direction and possibly value already in device tree.
- https://elinux.org/Boot_Time
- https://elinux.org/Boot-up_Time_Reduction_Howto

Ideas for reducing boot time (to drivable vehicle)
- Make service (using cansend or better an own mini-application) sending CANopen SYNC messages to wake up nodes just after can0.service has been started.
