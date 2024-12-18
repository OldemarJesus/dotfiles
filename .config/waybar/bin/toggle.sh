#!/bin/sh

##########################################
# Will kill or start waybar dependenging #
# its current state                      #
##########################################

# check if its is running
WAYBAR_PROC=$(pidof waybar)

if [[ $WAYBAR_PROC -gt 0 ]]; then
  kill -9 $WAYBAR_PROC
else
  waybar &
fi
