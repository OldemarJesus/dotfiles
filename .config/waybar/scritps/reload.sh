#!/bin/sh

# load waybar pid's
pids=$(pidof waybar)

# kill each pid
for id in $pids
do
	kill $id;
done

# initialize waybar
waybar

exit 0
