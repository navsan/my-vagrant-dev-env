#!/bin/bash

# Install kernel-specific as well as generic packages. 
kernel_ver=$(uname -r)
sudo apt-get install -y linux-tools-generic linux-cloud-tools-generic \
	linux-tools-$kernel_ver linux-cloud-tools-$kernel_ver


# To allow profiling without root privileges
sudo sh -c "echo 0 > /proc/sys/kernel/perf_event_paranoid"
sudo sh -c "echo 0 > /proc/sys/kernel/kptr_restrict"

