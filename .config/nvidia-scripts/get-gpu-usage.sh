#!/bin/sh

##################################
### Get NVIDIA GPU Utilization ###
##################################

get_gpu_usage() {
    nvidia-smi -q -d utilization | grep Gpu | awk '{print $3}'
}

get_gpu_usage
exit 0
