#!/bin/sh

####################################
### Turn on/off the HDMI monitor ###
####################################

IS_HDMI_MONITOR_ON=$(wlr-randr | grep HDMI -A5 | tail -n 1 | grep yes | wc -l)

toggle_monitor() {
    if [ $IS_HDMI_MONITOR_ON -eq 1 ]; then
        # turn off monitor
	hyprctl keyword monitor "HDMI-A-1, disable"
    else
	# turn on monitor
	hyprctl keyword monitor "HDMI-A-1, preferable, 0x0, 1"
    fi
}

toggle_monitor
exit 0
