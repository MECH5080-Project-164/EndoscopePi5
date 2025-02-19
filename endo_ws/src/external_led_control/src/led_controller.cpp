#include <memory>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>

class LedController : public rclcpp::Node {
public:
    LedController() : Node("led_controller") {
        subscription_ = this->create_subscription<std_msgs::msg::String>(
            "led_control_mode", 10,
            std::bind(&LedController::topic_callback, this, std::placeholders::_1));

        RCLCPP_INFO(this->get_logger(), "Led Controller Node started");
        RCLCPP_INFO(this->get_logger(), "Listening to led_control_mode topic");
    }

private:
    void topic_callback(const std_msgs::msg::String::SharedPtr msg) {
        RCLCPP_INFO(this->get_logger(), "Received: %s", msg->data.c_str());
        execute_script(msg->data);
    }

    void execute_script(std::string& arg) {
        std::string path_to_command = "/home/pharos/scripts/led_controller.sh";
        std::string command = "bash " + path_to_command + " " + arg;
        int result = system(command.c_str());

        if (result == 0) {
            RCLCPP_INFO(this->get_logger(), "Script executed successfully");
        } else {
            RCLCPP_ERROR(this->get_logger(), "Script execution failed with code %d", result);
        }
    }

    rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
};

int main(int argc, char * argv[]) {
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<LedController>());
    rclcpp::shutdown();
    return 0;
}
