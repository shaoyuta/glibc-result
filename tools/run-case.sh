#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=1
PREFIX_STRING="default"
CASE_LIST=""

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -n rounds of run test
  -p prefix of output fold name
  -t case list
  -f fold of glibc-bench
  -h Show this
EOM
    exit 0
}

process_args() {
    while getopts ":n:p:t:f:h" option; do
        case "$option" in
            n) ROUNDS=$OPTARG;;
            p) PREFIX_STRING=$OPTARG;;
            t) CASE_LIST=$OPTARG;;
            f) FOLD_OF_GLIBC_BENCH=$OPTARG;;
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
    pushd ${FOLD_OF_GLIBC_BENCH}
    for ((i = 0; i<${ROUNDS}; i++)); do
        if [ -d benchtests/out-${PREFIX_STRING}-${i} ]; then
            rm -fr benchtests/out-${PREFIX_STRING}-${i}
        fi
        mkdir  benchtests/out-${PREFIX_STRING}-${i}
        make bench
        mv benchtests/*.out benchtests/out-${PREFIX_STRING}-${i}/
    done
    popd
}

process_args "$@"
run_test
