# work around QA failures with usrmerge installing zsh in /usr/bin/zsh instead of /bin/zsh
# like bash does since https://git.openembedded.org/openembedded-core/commit/?id=4759408677a
RPROVIDES:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'usrmerge', '/bin/dash', '', d)}"
