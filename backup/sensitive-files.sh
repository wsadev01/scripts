#!/usr/bin/env bash

saved_serial="E0D55E6CE785E6A0C93500F9"
available_partition="/dev/null"
for device in /dev/sd[a-z]; do
    # Get the serial number of the current device
    current_serial=$(udevadm info --query=all --name=$device | grep ID_SERIAL_SHORT | awk '{print $2}' | cut -d '=' -f2-)

    # Compare the current serial number with the saved one
    if [ "$current_serial" == "$saved_serial" ]; then
        echo "Match found: $device has the serial number $saved_serial"
        # Perform any actions needed on the matching device
                ## Loop through each partition of the device
        for untrimmed_partition in $(lsblk -n -o NAME "$device"); do
            # Full path of the partition
            partition=$(echo "$untrimmed_partition" | tr -cd '[:alnum:]')

            full_partition="/dev/${partition}"
            if [[ "$device" != "$full_partition" ]]; then
                echo $full_partition
                bytes=$(df --output=avail --block-size=1 "$full_partition" | tail -n1)

                available_space=$(echo "scale=2; $bytes/1073741824" | bc)
                if [ $(echo "$available_space<1.0" | bc) -eq 1 ]; then
                    echo "[!] Restoration device not having enough space"
                    exit
                else
                    echo "[+] Picking the first available partition (${full_partition})"
                    available_partition="$full_partition"
                    break
                fi
                size=$(lsblk -no SIZE "$full_partition")
                # Print the size
                echo "$size -- $available_space"
            fi
        done
        break  # Optional: Exit the loop if you only need to find the first match
    fi
done

echo "Available partition is $available_partition"
echo "TODO: The rest of the script to backup sensitive files."
