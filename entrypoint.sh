#!/bin/sh

child=1
exit_code=0

RELOAD_SIGNAL=${RELOAD_SIGNAL:-"HUP"}
TERM_SIGNAL=${TERM_SIGNAL:-"TERM"}

_watch_files() {
    if [ -z "${WATCH_FILES}" ]; then
        return
    fi
    inotifywait \
        -e modify \
        -m \
        ${WATCH_FILES} \
        | while read path action file; do
            echo "Sending $RELOAD_SIGNAL to $child as file $file has $action."
            kill -"$RELOAD_SIGNAL" "$child" 2>/dev/null
        done
}

_handle_term() {
    echo "Caught SIGTERM, sending $TERM_SIGNAL to pid $child"
    kill -"$TERM_SIGNAL" "$child" 2>/dev/null
}

trap _handle_term SIGTERM
trap _handle_term SIGINT

wrap() {
    echo "Starting child process..."
    echo "Executing: $@ &"
    $@ &
    child=$!
    _watch_files &

    echo "Child process started with pid $child"
    wait $child
    wait $child
    exit_code=$?
    echo "Child process $child exited with status $exit_code"
}

if [ $# -eq 0 ]; then
    echo "$0: no command specified. exiting..."
    exit 1
fi

wrap $@
exit $exit_code
