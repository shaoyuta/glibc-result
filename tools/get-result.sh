#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=20

CASE_LIST=""
CORE_COLLECT_APP_MASK=1     
CORE_RUN_APP_MASK=2     

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -n rounds of run test
  -f fold of glibc-bench
  -c case name
  -R cpumask for Running APP, default is 2
  -C cpumask for Collect data APP, dafault is 1
  -h Show this
Sample:
    ./rcs.sh  -f /home/sfdev/glibc/glibc-build -c bench-memcpy-large -n 5 -R 0xfe -C 0x1
EOM
    exit 0
}

process_args() {
    while getopts ":n:c:f:R:C:h" option; do
        case "$option" in
            n) ROUNDS=$OPTARG;;
            f) FOLD_OF_GLIBC_BENCH=$OPTARG;;
            R) CORE_RUN_APP_MASK=$OPTARG;;
            C) CORE_COLLECT_APP_MASK=$OPTARG;;
            h) usage;;
        esac
    done
}

./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c 'bench-thread_create' | python3 trans.py
