cmake_minimum_required(VERSION 3.8)
project(external_led_control)

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
# uncomment the following section in order to fill in
# further dependencies manually.
# find_package(<dependency> REQUIRED)
# find_library(wiringPi_LIB wiringPi)

add_executable(led_controller src/led_controller.cpp)
ament_target_dependencies(led_controller "rclcpp" "std_msgs")
# target_link_libraries(led_controller ${wiringPi_LIB})

install(TARGETS
	led_controller
	DESTINATION lib/${PROJECT_NAME}
)
ament_package()
