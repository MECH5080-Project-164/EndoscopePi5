#!/usr/bin/env bash

function ros_init {
    if ! command -v ros2 &>/dev/null; then
        source /opt/ros/jazzy/setup.bash || {
            echo "Error: Failed to source ROS environment." >&2
            exit 1
        }
    fi
}

ros_init
ros2 launch realsense2_camera rs_launch.py enable_gyro:=true enable_accel:=true
