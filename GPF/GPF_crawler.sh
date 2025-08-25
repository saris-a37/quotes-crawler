#!/bin/bash

# GPF Data Crawler Script
# Updates local JSON file with new entries from Thai GPF API

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

echo "Starting GPF data crawler..."

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Please install jq first."
  exit 1
fi

# Function to fetch API data with error checking
fetch_api_data() {

  # Input month-year query range
  local LL_start=$1
  local uuuu_start=$2
  local LL_end=`date +"%m"`
  local uuuu_end=`date +"%Y"`

  # Reset API URLs list
  API_URLs=()

  # Loop through years then months to generate API URLs list within query range
  if [[ uuuu_start -ne uuuu_end ]]; then
    uuuu=$uuuu_start
    for ((LL=$((10#$LL_start));LL<=12;LL++)); do
      printf -v LL_uuuu "%02d_%04d" $LL $uuuu
      API_URL="${API_URL_BASE}${LL_uuuu}"
      API_URLs["$LL_uuuu"]=$API_URL
    done
    for ((uuuu=uuuu_start+1;uuuu<uuuu_end;uuuu++)); do
      for ((LL=1;LL<=12;LL++)); do
        printf -v LL_uuuu "%02d_%04d" $LL $uuuu
        API_URL="${API_URL_BASE}${LL_uuuu}"
        API_URLs["$LL_uuuu"]=$API_URL
      done
    done
    uuuu=$uuuu_end
    for ((LL=1;LL<=$((10#$LL_end));LL++)); do
      printf -v LL_uuuu "%02d_%04d" $LL $uuuu
      API_URL="${API_URL_BASE}${LL_uuuu}"
      API_URLs["$LL_uuuu"]=$API_URL
    done;
  else
    uuuu=$uuuu_start
    for ((LL=$((10#$LL_start));LL<=$((10#$LL_end));LL++)); do
      printf -v LL_uuuu "%02d_%04d" $LL $uuuu
      API_URL="${API_URL_BASE}${LL_uuuu}"
      API_URLs["$LL_uuuu"]=$API_URL
    done
  fi

  # Create temporary JSON file with the same format as in API using 03_1997 data as dummy
  curl -s "https://www.gpf.or.th/thai2019/About/memberfund-api.php?pageName=NAVBottom_03_1997" > "$TEMP_FILE"

  # Fetch data from API and append to temporary JSON
  unset LL_uuuu
  for LL_uuuu in "${!API_URLs[@]}"; do
    echo "Fetching $LL_uuuu data from API..."
    if curl -s "${API_URLs[$LL_uuuu]}" > "$MONTHLY_FILE"; then
      # Check if response is valid JSON
      if jq empty "$MONTHLY_FILE" 2>/dev/null; then
        echo "API data fetched successfully"
        cp "$TEMP_FILE" "$TEMP_TEMP_FILE"
        jq -s add "$TEMP_TEMP_FILE" "$MONTHLY_FILE" > "$TEMP_FILE"
      else
        echo "Error: API returned invalid JSON"
        rm -f "$MONTHLY_FILE" "$TEMP_FILE"
        return 1
      fi
    else
      echo "Error: Failed to fetch data from API"
      rm -f "$MONTHLY_FILE" "$TEMP_FILE"
      return 1
    fi
  done
  return 0
}

# Find date of newest local entry & update metadata file
find_newest_local () {

  # Get newest local date (convert dd/LL/uuuu HH:mm:ss to uuuu-LL-dd HH:mm:ss for comparison)
  local newest_local=$(jq -r '[.[] | .LAUNCH_DATE | split(" ") as [$date, $time] | ($date | split("/")) as [$dd, $LL, $uuuu] | "\($uuuu)-\($LL)-\($dd) \($time)"] | sort | .[-1]' "$LOCAL_FILE")
  echo "Latest local date: $newest_local"

  if [ ! -f "$METADATA_FILE" ]; then
    jq -n --arg nl "$newest_local" '{"newest_local": $nl}' > $METADATA_FILE
    if [ $? -eq 0 ]; then
      echo "No metadata file existed, successfully created new metadata file with updated value(s)"
      return 0
    else
      echo "No metadata file existed, failed to create new metadata file"
      return 1
    fi
  else
    jq -n --arg nl "$newest_local" '.newest_local = $nl' $METADATA_FILE > "${METADATA_FILE}.tmp"
    if [ $? -eq 0 ]; then
      mv "${METADATA_FILE}.tmp" "$METADATA_FILE"
      echo "Successfully updated metadata file"
      return 0
    else
      echo "Failed to update metadata file"
      rm -f "${METADATA_FILE}.tmp"
      return 1
    fi
  fi
}

# Check if this is the first run
if [ ! -f "$LOCAL_FILE" ]; then
  echo "Local file doesn't exist. Creating initial file with all API data..."

  # Initiate local file with entire data since 03_1997 for the first run
  if fetch_api_data 03 1997; then
    mv "$TEMP_FILE" "$LOCAL_FILE"
    entry_count=$(jq 'length' "$LOCAL_FILE")
    echo "Successfully created $LOCAL_FILE with $entry_count entries"

    # Find and update date of newest local entry
    find_newest_local

  else
    echo "Failed to create initial file"
    exit 1
  fi

else

  echo "Local file exists."

  # Query stored date of newest local entry, find if not existed
  if [ ! -f "$METADATA_FILE" ]; then
    find_newest_local
  fi
  newest_local=$(jq -r '.newest_local' $METADATA_FILE)
  newest_local_uuuu=${newest_local:0:4}
  newest_local_LL=${newest_local:5:2}
  echo "Latest local date: $newest_local"

  # Query data since latest month in local file
  echo "Checking for new entries..."
  if fetch_api_data $newest_local_LL $newest_local_uuuu; then

    # Filter API data for entries newer than newest_local
    new_entries=$(jq --arg newest_local "$newest_local" '
      [.[] | select(
        (.LAUNCH_DATE | split(" ") as [$date, $time] |
         ($date | split("/")) as [$dd, $LL, $uuuu] |
         "\($uuuu)-\($LL)-\($dd) \($time)") > $newest_local
      )]
    ' "$TEMP_FILE")

    # Check if we found new entries
    new_count=$(echo "$new_entries" | jq 'length')

    if [ "$new_count" -gt 0 ]; then
      echo "Found $new_count new entries"

      # Merge with existing data
      jq --argjson new_entries "$new_entries" '. + $new_entries' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp"

      if [ $? -eq 0 ]; then
        mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
        echo "Successfully added $new_count new entries to $LOCAL_FILE"

        # Show total count
        total_count=$(jq 'length' "$LOCAL_FILE")
        echo "Total entries in local file: $total_count"

        # Find and update date of newest local entry
        find_newest_local

      else
        echo "Error: Failed to merge new entries"
        rm -f "${LOCAL_FILE}.tmp"
        exit 1
      fi
    else
      echo "No new entries found. Local file is up to date."
    fi
  else
    echo "Failed to fetch API data"
    exit 1
  fi
fi

echo "GPF data crawler completed successfully!"

# Clean up temporary files
rm -f "$MONTHLY_FILE" "$TEMP_FILE" "$TEMP_TEMP_FILE"
