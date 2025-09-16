#!/bin/bash

# STOXX Index Crawler Script
# Updates local JSON file with new entries from STOXX API

: '
Variables storing date & time data are named according to their format using GNU date format specifier (https://www.gnu.org/software/coreutils/manual/html_node/Date-format-specifiers.html)
'

# Get index name from passed argument
INDEX=$1

# File prefixes
declare -A FILE_PREFIX
  FILE_PREFIX["SX5GR"]="sx5gr"
  FILE_PREFIX["SX5P"]="sx5p"
  FILE_PREFIX["SX5R"]="sx5r"

# Local JSON
LOCAL_FILE="${FILE_PREFIX[$INDEX]}_data.json"

# Temporary files
TEMP_SSV="${FILE_PREFIX[$INDEX]}_data_temp.ssv"
TEMP_JSON="${FILE_PREFIX[$INDEX]}_data_temp.json"
# NEW_ENTRIES_FILE="${FILE_PREFIX[$INDEX]}_data_new_entries.json"

# Metadata
# METADATA_FILE="${FILE_PREFIX[$INDEX]}_data_metadata.json"

# Log
LOG_FILE="STOXX_crawler.log"

# STOXX API URLs
API_URL=
API_URL_ORIGIN="https://www.stoxx.com"
API_URL_DIRECTORY="/document/Indices/Current/HistoricalData/"
declare -A API_URL_FILE
  API_URL_FILE["SX5GR"]="h_3msx5gr.txt"
  API_URL_FILE["SX5P"]="h_3msx5p.txt"
  API_URL_FILE["SX5R"]="h_3msx5r.txt"
API_URL="${API_URL_ORIGIN}${API_URL_DIRECTORY}${API_URL_FILE[$INDEX]}"

echo "$(date +%FT%H:%M:%S%:z)" >> $LOG_FILE

echo "Starting STOXX data crawler for $INDEX..." | tee -a $LOG_FILE

# Check dependencies
dependencies=("jq" "awk")
dependency_errors=0
for dependency in "${dependencies[@]}"; do
  if ! command -v $dependency &> /dev/null; then
    echo "Error: $dependency is required but not installed. Please install $dependency first." | tee -a $LOG_FILE
    notify-send "STOXX crawler" "Error: $dependency is required but not installed. Please install $dependency first."
    dependency_errors+=1
  fi
done
if [[ dependency_errors -ne 0 ]]; then
  exit 1
fi

# --- #

# Download the file
echo "Downloading data from: $API_URL"
if ! curl -s -f "$API_URL" -o "$TEMP_SSV"; then
  echo "Error: Failed to fetch data from $API_URL" | tee -a $LOG_FILE
  notify-send "STOXX $INDEX crawler" "Error: Failed to fetch API data"
  rm -f "$TEMP_SSV"
  exit 1
fi

# Check if file is empty
if [ ! -s "$TEMP_SSV" ]; then
  echo "Error: $API_URL returned empty file" | tee -a $LOG_FILE
  notify-send "STOXX $INDEX crawler" "Error: Failed to fetch API data"
  rm -f "$TEMP_SSV"
  exit 1
fi

# Convert semicolon-separated values to JSON
echo "Converting data to JSON format..." | tee -a $LOG_FILE

# Use awk to process the file and convert to JSON
awk -F';' '
BEGIN {
    print "["
    first = 1
}
NR == 1 {
    # Store header names (remove trailing semicolons and whitespace)
    for (i = 1; i <= NF; i++) {
        gsub(/;$/, "", $i)  # Remove trailing semicolon
        gsub(/^[ \t]+|[ \t]+$/, "", $i)  # Trim whitespace
        if ($i != "") {
            headers[i] = $i
        }
    }
    next
}
NF > 0 {
    # Skip empty lines
    if (NF == 1 && $1 == "") next

    # Print comma separator for all records except the first
    if (!first) print ","
    first = 0

    printf "  {"
    field_count = 0
    for (i = 1; i <= NF; i++) {
        # Clean the field value
        gsub(/;$/, "", $i)  # Remove trailing semicolon
        gsub(/^[ \t]+|[ \t]+$/, "", $i)  # Trim whitespace

        if ($i != "" && headers[i] != "") {
            if (field_count > 0) printf ", "

            # Check if the value is numeric (for proper JSON formatting)
            if ($i ~ /^[0-9]+\.?[0-9]*$/) {
                printf "\"%s\":%s", headers[i], $i
            } else {
                printf "\"%s\":\"%s\"", headers[i], $i
            }
            field_count++
        }
    }
    printf "}"
}
END {
    if (!first) print ""  # Add newline after last record
    print "]"
}' "$TEMP_SSV" > "$TEMP_JSON"

# Check if this is the first run
if [ ! -f "$LOCAL_FILE" ]; then
  echo "Local file doesn't exist. Creating initial file with all API data..." | tee -a $LOG_FILE
  cp "$TEMP_JSON" "$LOCAL_FILE"
  entry_count=$(jq 'length' "$LOCAL_FILE")
  echo "Successfully created $LOCAL_FILE with $entry_count entries" | tee -a $LOG_FILE
  notify-send "STOXX $INDEX crawler" "Successfully created $LOCAL_FILE with $entry_count entries"
else
  echo "Local file exists." | tee -a $LOG_FILE
  F_newest_local=$(jq -r '[.[] | .Date | split(".") as [$d, $m, $Y] | "\($Y)-\($m)-\($d)"] | sort | .[-1]' "$LOCAL_FILE")
  new_entries=$(jq --arg F_newest_local "$F_newest_local" '[.[] | select((.Date | split(".") as [$d, $m, $Y] | "\($Y)-\($m)-\($d)") > $F_newest_local)]' "$TEMP_JSON")
  # Check if we found new entries
  new_count=$(echo "$new_entries" | jq 'length')
  if [ "$new_count" -gt 0 ]; then
    echo "Found $new_count new entries" | tee -a $LOG_FILE

    # Merge with existing data
    jq --argjson new_entries "$new_entries" '. + $new_entries' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp"
    #jq --slurpfile new_entries $NEW_ENTRIES_FILE '. + $new_entries[0]' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp"

    if [ $? -eq 0 ]; then
      mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
      echo "Successfully added $new_count new entries to $LOCAL_FILE" | tee -a $LOG_FILE
      notify-send "STOXX $INDEX crawler" "Successfully added $new_count new entries to $LOCAL_FILE"

      # Show total count
      total_count=$(jq 'length' "$LOCAL_FILE")
      echo "Total entries in $LOCAL_FILE: $total_count" | tee -a $LOG_FILE

    else
      echo "Error: Failed to merge new entries" | tee -a $LOG_FILE
      notify-send "STOXX $INDEX crawler" "Error: Failed to merge new entries"
      rm -f "${LOCAL_FILE}.tmp" "$TEMP_JSON" "$TEMP_SSV"
      exit 1
    fi
  else
    echo "No new entries found. Local file is up to date." | tee -a $LOG_FILE
    notify-send "STOXX $INDEX crawler" "No new entries found. Local file is up to date."
  fi
fi

echo "STOXX data crawler for $INDEX completed successfully!" | tee -a $LOG_FILE

# Clean up temporary file
rm -f "$TEMP_JSON" "$TEMP_SSV"
