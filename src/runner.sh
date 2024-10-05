#!/bin/sh
set -e
BASE_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
RUN_PARTS="$BASE_DIR/scripts.d/"
NAME_FILTER="[0-9][0-9]_*"

# pre-requisites
if ! command -V tedge >/dev/null 2>&1; then
    echo "Missing dependency. tedge" >&2
    exit 1
fi

TOPIC_ROOT=$(tedge config get mqtt.topic_root)
TOPIC_ID=$(tedge config get mqtt.device_topic_id)

if [ $# -gt 0 ]; then
    RUN_PARTS="$1"
fi

if [ $# -ge 2 ]; then
    NAME_FILTER="$2"
fi

parse_output() {
    values=""
    while read -r raw_value; do
        key="$(echo "$raw_value" | cut -d= -f1)"
        value="$(echo "$raw_value" | cut -d= -f2-)"
        if [ -n "$values" ]; then
            values="$values,\"$key\":$value"
        else
            values="\"$key\":$value"
        fi
    done

    echo "$values"
}

try_pub() {
    topic="$1"
    payload="$2"

    attempts=0
    max_attempts=10
    failed=0
    while ! tedge mqtt pub -q 1 -r "$topic" "$payload"; do
        if [ "$attempts" -ge "$max_attempts" ]; then
            failed=1
            break
        fi
        attempts=$((attempts + 1))
        sleep 10
    done
    
    if [ "$failed" = "1" ]; then
        echo "Failed to publish message on $topic" >&2
    fi
}

_NEWLINE=$(printf '\n')
find -L "$RUN_PARTS" -type f -name "$NAME_FILTER" -perm 755 | while IFS="$_NEWLINE" read -r file
do
    echo "Executing inventory script: $file" >&2
    property=$(basename "$file" | cut -d_ -f2-)
    set +e
    OUTPUT=$("$file")
    SUCCESS=$?
    set -e

    if [ "$SUCCESS" != 0 ]; then
        echo "Inventory script failed" >&2
        continue
    fi

    if [ -z "$OUTPUT" ]; then
        echo "Inventory script did not return any values on standard output" >&2
        continue
    fi
    json_partial=$(echo "$OUTPUT" | parse_output)

    if [ -n "$json_partial" ] && [ -n "$property" ]; then
        try_pub "$TOPIC_ROOT/$TOPIC_ID/twin/$property" "{$json_partial}" >&2
    fi

    echo "Inventory script was successful" >&2
done
