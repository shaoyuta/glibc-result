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
    ./test-thread.sh -f ~/glibc/glibc-build -n 2 -N 1 -R "4"
    ./test-thread.sh -f ~/glibc/glibc-build -n 2 -N 4 -R "4-7"
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

    echo "=== case: bench-thread_create-${NOF_THREADS}"
    EXEC_FILE=${FOLD_OF_GLIBC_BENCH}/test-thread/bench-thread_create-${NOF_THREADS}
    for ((i = 0; i<${ROUNDS}; i++)); do
        exec numactl -m 0 -N 0 -C ${CORE_RUN_APP_MASK}  ${EXEC_FILE}  | taskset ${CORE_COLLECT_APP_MASK} python3 ${CURR_DIR}/parse_glibc_bench_ext.py -s -t "bench-thread_create"
        echo 
    done
}

process_args "$@"
run_test
