python do_package_append() {
    import subprocess
    subprocess.call('bash -O extglob -c "cd %s/glibc-dbg/lib/.debug/ && rm -rf !(*libpthread-*|*libthread_db-*)"' % d.getVar('PKGDEST', True), shell=True)
}
