#!/bin/sh

#########################################
### Turn off then on the HDMI Monitor ###
#########################################


turn_off_then_on_hdmi_monitor() {
    wlr-randr --output HDMI-A-1 --off;
    sleep 1; # wait 1s
    wlr-randr --output HDMI-A-1 --on;
}

turn_off_then_on_hdmi_monitor
