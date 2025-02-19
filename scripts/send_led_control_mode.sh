#!/usr/bin/env bash

## A script to control the LEDs by publishing to the ROS2 topic
## Sends a single message to the topic with the LED control mode

readonly TOPIC_NAME="/led_control_mode"
readonly INPUT="$1"

function usage {
    echo "Usage: $(basename "$0") [LED_CONTROL_MODE]"
    echo "LED_CONTROL_MODE:"
    echo "  0: Turn off LEDs"
    echo "  1: 50% duty cycle"
    echo "  2: 80% duty cycle"
    echo "  3: 100% duty cycle"
    exit 1
}

function ros_init {
    if ! command -v ros2 &>/dev/null; then
        source /opt/ros/jazzy/setup.bash || {
            echo "Error: Failed to source ROS environment." >&2
            exit 1
        }
    fi
}

function validate_input {
    if [[ "$INPUT" == "-h" || "$INPUT" == "--help" ]]; then
        usage
    fi

    if [[ -z "$INPUT" ]]; then
        echo "Error: Missing LED control mode." >&2
        usage
    fi

    if ! [[ "$INPUT" =~ ^[0-3]$ ]]; then
        echo "Error: Invalid LED control mode. Must be 0, 1, 2, or 3." >&2
        exit 2
    fi
}

function publish_led_control_mode {
    ros2 topic pub -1 "$TOPIC_NAME" std_msgs/msg/String "data: \"$INPUT\"" || {
        echo "Error: Failed to publish to $TOPIC_NAME" >&2
        exit 3
    }
}

function main {
    ros_init
    validate_input
    publish_led_control_mode
}

main
