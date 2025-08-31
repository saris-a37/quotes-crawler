#!/bin/bash

# ThaiBMA Bond Price MTM Data Crawler Script
# Updates local JSON file with new entries from ThaiBMA Bond Price MTM

: '
Variables storing date & time data are named according to their format using GNU date format specifier (https://www.gnu.org/software/coreutils/manual/html_node/Date-format-specifiers.html)
'

# Local JSON
LOCAL_JSON="thaibma_bond_price_mtm_data.json"

# ThaiBMA Bond Price MTM API URLs
API_URL=
declare -A API_URLs
API_URL_ORIGIN="https://www.thaibma.or.th"
API_URL_DIRECTORY="/download/monthly/m2m"
API_URL_FILE_BASE="/ThaiBMA_MarktoMarket_MonthEnd_"
API_URL_FILE_EXTENSION=".pdf"
API_URL_BASE="${API_URL_ORIGIN}${API_URL_DIRECTORY}${API_URL_FILE_BASE}"

# Temporary files
TEMP_JSON="thaibma_bond_price_mtm_data_temp.json"
TEMP_TEMP_JSON="thaibma_bond_price_mtm_data_temp_temp.json"
MONTHLY_JSON="thaibma_bond_price_mtm_data_monthly.json"
MONTHLY_PDF="thaibma_bond_price_mtm_data_monthly.pdf"

# Metadata
METADATA_FILE="thaibma_bond_price_mtm_data_metadata.json"

# Log
LOG_FILE="ThaiBMA_Bond_Price_MTM_crawler.log"

echo "$(date +%FT%H:%M:%S%:z)" >> $LOG_FILE

echo "Starting ThaiBMA Bond Price MTM data crawler..." | tee -a $LOG_FILE

# Check dependencies
dependencies=("jq" "python")
dependency_errors=0
for dependency in "${dependencies[@]}"; do
  if ! command -v $dependency &> /dev/null; then
    echo "Error: $dependency is required but not installed. Please install $dependency first." | tee -a $LOG_FILE
    notify-send "ThaiBMA Bond Price MTM crawler" "Error: $dependency is required but not installed. Please install $dependency first."
    dependency_errors+=1
  fi
done
if [[ dependency_errors -ne 0 ]]; then
  exit 1
fi

# Function to fetch API data with error checking
fetch_api_data() {

  # Input month-year query range
  local dmY_start=$1
  local F_start=$(date -d "${dmY_start:4:4}-${dmY_start:2:2}-${dmY_start:0:2}" +"%F")
  local F_end=`date +"%F"`

  # Reset API URLs list
  API_URLs=()

  # Loop through monthends to generate API URLs list within query range
  F=$F_start
  until [[ $F > $F_end ]]; do
    dmY=$(date -d $F +"%d%m%Y")
    API_URL="${API_URL_BASE}${dmY}${API_URL_FILE_EXTENSION}"
    API_URLs["$dmY"]=$API_URL
    F=$(date -d "$F + 1 day" +"%F")
    F=$(date -d "$F + 1 month" +"%F")
    F=$(date -d "$F - 1 day" +"%F")
  done

  # Create temporary JSON file with the same format as in API using 31082009 data as dummy
  curl -s "https://www.thaibma.or.th/download/monthly/m2m/ThaiBMA_MarktoMarket_MonthEnd_31082009.pdf" > "$MONTHLY_PDF"
  python ThaiBMA_Bond_Price_MTM_PDF_table_to_JSON.py $MONTHLY_PDF 31082009
  cp "$MONTHLY_JSON" "$TEMP_JSON"

  # Fetch data from API and append to temporary JSON
  unset dmY
  success_counter=0
  for dmY in "${!API_URLs[@]}"; do
    echo "Fetching $dmY data from API..." | tee -a $LOG_FILE
    if curl -s "${API_URLs[$dmY]}" > "$MONTHLY_PDF"; then
      # Check if response is valid PDF
      if [[ $(head -c 4 "$MONTHLY_PDF") == "%PDF" ]]; then
        python ThaiBMA_Bond_Price_MTM_PDF_table_to_JSON.py $MONTHLY_PDF $dmY
        # Check if PDF is converted to valid JSON
        if jq empty "$MONTHLY_JSON" 2>/dev/null; then
          cp "$TEMP_JSON" "$TEMP_TEMP_JSON"
          jq -s add "$TEMP_TEMP_JSON" "$MONTHLY_JSON" > "$TEMP_JSON"
          if [ $? -eq 0 ]; then
            echo "PDF fetched, converted, & merged to $TEMP_JSON successfully" | tee -a $LOG_FILE
            success_counter+=1
          else
            echo "Error: Failed to merge fetched data to $TEMP_JSON" | tee -a $LOG_FILE
            rm -f "$MONTHLY_PDF" "$MONTHLY_JSON" "$TEMP_TEMP_FILE"
          fi
        else
          echo "Error: PDF fetched but conversion to JSON failed" | tee -a $LOG_FILE
          rm -f "$MONTHLY_PDF" "$MONTHLY_JSON"
        fi
      else
        echo "Error: Failed to fetch PDF" | tee -a $LOG_FILE
        rm -f "$MONTHLY_PDF" "$MONTHLY_JSON"
      fi
    else
      echo "Error: Failed to fetch PDF" | tee -a $LOG_FILE
      rm -f "$MONTHLY_PDF" "$MONTHLY_JSON"
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

  # Get newest local date (convert dd/m/Y to Y-m-dd for comparison)
  local F_newest_local=$(jq -r '[.[] | .["As of"] | (.[4:8] + "-" + .[2:4] + "-" + .[0:2])] | sort | .[-1]' "$LOCAL_JSON")
  echo "Latest local date: $F_newest_local" | tee -a $LOG_FILE

  if [ ! -f "$METADATA_FILE" ]; then
    jq -n --arg nl "$F_newest_local" '{"newest_local": $nl}' > $METADATA_FILE
    if [ $? -eq 0 ]; then
      echo "No metadata file existed, successfully created new metadata file with updated value(s)" | tee -a $LOG_FILE
      notify-send "ThaiBMA Bond Price MTM crawler" "No metadata file existed, successfully created new metadata file with updated value(s)"
      return 0
    else
      echo "Error: No metadata file existed, failed to create new metadata file" | tee -a $LOG_FILE
      notify-send "ThaiBMA Bond Price MTM crawler" "Error: No metadata file existed, failed to create new metadata file"
      return 1
    fi
  else
    jq -n --arg nl "$F_newest_local" '.newest_local = $nl' $METADATA_FILE > "${METADATA_FILE}.tmp"
    if [ $? -eq 0 ]; then
      mv "${METADATA_FILE}.tmp" "$METADATA_FILE"
      echo "Successfully updated metadata file" | tee -a $LOG_FILE
      notify-send "ThaiBMA Bond Price MTM crawler" "Successfully updated metadata file"
      return 0
    else
      echo "Error: Failed to update metadata file" | tee -a $LOG_FILE
      notify-send "ThaiBMA Bond Price MTM crawler" "Error: Failed to update metadata file"
      rm -f "${METADATA_FILE}.tmp"
      return 1
    fi
  fi
}

# Check if this is the first run
if [ ! -f "$LOCAL_JSON" ]; then
  echo "Local file doesn't exist. Creating initial file with all API data..." | tee -a $LOG_FILE

  # Initiate local file with entire data since 31082009 for the first run
  if fetch_api_data "31082009"; then
    mv "$TEMP_JSON" "$LOCAL_JSON"
    entry_count=$(jq 'length' "$LOCAL_JSON")
    echo "Successfully created $LOCAL_JSON with $entry_count entries" | tee -a $LOG_FILE
    notify-send "ThaiBMA Bond Price MTM crawler" "Successfully created $LOCAL_JSON with $entry_count entries"

    # Find and update date of newest local entry
    find_newest_local

  else
    echo "Error: Failed to create initial file" | tee -a $LOG_FILE
    notify-send "ThaiBMA Bond Price MTM crawler" "Error: Failed to create initial file"
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
  if fetch_api_data "${F_newest_local:8:2}${F_newest_local:5:2}${F_newest_local:0:4}"; then

    # Filter API data for entries newer than newest_local
    new_entries=$(jq --arg F_newest_local "$F_newest_local" '
      [.[] | select(
        (.["As of"] | (.[4:8] + "-" + .[2:4] + "-" + .[0:2])) > $F_newest_local
      )]
    ' "$TEMP_JSON")

    if [ "$new_count" -gt 0 ]; then
      echo "Found $new_count new entries" | tee -a $LOG_FILE

      # Merge with existing data
      jq --argjson new_entries "$new_entries" '. + $new_entries' "$LOCAL_JSON" > "${LOCAL_JSON}.tmp"

      if [ $? -eq 0 ]; then
        mv "${LOCAL_JSON}.tmp" "$LOCAL_JSON"
        echo "Successfully added $new_count new entries to $LOCAL_JSON" | tee -a $LOG_FILE
        notify-send "ThaiBMA Bond Price MTM crawler" "Successfully added $new_count new entries to $LOCAL_JSON"

        # Show total count
        total_count=$(jq 'length' "$LOCAL_JSON")
        echo "Total entries in $LOCAL_JSON: $total_count" | tee -a $LOG_FILE

        # Find and update date of newest local entry
        find_newest_local

      else
        echo "Error: Failed to merge new entries" | tee -a $LOG_FILE
        notify-send "ThaiBMA Bond Price MTM crawler" "Error: Failed to merge new entries"
        rm -f "${LOCAL_JSON}.tmp"
        exit 1
      fi
    else
      echo "No new entries found. Local file is up to date." | tee -a $LOG_FILE
      notify-send "ThaiBMA Bond Price MTM crawler" "No new entries found. Local file is up to date."
    fi
  else
    echo "Error: fetch_api_data encountered error" | tee -a $LOG_FILE
    notify-send "ThaiBMA Bond Price MTM crawler" "Error: fetch_api_data encountered error"
    exit 1
  fi
fi

echo "ThaiBMA Bond Price MTM data crawler completed successfully!" | tee -a $LOG_FILE

# Clean up temporary files
rm -f "$MONTHLY_JSON" "$MONTHLY_PDF" "$TEMP_JSON" "$TEMP_TEMP_JSON"
