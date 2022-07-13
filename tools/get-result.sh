#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=20

CASE_LIST=""
CORE_COLLECT_APP_MASK=1     
CORE_RUN_APP_MASK=2     

# Run in 1 cpu
CASE_LIST_1="bench-memset bench-strcpy bench-memcpy-large bench-sprintf bench-acos bench-asinh bench-exp \
           bench-log2 bench-sin bench-sincos bench-sqrt bench-tanh bench-pthread_once"     

# Run in 8 cpu
CASE_LIST_2="bench-malloc-thread bench-thread_create" 

# Run in 4 cpu
CASE_LIST_3="bench-pthread-locks bench-malloc-simple" 

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -n rounds of run test
  -f fold of glibc-bench
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
            C) CORE_COLLECT_APP_MASK=$OPTARG;;
            h) usage;;
        esac
    done
}

process_args "$@"

CORE_RUN_APP_MASK=4
./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${CASE_LIST_1}"

CORE_RUN_APP_MASK="4-11"
./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${CASE_LIST_2}"

CORE_RUN_APP_MASK="4-7"
./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${CASE_LIST_3}"  


