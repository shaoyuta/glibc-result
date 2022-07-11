#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=1

#CASE_LIST=("bench-memset" "bench-strcpy" "bench-memcpy-large" "bench-sprintf" "bench-math-inlines")
CASE_LIST="bench-memset bench-strcpy bench-memcpy-large bench-sprintf bench-math-inlines bench-acos bench-asinh bench-exp \
           bench-log2 bench-sin bench-sincos bench-sqrt bench-tanh bench-pthread_once bench-thread_create bench-pthread-locks \
           bench-malloc-thread bench-malloc-simple" 

CORE_COLLECT_APP_MASK=1     #taskset 1 => cpu 0
CORE_RUN_APP_MASK=2         #taskset 2 => cpu 1 , which is default value
EMON_DATA_FOLD=/tmp/emon-data

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -n rounds of run test
  -f fold of glibc-bench
  -c case name
  -R cpumask for Running APP, default is 2
  -C cpumask for Collect data APP, dafault is 1
  -e emon data fold
  -h Show this
Sample:
    ./rcs_all.sh  -f /home/sfdev/glibc/glibc-build -c bench-memcpy-large -n 5 -R 0xfe -C 0x1
EOM
    exit 0
}

process_args() {
    while getopts ":n:c:f:R:C:e:h" option; do
        case "$option" in
            n) ROUNDS=$OPTARG;;
            f) FOLD_OF_GLIBC_BENCH=$OPTARG;;
            c) CASE_LIST=$OPTARG;;
            R) CORE_RUN_APP_MASK=$OPTARG;;
            C) CORE_COLLECT_APP_MASK=$OPTARG;;
            e) EMON_DATA_FOLD=$OPTARG;;
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
        mkdir -p ${EMON_DATA_FOLD}/${case} 
        taskset 0x1 emon -collect-edp -f ${EMON_DATA_FOLD}/${case}/emon.dat &
        ./rcs.sh -f ${FOLD_OF_GLIBC_BENCH} -c ${case} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -C ${CORE_COLLECT_APP_MASK}
        emon -stop && sleep 5 && pkill -9 -x emon
    done
}

process_args "$@"
run_test
