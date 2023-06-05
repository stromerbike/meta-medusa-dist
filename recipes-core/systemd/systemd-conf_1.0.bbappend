do_install:append() {
    # customize system.conf
    sed -i -e 's/.*ShowStatus.*/ShowStatus=yes/' ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    sed -i -e 's/.*RuntimeWatchdogSec.*/RuntimeWatchdogSec=10/' ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    sed -i -e 's/.*ShutdownWatchdogSec.*/ShutdownWatchdogSec=1min/' ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    sed -i -e 's/.*DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=30/' ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    sed -i -e 's/.*DefaultRestartSec.*/DefaultRestartSec=30/' ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf

    # allow journal to fill up log partition almost to its maximum
    sed -i -e 's/.*SystemMaxUse.*/SystemMaxUse=40M/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
    sed -i -e 's/.*SystemKeepFree.*/SystemKeepFree=1M/' ${D}${systemd_unitdir}/journald.conf.d/00-${PN}.conf
}
