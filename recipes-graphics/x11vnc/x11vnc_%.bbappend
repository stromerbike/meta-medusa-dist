FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://support-shm-key-and-drm-for-rawfb-option.patch \
"

PACKAGECONFIG[drm] = "--with-drm=${STAGING_DIR_TARGET}${prefix},--without-drm,libdrm"
PACKAGECONFIG:append = " drm"

DEPENDS:remove = " libtasn1 p11-kit"

PACKAGECONFIG[openssl] = "--with-ssl,--without-ssl,openssl"
