#!/bin/bash

# GPF Data Crawler Script
# Updates local JSON file with new entries from Thai GPF API

: '
Variables storing date & time data are named according to their format using GNU date format specifier (https://www.gnu.org/software/coreutils/manual/html_node/Date-format-specifiers.html)
'

# Local JSON
LOCAL_FILE="gpf_data.json"

# Thai GPF API URLs
API_URL=
declare -A API_URLs
API_URL_ORIGIN="https://www.gpf.or.th"
API_URL_PATH="/thai2019/About/memberfund-api.php"
API_URL_SEARCH_BASE="?pageName=NAVBottom_"
API_URL_BASE="${API_URL_ORIGIN}${API_URL_PATH}${API_URL_SEARCH_BASE}"

# Temporary files
TEMP_FILE="gpf_data_temp.json"
TEMP_TEMP_FILE="gpf_data_temp_temp.json"
MONTHLY_FILE="gpf_data_monthly.json"

# Metadata
METADATA_FILE="gpf_data_metadata.json"

# Log
LOG_FILE="GPF_crawler.log"

echo "$(date +%FT%H:%M:%S%:z)" >> $LOG_FILE

echo "Starting GPF data crawler..." | tee -a $LOG_FILE

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Please install jq first." | tee -a $LOG_FILE
  notify-send "GPF crawler" "Error: jq is required but not installed. Please install jq first."
  exit 1
fi

# Function to fetch API data with error checking
fetch_api_data() {

  # Input month-year query range
  local m_Y_start=$1
  local F_start=$(date -d "${m_Y_start:3:4}-${m_Y_start:0:2}-01" +"%F")
  local F_end=`date +"%F"`

  # Reset API URLs list
  API_URLs=()

  # Loop through months to generate API URLs list within query range
  local F=$F_start
  until [[ $F > $F_end ]]; do
    m_Y=$(date -d $F +"%m_%Y")
    API_URL="${API_URL_BASE}${m_Y}"
    API_URLs["$m_Y"]=$API_URL
    F=$(date -d "$F + 1 month" +"%F")
  done

  # Create temporary JSON file with the same format as in API using 03_1997 data as dummy
  curl -s "https://www.gpf.or.th/thai2019/About/memberfund-api.php?pageName=NAVBottom_03_1997" > "$TEMP_FILE"

  # Fetch data from API and append to temporary JSON
  unset m_Y
  success_counter=0
  for m_Y in "${!API_URLs[@]}"; do
    echo "Fetching $m_Y data from API..." | tee -a $LOG_FILE
    if curl -s "${API_URLs[$m_Y]}" > "$MONTHLY_FILE"; then
      # Check if response is valid JSON
      if jq empty "$MONTHLY_FILE" 2>/dev/null; then
        cp "$TEMP_FILE" "$TEMP_TEMP_FILE"
        jq -s add "$TEMP_TEMP_FILE" "$MONTHLY_FILE" > "$TEMP_FILE"
        if [ $? -eq 0 ]; then
          echo "API data fetched & merged to $TEMP_FILE successfully" | tee -a $LOG_FILE
          success_counter+=1
        else
          echo "Error: Failed to merge fetched data to $TEMP_FILE" | tee -a $LOG_FILE
          rm -f "$MONTHLY_FILE" "$TEMP_TEMP_FILE"
        fi
      else
        echo "Error: API returned invalid JSON" | tee -a $LOG_FILE
        rm -f "$MONTHLY_FILE"
      fi
    else
      echo "Error: Failed to fetch data from API" | tee -a $LOG_FILE
      rm -f "$MONTHLY_FILE"
    fi
  done
  # The function fails only if no JSON entry is generated at all; else proceeds with any number of entries generated regardless of failure.
  if [[ success_counter -eq 0 ]]; then
    return 1
  else
    return 0
  fi
}

# Find date of newest local entry & update metadata file
find_newest_local () {

  # Get newest local date (convert dd/m/Y HH:mm:ss to Y-m-dd HH:mm:ss for comparison)
  local F_newest_local=$(jq -r '[.[] | .LAUNCH_DATE | split(" ") as [$date, $time] | ($date | split("/")) as [$d, $m, $Y] | "\($Y)-\($m)-\($d)"] | sort | .[-1]' "$LOCAL_FILE")
  echo "Latest local date: $F_newest_local" | tee -a $LOG_FILE

  if [ ! -f "$METADATA_FILE" ]; then
    jq -n --arg nl "$F_newest_local" '{"newest_local": $nl}' > $METADATA_FILE
    if [ $? -eq 0 ]; then
      echo "No metadata file existed, successfully created new metadata file with updated value(s)" | tee -a $LOG_FILE
      notify-send "GPF crawler" "No metadata file existed, successfully created new metadata file with updated value(s)"
      return 0
    else
      echo "Error: No metadata file existed, failed to create new metadata file" | tee -a $LOG_FILE
      notify-send "GPF crawler" "Error: No metadata file existed, failed to create new metadata file"
      return 1
    fi
  else
    jq -n --arg nl "$F_newest_local" '.newest_local = $nl' $METADATA_FILE > "${METADATA_FILE}.tmp"
    if [ $? -eq 0 ]; then
      mv "${METADATA_FILE}.tmp" "$METADATA_FILE"
      echo "Successfully updated metadata file" | tee -a $LOG_FILE
      notify-send "GPF crawler" "Successfully updated metadata file"
      return 0
    else
      echo "Error: Failed to update metadata file" | tee -a $LOG_FILE
      notify-send "GPF crawler" "Error: Failed to update metadata file"
      rm -f "${METADATA_FILE}.tmp"
      return 1
    fi
  fi
}

# Check if this is the first run
if [ ! -f "$LOCAL_FILE" ]; then
  echo "Local file doesn't exist. Creating initial file with all API data..." | tee -a $LOG_FILE

  # Initiate local file with entire data since 03_1997 for the first run
  if fetch_api_data "03_1997"; then
    mv "$TEMP_FILE" "$LOCAL_FILE"
    entry_count=$(jq 'length' "$LOCAL_FILE")
    echo "Successfully created $LOCAL_FILE with $entry_count entries" | tee -a $LOG_FILE
    notify-send "GPF crawler" "Successfully created $LOCAL_FILE with $entry_count entries"

    # Find and update date of newest local entry
    find_newest_local

  else
    echo "Error: Failed to create initial file" | tee -a $LOG_FILE
    notify-send "GPF crawler" "Error: Failed to create initial file"
    rm -f "$MONTHLY_FILE" "$TEMP_FILE" "$TEMP_TEMP_FILE"
    exit 1
  fi

else

  echo "Local file exists." | tee -a $LOG_FILE

  # Query stored date of newest local entry, find if not existed
  if [ ! -f "$METADATA_FILE" ]; then
    find_newest_local
  fi
  F_newest_local=$(jq -r '.newest_local' $METADATA_FILE)
  echo "Latest local date: $F_newest_local" | tee -a $LOG_FILE

  # Query data since latest month in local file
  echo "Checking for new entries..." | tee -a $LOG_FILE
  if fetch_api_data "${F_newest_local:5:2}_${F_newest_local:0:4}"; then

    # Filter API data for entries newer than newest_local
    new_entries=$(jq --arg F_newest_local "$F_newest_local" '
      [.[] | select(
        (.LAUNCH_DATE | split(" ") as [$date, $time] |
         ($date | split("/")) as [$d, $m, $Y] |
         "\($Y)-\($m)-\($d)") > $F_newest_local
      )]
    ' "$TEMP_FILE")

    # Check if we found new entries
    new_count=$(echo "$new_entries" | jq 'length')

    if [ "$new_count" -gt 0 ]; then
      echo "Found $new_count new entries" | tee -a $LOG_FILE

      # Merge with existing data
      jq --argjson new_entries "$new_entries" '. + $new_entries' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp"

      if [ $? -eq 0 ]; then
        mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
        echo "Successfully added $new_count new entries to $LOCAL_FILE" | tee -a $LOG_FILE
        notify-send "GPF crawler" "Successfully added $new_count new entries to $LOCAL_FILE"

        # Show total count
        total_count=$(jq 'length' "$LOCAL_FILE")
        echo "Total entries in $LOCAL_FILE: $total_count" | tee -a $LOG_FILE

        # Find and update date of newest local entry
        find_newest_local

      else
        echo "Error: Failed to merge new entries" | tee -a $LOG_FILE
        notify-send "GPF crawler" "Error: Failed to merge new entries"
        rm -f "${LOCAL_FILE}.tmp" "$MONTHLY_FILE" "$TEMP_FILE" "$TEMP_TEMP_FILE"
        exit 1
      fi
    else
      echo "No new entries found. Local file is up to date." | tee -a $LOG_FILE
      notify-send "GPF crawler" "No new entries found. Local file is up to date."
    fi
  else
    echo "Error: Failed to fetch API data" | tee -a $LOG_FILE
    notify-send "GPF crawler" "Error: Failed to fetch API data"
    rm -f "$MONTHLY_FILE" "$TEMP_FILE" "$TEMP_TEMP_FILE"
    exit 1
  fi
fi

echo "GPF data crawler completed successfully!" | tee -a $LOG_FILE

# Clean up temporary files
rm -f "$MONTHLY_FILE" "$TEMP_FILE" "$TEMP_TEMP_FILE"
