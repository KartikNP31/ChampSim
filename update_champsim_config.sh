# Author : Kartik Niranjan Patel -  kartik.p21@iiits.in
# Indian Institute of Information Technology, Sri City, Chittoor, Andhra Pradesh, India
# BTP24 Project 
# Guide - Dr. Bheemappah Halavar
# Contributors
## Virendra Yadav - virendra.y21@iiits.in
## Udaykiran Karra - uday.k21@iiits.in

#!/bin/bash

# File name
CONFIG_FILE="champsim_config.json"

# Function to update a value in the JSON file
update_json() {
    section=$1
    parameter=$2
    new_value=$3
    index=$4

    # Check if the new value is a number or boolean
    if [[ $new_value =~ ^[0-9]+$ ]] || [[ $new_value =~ ^(true|false)$ ]]; then
        # Replace numeric or boolean values
        if [[ $section == "ooo_cpu" ]]; then
            sed -i "/\"$section\": \[/,/\]/{/$parameter/ s/\"$parameter\": [0-9a-zA-Z.-]*/\"$parameter\": $new_value/}" "$CONFIG_FILE"
        elif [[ $section == "main" ]]; then
            sed -i "/\"$parameter\":/ s/\"$parameter\": [0-9a-zA-Z.-]*/\"$parameter\": $new_value/" "$CONFIG_FILE"
        else
            sed -i "/\"$section\": {/,/}/ s/\"$parameter\": [0-9a-zA-Z.-]*/\"$parameter\": $new_value/" "$CONFIG_FILE"
        fi
    else
        # For string values, add quotes around the new value
        if [[ $section == "ooo_cpu" ]]; then
            sed -i "/\"$section\": \[/,/\]/{/$parameter/ s/\"$parameter\": \".*\"/\"$parameter\": \"$new_value\"/}" "$CONFIG_FILE"
        elif [[ $section == "main" ]]; then
            sed -i "/\"$parameter\":/ s/\"$parameter\": \".*\"/\"$parameter\": \"$new_value\"/" "$CONFIG_FILE"
        else
            sed -i "/\"$section\": {/,/}/ s/\"$parameter\": \".*\"/\"$parameter\": \"$new_value\"/" "$CONFIG_FILE"
        fi
    fi
}

# Main loop
while true; do
    # Prompt for user input
    echo "Enter the section name (e.g., L1I, L1D, L2C, ooo_cpu, main): "
    read section

    if [[ $section == "ooo_cpu" ]]; then
        # Since ooo_cpu is an array
        echo "Enter the parameter name (e.g., frequency, ifetch_buffer_size): "
        read parameter

        echo "Enter the new value for $parameter: "
        read new_value

        # Assuming the array index is 0 since there's only one element in the example
        update_json "$section" "$parameter" "$new_value" 0
    elif [[ $section == "main" ]]; then
        # Update main section parameters
        echo "Enter the parameter name (e.g., executable_name, block_size): "
        read parameter

        echo "Enter the new value for $parameter: "
        read new_value

        # Update the JSON file
        update_json "$section" "$parameter" "$new_value" 0
    else
        echo "Enter the parameter name (e.g., sets, ways, latency): "
        read parameter

        echo "Enter the new value for $parameter: "
        read new_value

        # Update the JSON file
        update_json "$section" "$parameter" "$new_value"
    fi

    echo "Updated $parameter in section $section with value $new_value."

    # Ask if the user wants to modify another parameter
    echo "Do you want to change another parameter? (yes/no): "
    read response
    case "$response" in
        [yY][eE][sS]|[yY]) ;;  # Continue the loop
        *) break ;;            # Break the loop for anything else
    esac
done

echo "Exiting the script."
