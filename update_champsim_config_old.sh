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
        else
            sed -i "/\"$section\": {/,/}/ s/\"$parameter\": [0-9a-zA-Z.-]*/\"$parameter\": $new_value/" "$CONFIG_FILE"
        fi
    else
        # For string values, add quotes around the new value
        if [[ $section == "ooo_cpu" ]]; then
            sed -i "/\"$section\": \[/,/\]/{/$parameter/ s/\"$parameter\": \".*\"/\"$parameter\": \"$new_value\"/}" "$CONFIG_FILE"
        else
            sed -i "/\"$section\": {/,/}/ s/\"$parameter\": \".*\"/\"$parameter\": \"$new_value\"/" "$CONFIG_FILE"
        fi
    fi
}

# Main loop
while true; do
    # Prompt for user input
    echo "Enter the section name (e.g., L1I, L1D, L2C, ooo_cpu): "
    read section

    if [[ $section == "ooo_cpu" ]]; then
        # Since ooo_cpu is an array, allow the user to specify which entry they want to update
        echo "Enter the parameter name (e.g., frequency, ifetch_buffer_size): "
        read parameter

        echo "Enter the new value for $parameter: "
        read new_value

        # Assuming the array index is 0 since there's only one element in the example
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