FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://0001-only-generate-legacy-bytecode.patch \
            file://python3-manifest-with-additions.json \
"

WARN_QA:remove = "buildpaths"

do_install:append:class-target() {
    find ${D}${libdir}/python${PYTHON_MAJMIN} -type d -name "__pycache__" -exec rm -r {} +
    find ${D}${libdir}/python${PYTHON_MAJMIN} -name "*.py" -not -name "*_sysconfigdata*.py" -delete
}

python(){
    import collections, json

    filename = os.path.join(d.getVar('THISDIR'), '../../../../meta-medusa-dist/recipes-devtools/python', 'python3', 'python3-manifest-with-additions.json')
    # This python changes the datastore based on the contents of a file, so mark
    # that dependency.
    bb.parse.mark_dependency(d, filename)

    with open(filename) as manifest_file:
        manifest_str =  manifest_file.read()
        json_start = manifest_str.find('# EOC') + 6
        manifest_file.seek(json_start)
        manifest_str = manifest_file.read()
        python_manifest = json.loads(manifest_str, object_pairs_hook=collections.OrderedDict)

    # First set RPROVIDES for -native case
    # Hardcoded since it cant be python3-native-foo, should be python3-foo-native
    pn = 'python3'
    rprovides = (d.getVar('RPROVIDES') or "").split()

    # ${PN}-misc-native is not in the manifest
    rprovides.append(pn + '-misc-native')

    for key in python_manifest:
        pypackage = pn + '-' + key + '-native'
        if pypackage not in rprovides:
              rprovides.append(pypackage)

    d.setVar('RPROVIDES:class-native', ' '.join(rprovides))

    # Then work on the target
    include_pycs = d.getVar('INCLUDE_PYCS')

    packages = d.getVar('PACKAGES').split()
    pn = d.getVar('PN')

    newpackages=[]
    for key in python_manifest:
        pypackage = pn + '-' + key

        if pypackage not in packages:
            # We need to prepend, otherwise python-misc gets everything
            # so we use a new variable
            newpackages.append(pypackage)

        # "Build" python's manifest FILES, RDEPENDS and SUMMARY
        d.setVar('FILES:' + pypackage, '')
        for value in python_manifest[key]['files']:
            d.appendVar('FILES:' + pypackage, ' ' + value)

        # Add cached files
        if include_pycs == '1':
            for value in python_manifest[key]['cached']:
                    d.appendVar('FILES:' + pypackage, ' ' + value)

        for value in python_manifest[key]['rdepends']:
            # Make it work with or without $PN
            if '${PN}' in value:
                value=value.split('-', 1)[1]
            d.appendVar('RDEPENDS:' + pypackage, ' ' + pn + '-' + value)

        for value in python_manifest[key].get('rrecommends', ()):
            if '${PN}' in value:
                value=value.split('-', 1)[1]
            d.appendVar('RRECOMMENDS:' + pypackage, ' ' + pn + '-' + value)

        d.setVar('SUMMARY:' + pypackage, python_manifest[key]['summary'])

    # Prepending so to avoid python-misc getting everything
    packages = newpackages + packages
    d.setVar('PACKAGES', ' '.join(packages))
    d.setVar('ALLOW_EMPTY:${PN}-modules', '1')
    d.setVar('ALLOW_EMPTY:${PN}-pkgutil', '1')

    if "pgo" in d.getVar("PACKAGECONFIG").split() and not bb.utils.contains('MACHINE_FEATURES', 'qemu-usermode', True, False, d):
        bb.fatal("pgo cannot be enabled as there is no qemu-usermode support for this architecture/machine")
}
