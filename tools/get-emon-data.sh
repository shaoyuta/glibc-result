#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

ROUNDS=20

CASE_LIST=""
CORE_COLLECT_APP_MASK=1     
CORE_RUN_APP_MASK=2     
EMON_DATA_FOLD=/tmp/emon-data

# Run in 1 cpu
CASE_LIST_1="bench-strcpy bench-memcpy-large bench-sprintf bench-acos bench-asinh bench-exp \
           bench-log2 bench-sin bench-sincos bench-sqrt bench-tanh bench-pthread_once"     # 1-4s round=15

CASE_LIST_1_2="bench-memset"   # 50s => round=2

# Run in 8 cpu
CASE_LIST_2="bench-malloc-thread bench-thread_create"   # 10s, 6s => round=2

# Run in 4 cpu
CASE_LIST_3="bench-pthread-locks"       # 6s => round=2
CASE_LIST_3_2="bench-malloc-simple"     #  1s => round=10


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
ROUNDS=2
for case in ${CASE_LIST_1_2[@]}; do
    mkdir -p ${EMON_DATA_FOLD}/${case} 
    taskset 0x1 emon -collect-edp -f ${EMON_DATA_FOLD}/${case}/emon.dat &
    ./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${case}"
    emon -stop > /dev/null && sleep 5 && pkill -9 -x emon > /dev/null
done

CORE_RUN_APP_MASK=4
ROUNDS=15
for case in ${CASE_LIST_1[@]}; do
    mkdir -p ${EMON_DATA_FOLD}/${case} 
    taskset 0x1 emon -collect-edp -f ${EMON_DATA_FOLD}/${case}/emon.dat &
    ./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${case}"
    emon -stop > /dev/null && sleep 5 && pkill -9 -x emon > /dev/null
done

CORE_RUN_APP_MASK="4-11"
ROUNDS=2
for case in ${CASE_LIST_2[@]}; do
    mkdir -p ${EMON_DATA_FOLD}/${case} 
    taskset 0x1 emon -collect-edp -f ${EMON_DATA_FOLD}/${case}/emon.dat &
    ./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${case}"
    emon -stop > /dev/null && sleep 5 && pkill -9 -x emon > /dev/null
done

CORE_RUN_APP_MASK="4-7"
ROUNDS=2
for case in ${CASE_LIST_3[@]}; do
    mkdir -p ${EMON_DATA_FOLD}/${case} 
    taskset 0x1 emon -collect-edp -f ${EMON_DATA_FOLD}/${case}/emon.dat &
    ./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${case}"
    emon -stop > /dev/null && sleep 5 && pkill -9 -x emon > /dev/null
done

CORE_RUN_APP_MASK="4-7"
ROUNDS=10
for case in ${CASE_LIST_3_2[@]}; do
    mkdir -p ${EMON_DATA_FOLD}/${case} 
    taskset 0x1 emon -collect-edp -f ${EMON_DATA_FOLD}/${case}/emon.dat &
    ./rcs_all.sh -f ${FOLD_OF_GLIBC_BENCH} -n ${ROUNDS} -R ${CORE_RUN_APP_MASK} -c "${case}"
    emon -stop > /dev/null && sleep 5 && pkill -9 -x emon > /dev/null
done


