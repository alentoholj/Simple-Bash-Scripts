#!/bin/bash

# Base filename
base_filename="prod"
end_filename="_2222"
# Create 5 files with different dates between 2022-10-01 and 2023-01-01
for i in {1..5}; do
    # Generate a random number of days between 0 and 365
    random_days=$((RANDOM % 365))

    # Calculate the date by adding the random number of days to the start date
    start_date="2022-10-01"
    random_date=$(date -d "$start_date + $random_days days" +'%Y-%m-%d')

    # Create the filename by concatenating the base filename and the random date
    filename="$base_filename$random_date$end_filename.log"

    # Create an empty file with the generated filename
    touch "$filename"

    echo "Created file: $filename"
done

