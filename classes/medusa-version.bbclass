MEDUSA_METADATA_VERSION ?= "${@medusa_detect_version(d)}"
MEDUSA_METADATA_GIT_DATE_TIME ?= "${@medusa_detect_git_date_time(d)}"
MEDUSA_METADATA_GIT_HASH_SHORT ?= "${@medusa_detect_git_hash_short(d)}"
MEDUSA_METADATA_GIT_HASH ?= "${@medusa_detect_git_hash(d)}"
MEDUSA_METADATA_GIT_STATUS ?= "${@medusa_detect_git_status(d)}"

# Detects the version from the environment variable MEDUSA_VERSION
def medusa_detect_version(d):
    version = d.getVar("MEDUSA_VERSION", True)
    if not version:
        return '4.0.0.255'
    else:
        return version

# Detects the git date and time of the project in which the BUILDDIR resides
def medusa_detect_git_date_time(d):
    path = medusa_get_builddir(d)

    scms = [medusa_get_metadata_git_date_time]

    for scm in scms:
        date_time = scm(path, d)
        if date_time != "<unknown>":
            return date_time

    return "<unknown>"
def medusa_get_metadata_git_date_time(path, d):
    import bb.process

    try:
        date_time, _ = bb.process.run('git log -1 --format=%cd --date=format:%Y-%m-%d-%H%M%S', cwd=path)
    except bb.process.ExecutionError:
        date_time = '<unknown>'
    return date_time.strip()

# Detects the short git hash of the project in which the BUILDDIR resides
def medusa_detect_git_hash_short(d):
    path = medusa_get_builddir(d)

    scms = [medusa_get_metadata_git_hash_short]

    for scm in scms:
        hash = scm(path, d)
        if hash != "<unknown>":
            return hash

    return "<unknown>"
def medusa_get_metadata_git_hash_short(path, d):
    import bb.process

    try:
        hash, _ = bb.process.run('git rev-parse --short=8 HEAD', cwd=path)
    except bb.process.ExecutionError:
        hash = '<unknown>'
    return hash.strip()

# Detects the full git hash of the project in which the BUILDDIR resides
def medusa_detect_git_hash(d):
    path = medusa_get_builddir(d)

    scms = [medusa_get_metadata_git_hash]

    for scm in scms:
        hash = scm(path, d)
        if hash != "<unknown>":
            return hash

    return "<unknown>"
def medusa_get_metadata_git_hash(path, d):
    import bb.process

    try:
        hash, _ = bb.process.run('git rev-parse HEAD', cwd=path)
    except bb.process.ExecutionError:
        hash = '<unknown>'
    return hash.strip()

# Detects the git status of the project in which the BUILDDIR resides
def medusa_detect_git_status(d):
    path = medusa_get_builddir(d)

    scms = [medusa_get_metadata_git_status]

    for scm in scms:
        status = scm(path, d)
        if status != "<unknown>":
            return status

    return "<unknown>"
def medusa_get_metadata_git_status(path, d):
    import bb.process

    try:
        status, _ = bb.process.run('git status --porcelain', cwd=path)
        if status:
            status = '-DIRTY'
    except bb.process.ExecutionError:
        status = '<unknown>'
    return status

def medusa_get_builddir(d):
    d.getVar("BUILDDIR", True)
