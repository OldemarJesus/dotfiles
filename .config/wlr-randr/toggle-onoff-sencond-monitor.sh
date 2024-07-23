#!/bin/sh

####################################
### Turn on/off the HDMI monitor ###
####################################

IS_HDMI_MONITOR_ON=$(wlr-randr | grep HDMI -A5 | tail -n 1 | grep yes | wc -l)

toggle_monitor() {
    if [ $IS_HDMI_MONITOR_ON -eq 1 ]; then
        # turn off monitor
	wlr-randr --output HDMI-A-1 --off	
    else
	# turn on monitor
	wlr-randr --output HDMI-A-1 --on
    fi
}

toggle_monitor
exit 0
