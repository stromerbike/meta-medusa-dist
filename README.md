This is the repository of the distribution specific Yocto layer for the Stromer Medusa hardware.

Patches:
- [JTAG with running Linux Kernel](https://community.nxp.com/thread/376786)

Backports:
- [cmake 3.7.2](http://git.yoctoproject.org/cgit/cgit.cgi/poky/commit/meta/recipes-devtools/cmake?h=pyro&id=6dcf5c6e6eadd0a572f9aa61783b54ccd39f0378)
- [gtest 1.8.0](https://github.com/openembedded/meta-openembedded/commit/1e2491d12520d767e0e5687a9b15819fe0b6ff27)
- [tcf-agent: kill with USR2 in systemd stop](https://github.com/kraj/poky/commit/b33356d168c0fec9b2df387b51240fa6566ca145)
