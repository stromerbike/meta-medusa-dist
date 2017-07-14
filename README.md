This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Patches:
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)

Backports:
- [wvdial: inherit pkgconfig Missing pkgconfig does not let build the package.](https://github.com/openembedded/meta-openembedded/commit/4c9a7e975cb09b43b1e08f287e42d9c0682e949c)
- [wxstreams: fix build with gcc-6 (patch from Debian). Remove blacklists for wvstreams and wvdial](https://github.com/openembedded/meta-openembedded/commit/85810933a8b1e88a8ae8652387885abc0522b419)
