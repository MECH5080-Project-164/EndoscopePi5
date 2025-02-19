#!/usr/bin/env bash

readonly GPIO_PIN_1=2
readonly GPIO_PIN_2=3

function flash_leds {
    if [ ! -f "$HOME/scripts/led_controller.sh" ]; then
        exit 1
    fi

    if [ -n "$SSH_CONNECTION" ]; then
        exit 0
    fi

    $HOME/scripts/led_controller.sh -q 1
    sleep 0.15
    $HOME/scripts/led_controller.sh -q 0
    sleep 0.1
    $HOME/scripts/led_controller.sh -q 1
    sleep 0.15
    $HOME/scripts/led_controller.sh -q 0
}

flash_leds
exit 0

