#!/usr/bin/env bash
## Script to control pins 2 and 3 on the Raspberry Pi to turn on and off the LEDs

readonly GPIO_PIN_1=2
readonly GPIO_PIN_2=3
INVERT_SIGNAL=1
VERBOSE=0
QUIET=0

function print_help {
    cat << EOF
    Usage: $(basename "$0") [OPTIONS] COMMAND"

    Control the External LEDs on the Endoscope Chassis

    Commands:
        0: Turn off both LEDs
        1: Turn on LED 1
        2: Turn on LED 2
        3: Turn on both LEDs

    Options:
        -h: Display this help message
        -v: Enable verbose logging
        -q: Quiet mode
        -i: Invert signal for GPIO pins (on by default)
EOF
}

function log {
    if [ $VERBOSE -eq 1 ]; then
        echo "[INFO] $@"
    fi
}

function error {
    echo "[ERROR] $1" >&2
    exit 1
}

function print_state {
    local state1=$(gpio -g read $GPIO_PIN_1)
    local state2=$(gpio -g read $GPIO_PIN_2)
    echo "GPIO$GPIO_PIN_1: $state1"
    echo "GPIO$GPIO_PIN_2: $state2"
}

function write_pin {
    local pin=$1
    local state=$2
    if [ $INVERT_SIGNAL -eq 1 ]; then
        state=$((1 - state))
    fi

    if ! gpio -g write "$pin" "$state"; then
        error "Failed to write to GPIO$pin"
    fi

    log "Wrote $state to GPIO$pin"
}

function init_pins {
    if ! command -v gpio >/dev/null 2>&1; then
        error "gpio command not found. Please install wiringpi."
    fi

    if ! gpio -g mode $GPIO_PIN_1 out || ! gpio -g mode $GPIO_PIN_2 out; then
        error "Failed to initialize GPIO pins"
    fi

    log "Initialised GPIO pins"
}

init_pins

# Main script
while getopts "hviq" opt; do
    case $opt in
        h)
            print_help
            exit 0
            ;;
        v)
            VERBOSE=1
            ;;
        i)
            INVERT_SIGNAL=0
            log "Inverting signal"
            ;;
        q)
            QUIET=1
            ;;
        \?)
            error "Invalid option: -$OPTARG"
            ;;
    esac
done

shift $((OPTIND-1))

if [ $# -ne 1 ]; then
    error "Invalid number of arguments"
fi

case $1 in
    0)
        write_pin $GPIO_PIN_1 0
        write_pin $GPIO_PIN_2 0
        ;;
    1)
        write_pin $GPIO_PIN_1 1
        write_pin $GPIO_PIN_2 0
        ;;
    2)
        write_pin $GPIO_PIN_1 0
        write_pin $GPIO_PIN_2 1
        ;;
    3)
        write_pin $GPIO_PIN_1 1
        write_pin $GPIO_PIN_2 1
        ;;
    *)
        error "Invalid argument"
        ;;
esac

if [ $QUIET -eq 0 ]; then
    print_state
fi

exit 0
