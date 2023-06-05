DEPENDS:remove = " libtasn1 p11-kit"

PACKAGECONFIG[openssl] = "--with-ssl,--without-ssl,openssl"
