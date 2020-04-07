#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pkill fdbserver
ulimit -S -c unlimited

unset FDB_NETWORK_OPTION_EXTERNAL_CLIENT_DIRECTORY
WORKDIR="$(pwd)/tmp/$$"
if [ ! -d "${WORKDIR}" ] ; then
    mkdir -p "${WORKDIR}"
fi
DEBUGLEVEL=0 DISPLAYERROR=1 RANDOMTEST=1 WORKDIR="${WORKDIR}" FDBSERVERPORT="${PORT_FDBSERVER:-4500}" ${SCRIPTDIR}/bindingTestScript.sh 1
