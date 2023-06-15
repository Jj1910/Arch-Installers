#!/bin/bash

setfont ter-132n

timedatectl set-timezone America/New_York

lsblk

echo "Enter block device"

read blockdevice

cfdisk $blockdevice
