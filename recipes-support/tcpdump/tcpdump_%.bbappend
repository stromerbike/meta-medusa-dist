PACKAGECONFIG_remove += "openssl"

PACKAGECONFIG[openssl] = "--with-crypto=yes,--without-crypto,openssl"
