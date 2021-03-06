#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=1

#CASE_LIST=("bench-memset" "bench-strcpy" "bench-memcpy-large" "bench-sprintf" "bench-math-inlines")
CASE_LIST="bench-memset bench-strcpy bench-memcpy-large bench-sprintf bench-math-inlines bench-acos bench-asinh bench-exp \
           bench-log2 bench-sin bench-sincos bench-sqrt bench-tanh bench-pthread_once bench-thread_create bench-pthread-locks \
           bench-malloc-thread bench-malloc-simple" 

CORE_COLLECT_APP_MASK=1     #taskset 1 => cpu 0
CORE_RUN_APP_MASK=2         #taskset 2 => cpu 1 , which is default value
EXTRA_PARAM=""              #extra parameters

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -n rounds of run test
  -f fold of glibc-bench
  -c case name
  -R cpumask for Running APP, default is 2
  -C cpumask for Collect data APP, dafault is 1
  -p extra parameter
  -h Show this
Sample:
    ./rcs_all.sh -f /home/sfdev/glibc/glibc-build -c bench-memcpy-large -n 5 -R 0xfe -C 0x1
    ./rcs_all.sh -f ~/glibc/glibc-build-gcc85/ -c bench-malloc-thread -n 20 -R 4 -p 1 | taskset 0x1 tee ./bench-thread-1-malloc.log
EOM
    exit 0
}

process_args() {
    while getopts ":n:c:f:R:C:p:h" option; do
        case "$option" in
            n) ROUNDS=$OPTARG;;
            f) FOLD_OF_GLIBC_BENCH=$OPTARG;;
            c) CASE_LIST=$OPTARG;;
            p) EXTRA_PARAM=$OPTARG;;
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

    
    for case in ${CASE_LIST[@]}; do
        echo "=== case: ${case}"
        if [ -z ${case} ]; then
            echo "case name is empty"
            exit 1
        fi
        ./rcs.sh -f ${FOLD_OF_GLIBC_BENCH} -c ${case} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -C ${CORE_COLLECT_APP_MASK} -p ${EXTRA_PARAM}
    done
}

process_args "$@"
run_test
