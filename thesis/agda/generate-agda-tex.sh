#!/usr/bin/env bash

DIR="$(cd -P "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"

AGDASTDLIB_DEF="${HOME}/build/agda/lib/current/src"
AGDASTDLIB="${1:-"${AGDASTDLIB_DEF}"}"

EXTENSION="lagda"
PREFIX="."

PRPATH="${DIR}/${PREFIX}"
TEXDIR="${DIR}/latex"
TEXPRPATH="${TEXDIR}/${PREFIX}"

# without extension
SRCS=( "PiWare/Atom" "PiWare/Atom/Bool" "PiWare/Padding" "PiWare/Synthesizable" \
       "PiWare/Synthesizable/Bool" "PiWare/Circuit/Core" "PiWare/Circuit" "PiWare/Plugs" \
       "PiWare/Samples" "PiWare/Samples/RippleCarry" \
       "PiWare/Simulation/Core" "PiWare/Simulation" "PiWare/ProofSamples" )


for s in ${SRCS[@]}; do
    FPATH="${PRPATH}/${s}"
    TEXPATH="${TEXPRPATH}/${s}"
    TEXDIR="$(dirname "${TEXPATH}")"
    TEXBASE="$(basename "${TEXPATH}")"

    if [ ! -f "${TEXDIR}/${TEXBASE}.tex" ]; then 
        agda -i "${AGDASTDLIB}" -i "${PRPATH}" --latex "${FPATH}.${EXTENSION}"
    fi
done
