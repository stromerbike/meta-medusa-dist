This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Patches:
- [CVE-2017-1000251 (BlueBorne)](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e860d2c904d1a9f38a24eb44c9f34b8f915a6ea3)
- [Barebox with GCC 6.3 or newer](http://lists.infradead.org/pipermail/barebox/2017-May/030156.html)
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)
- [systemd /etc/localtime symlinks chasing](https://github.com/tramseyer/meta-medusa-dist/tree/master/recipes-core/systemd/systemd/chase_symlinks_etc_localtime.patch)

Busybox configuration (1.27.2):
- git clone https://github.com/mirror/busybox.git && cd busybox && git reset --hard 1_27_2 && make defconfig && make menuconfig
- set "Busybox Settings ---> Build shared libbusybox" to Y; Remark: Small binaries result in faster startup time.
- set "Init Utilities ---> init" to N; Remark: To avoid conflicts with systemd's runlevel.
- set "Init Utilities ---> linuxrc" to N; Remark: Not needed with systemd.

Ideas and todo's for reducing boot time:
- Strip down Qt to a bare minimum via QT_CONFIG_FLAGS in qtbase_%.bbappend.
- Compile driver for BMP280 as Kernel module and load it after drive.target.
- Set GPIO's to desired direction and possibly value already in device tree.
