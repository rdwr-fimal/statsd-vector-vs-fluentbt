#!/bin/bash
cd "$(dirname "$0")"


monitor() {
    while [[ ($(docker inspect -f {{.State.Running}} $LOGAGENT) == true) && ($(docker inspect -f {{.State.Running}} k6) == true) ]]; do
        sleep 2
        echo "$(date '+%Y-%m-%d_%H:%M:%S'), $(docker stats --no-stream --format "{{.Container}}, {{.CPUPerc}}" $LOGAGENT | sed 's/%//g')" 2>&1 | tee -a "$FILE"
        sleep 2
    done
}
usage() {
    echo "Usage: $0 {fluentbit}|{vecor} {log_file}" 1>&2
    exit 1
}
if (($# != 1));then
    usage
else
    LOGAGENT=$1
    FILE=results_statsd_tcp_${LOGAGENT}_$(date +"%Y-%m-%d_%H-%M-%S").log
    monitor
fi