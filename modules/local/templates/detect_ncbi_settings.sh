#!/usr/bin/env bash

set -u


# Get the expected NCBI settings path.
eval "$(vdb-config -o n NCBI_SETTINGS | sed 's/[" ]//g')"

# If the user settings do not exist yet create a file suitable for `prefetch`
# and `fasterq-dump`. If that settings file does not contain the required
# settings, error out.
if [[ ! -f "${NCBI_SETTINGS}" ]]; then
    printf '!{config}' > 'user-settings.mkfg'
else
    prefetch --help &> /dev/null
    if [[ $? = 78 ]]; then
        echo "You have an existing vdb-config at ${NCBI_SETTINGS} but it is"\
        "missing the required entries for /LIBS/GUID and"\
        "/libs/cloud/report_instance_identity. Feel free to enter the following:" >&2
        echo "$(printf '!{config}')" >&2
        exit 1
    fi
fi
