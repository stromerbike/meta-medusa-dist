FILES:${PN}:append = " ${sysconfdir}/machine-id"

do_install:append() {
    # customize system.conf
    echo "ShowStatus=yes" | tee -a ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    echo "RuntimeWatchdogSec=10" | tee -a ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    echo "ShutdownWatchdogSec=1min" | tee -a ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    echo "DefaultTimeoutStopSec=30" | tee -a ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    echo "DefaultRestartSec=30" | tee -a ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf

    # allow journal to fill up log partition almost to its maximum
    echo "SystemMaxUse=40M" | tee -a ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
    echo "SystemKeepFree=1M" | tee -a ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf

    # use fixed machine-id for filling limits on logging partition to work correctly
    install -d ${D}${sysconfdir}
    echo "1234567890abcdef1234567890abcdef" | tee ${D}${sysconfdir}/machine-id
}
