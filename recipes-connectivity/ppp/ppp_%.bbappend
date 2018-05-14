inherit update-alternatives

ALTERNATIVE_${PN} = "chat"
ALTERNATIVE_LINK_NAME[chat] = "${sbindir}/chat"
ALTERNATIVE_PRIORITY = "100"

FILES_${PN} += "${sbindir}/chat.${PN}"
