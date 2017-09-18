This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Patches:
- [CVE-2017-1000250 (BlueBorne)](https://git.kernel.org/pub/scm/bluetooth/bluez.git/commit/?id=9e009647b14e810e06626dde7f1bb9ea3c375d09)
- [CVE-2017-1000251 (BlueBorne)](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e860d2c904d1a9f38a24eb44c9f34b8f915a6ea3)
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)

Backports:
- [cmake 3.7.2](http://git.yoctoproject.org/cgit/cgit.cgi/poky/commit/meta/recipes-devtools/cmake?h=pyro&id=6dcf5c6e6eadd0a572f9aa61783b54ccd39f0378)
- [gtest 1.8.0](https://github.com/openembedded/meta-openembedded/commit/1e2491d12520d767e0e5687a9b15819fe0b6ff27)
- [tcf-agent: kill with USR2 in systemd stop](https://github.com/kraj/poky/commit/b33356d168c0fec9b2df387b51240fa6566ca145)
- [wvdial: inherit pkgconfig Missing pkgconfig does not let build the package.](https://github.com/openembedded/meta-openembedded/commit/4c9a7e975cb09b43b1e08f287e42d9c0682e949c)
- [wxstreams: fix build with gcc-6 (patch from Debian). Remove blacklists for wvstreams and wvdial](https://github.com/openembedded/meta-openembedded/commit/85810933a8b1e88a8ae8652387885abc0522b419)
