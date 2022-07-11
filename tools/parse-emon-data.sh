#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

EMON_DATA_FOLD=/tmp/emon-data

CASE_LIST="bench-memset bench-strcpy bench-memcpy-large bench-sprintf bench-math-inlines bench-acos bench-asinh bench-exp \
           bench-log2 bench-sin bench-sincos bench-sqrt bench-tanh bench-pthread_once bench-thread_create bench-pthread-locks \
           bench-malloc-thread bench-malloc-simple" 
SELECTED_CASES=""

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -e emon data fold
  -c case list
  -h Show this
Sample:
    ./ddd
EOM
    exit 0
}

process_args() {
    while getopts ":n:c:f:R:C:e:h" option; do
        case "$option" in
            e) EMON_DATA_FOLD=$OPTARG;;
            c) SELECTED_CASES=$OPTARG;;
            h) usage;;
        esac
    done
}

parse_data() {
    if [ -z ${SELECTED_CASES} ]; then 
        for d in ${EMON_DATA_FOLD}/*; do
            pushd ${d} > /dev/null
            emon -process-edp /opt/intel/sep_private_5.33_linux_0316081130eb678/config/edp/edp_config.txt
            popd > /dev/null
        done
    else
        for d in ${SELECTED_CASES[@]}; do
            pushd ${EMON_DATA_FOLD}/${d} > /dev/null
            emon -process-edp /opt/intel/sep_private_5.33_linux_0316081130eb678/config/edp/edp_config.txt
            popd > /dev/null
        done
    fi
}

process_args "$@"
parse_data
