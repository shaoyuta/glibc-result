#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

EMON_DATA_FOLD=/tmp/emon-data

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -e emon data fold
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
            h) usage;;
        esac
    done
}

parse_data() {
    for d in ${EMON_DATA_FOLD}; do
        pushd ${d}
        emon -process-edp /opt/intel/sep_private_5.33_linux_0316081130eb678/config/edp/edp_config.txt
        popd
    done
}

process_args "$@"
parse_data
