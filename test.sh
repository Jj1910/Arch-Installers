#!/bin/bash

setfont ter-132n

efi=$(ls /sys/firmware/efi/efivars)

if [${efi} = "0"]
then
    echo "Not Booting in EFI Mode, quitting..."
    return 1
fi

echo "Booted in EFI Mode"
