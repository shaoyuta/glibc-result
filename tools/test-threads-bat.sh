#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=1

CORE_COLLECT_APP_MASK=1     #taskset 1 => cpu 0
CORE_RUN_APP_MASK=2         #taskset 2 => cpu 1 , which is default value
NOF_THREADS=1               #

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -f fold of glibc-bench
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
            f) FOLD_OF_GLIBC_BENCH=$OPTARG;;
            h) usage;;
        esac
    done
}

run_test() {
    # Case 1:  1 thread Running on 1 Core (4)
    ${CURR_DIR}/test-thread.sh -f ${FOLD_OF_GLIBC_BENCH} -n 20 -N 1 -R "4"  | taskset 0x1 tee case-threads-1-1.log

    # Case 2:  4 thread Running on 1 Core (4)
    ${CURR_DIR}/test-thread.sh -f ${FOLD_OF_GLIBC_BENCH} -n 20 -N 4 -R "4"   | taskset 0x1 tee case-threads-4-1.log

    # Case 3:  4 thread Running on 4 Core (4-7)
    ${CURR_DIR}/test-thread.sh -f ${FOLD_OF_GLIBC_BENCH} -n 20 -N 4 -R "4-7" | taskset 0x1 tee case-threads-4-4.log

    # Case 4:  32 thread Running on 1 Core (1)
    ${CURR_DIR}/test-thread.sh -f ${FOLD_OF_GLIBC_BENCH} -n 20 -N 32 -R "4" | taskset 0x1 tee case-threads-32-1.log

    # Case 4:  32 thread Running on 8 Core (1)
    ${CURR_DIR}/test-thread.sh -f ${FOLD_OF_GLIBC_BENCH} -n 20 -N 32 -R "4-11" | taskset 0x1 tee case-threads-32-8.log

}

process_args "$@"
run_test
