do_install_append() {
    sed -i 's/After=network.target/After=network.target location.target/' ${D}${systemd_system_unitdir}/tcf-agent.service
    sed -i 's/WantedBy=multi-user.target/WantedBy=debug.target/' ${D}${systemd_system_unitdir}/tcf-agent.service
    rm ${D}${sbindir}/tcf-client
}
