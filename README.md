This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Patches:
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)

Backports:
- [pseudo: Work around issues with glibc 2.24](https://github.com/kraj/poky/commit/7b9e031355a993364a587b9ea878104827e3f799) (for building on Debian 9)
- [pseudo: obey our LDFLAGS](https://github.com/kraj/poky/commit/cb5649cbb873d1287b25ac24e5cd413445b32d70)
