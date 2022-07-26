#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=1

CORE_COLLECT_APP_MASK=1     #taskset 1 => cpu 0
CORE_RUN_APP_MASK=2         #taskset 2 => cpu 1 , which is default value
NOF_THREADS=1               #

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -n rounds of run test
  -f fold of glibc-bench
  -R cpumask for Running APP, default is 2
  -C cpumask for Collect data APP, dafault is 1
  -n select the nof threads of test app, 1, 4, 32
  -N number of threads 1,4,32
  -h Show this
Sample:
    ./test-threads-m.sh -f /home/sfdev/glibc/glibc-build -n 1 -R 4
EOM
    exit 0
}

process_args() {
    while getopts ":n:f:R:C:N:h" option; do
        case "$option" in
            n) ROUNDS=$OPTARG;;
            f) FOLD_OF_GLIBC_BENCH=$OPTARG;;
            R) CORE_RUN_APP_MASK=$OPTARG;;
            C) CORE_COLLECT_APP_MASK=$OPTARG;;
            N) NOF_THREADS=$OPTARG;;
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

    for ((i=4;i<=32;i+=4)); do
        ./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -R ${CORE_RUN_APP_MASK} -c bench-thread_create_m -n ${ROUNDS} -p $i
    done
}

process_args "$@"
run_test
