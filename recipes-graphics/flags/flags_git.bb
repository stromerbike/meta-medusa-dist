SUMMARY = "GoSquared's flag icon set."
HOMEPAGE = "https://github.com/gosquared/flags"
SECTION = "libs/multimedia"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=c6a37c0d0de68f28a9a4503fed2ab10d"

PV = "gitr${SRCPV}"

SRC_URI = "git://github.com/gosquared/${BPN}.git;protocol=git;branch=master"
SRCREV = "1d382a9ea87667ac59c493b8fd771f49ce837e6a"

FILES_${PN}_append = " ${datadir}/flags/*"

S = "${WORKDIR}/git"

STROMER_COUNTRIES = " \
    AD \
    AE \
    AT \
    BE \
    CA \
    CH \
    DE \
    DK \
    ES \
    FI \
    FR \
    GB \
    GR \
    IE \
    IT \
    LU \
    NL \
    NO \
    NZ \
    PT \
    SE \
    US \
"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/flags
    for STROMER_COUNTRY in ${STROMER_COUNTRIES}; do
        install ${S}/${BPN}/flags-iso/shiny/32/${STROMER_COUNTRY}.png ${D}${datadir}/${BPN}/${STROMER_COUNTRY}.png
    done
}
