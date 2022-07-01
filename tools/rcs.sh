#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=1

CASE_LIST=""

CORE_COLLECT_APP_MASK=1     #taskset 1 => cpu 0
CORE_RUN_APP_MASK=2         #taskset 2 => cpu 1 , which is default value

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
            c) CASE_LIST=$OPTARG;;
            R) CORE_RUN_APP_MASK=$OPTARG;;
            C) CORE_COLLECT_APP_MASK=$OPTARG;;
            h) usage;;
        esac
    done
}

run_test() {
    if [ -z ${FOLD_OF_GLIBC_BENCH} ]; then
        echo "Error: Please input glibc-bench path"
        exit 1
    fi
    if [ ! -d ${FOLD_OF_GLIBC_BENCH} ]; then
        echo ${FOLD_OF_GLIBC_BENCH} is not a valid fold
        exit 1
    fi
    if [ -z ${CASE_LIST} ]; then
        echo "case name is empty"
        exit 1
    fi
    pushd ${FOLD_OF_GLIBC_BENCH} > /dev/null
    for ((i = 0; i<${ROUNDS}; i++)); do
        echo "Round ${i}: "
        EXEC_FILE=${FOLD_OF_GLIBC_BENCH}/benchtests/${CASE_LIST}
        if [ ! -x  ${EXEC_FILE} ]; then
            echo "file ${EXEC_FILE} not exist"
            exit 1
        fi
        exec taskset ${CORE_RUN_APP_MASK}  ${EXEC_FILE} | taskset ${CORE_COLLECT_APP_MASK} python3 ${CURR_DIR}/parse_glibc_bench_ext.py -s -t ${CASE_LIST}
    done
    popd > /dev/null
}

process_args "$@"
run_test
