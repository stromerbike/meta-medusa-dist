python do_package:append() {
    import subprocess
    subprocess.call('bash -O extglob -c "cd %s/glibc-dbg/lib/.debug/ && rm -rf !(*libpthread-*|*libthread_db-*)"' % d.getVar('PKGDEST', True), shell=True)
    subprocess.call('bash -c "cd %s/glibc-dbg/sbin && rm -rf .debug/"' % d.getVar('PKGDEST', True), shell=True)
    subprocess.call('bash -c "cd %s/glibc-dbg/usr/bin && rm -rf .debug/"' % d.getVar('PKGDEST', True), shell=True)
    subprocess.call('bash -c "cd %s/glibc-dbg/usr/lib/audit && rm -rf .debug/"' % d.getVar('PKGDEST', True), shell=True)
    subprocess.call('bash -c "cd %s/glibc-dbg/usr/sbin && rm -rf .debug/"' % d.getVar('PKGDEST', True), shell=True)
}
