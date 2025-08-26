#!/bin/bash

# ThaiBMA Bond Price MTM Data Crawler Script
# Updates local JSON file with new entries from ThaiBMA Bond Price MTM

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

echo "Starting ThaiBMA Bond Price MTM data crawler..."

# Check dependencies
dependencies=("jq" "python")
dependency_errors=0
for dependency in "${dependencies[@]}"; do
  if ! command -v $dependency &> /dev/null; then
    echo "Error: $dependency is required but not installed. Please install $dependency first."
    dependency_errors+=1
  fi
  if [[ dependency_errors -ne 0 ]]; then
    exit 1
  fi
done

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
  declare -A last_dd
    last_dd[1]="31"
    last_dd[3]="31"
    last_dd[4]="30"
    last_dd[5]="31"
    last_dd[6]="30"
    last_dd[7]="31"
    last_dd[8]="31"
    last_dd[9]="30"
    last_dd[10]="31"
    last_dd[11]="30"
    last_dd[12]="31"
  if [[ uuuu_start -ne uuuu_end ]]; then
    uuuu=$uuuu_start
    for ((LL=$((10#$LL_start));LL<=12;LL++)); do
      if [[ LL -eq 2 ]]; then
        if [[ uuuu%4 -eq 0 ]]; then
          printf -v ddLLuuuu "29%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        else
          printf -v ddLLuuuu "28%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        fi
      else
        printf -v ddLLuuuu ${last_dd[$LL]}"%02d%04d" $LL $uuuu
        API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
        API_URLs["$ddLLuuuu"]=$API_URL
      fi
    done
    for ((uuuu=uuuu_start+1;uuuu<uuuu_end;uuuu++)); do
      for ((LL=1;LL<=12;LL++)); do
        if [[ LL -eq 2 ]]; then
          if [[ uuuu%4 -eq 0 ]]; then
            printf -v ddLLuuuu "29%02d%04d" $LL $uuuu
            API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
            API_URLs["$ddLLuuuu"]=$API_URL
          else
            printf -v ddLLuuuu "28%02d%04d" $LL $uuuu
            API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
            API_URLs["$ddLLuuuu"]=$API_URL
          fi
        else
          printf -v ddLLuuuu ${last_dd[$LL]}"%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        fi
      done
    done
    uuuu=$uuuu_end
    for ((LL=1;LL<=$((10#$LL_end));LL++)); do
      if [[ LL -eq 2 ]]; then
        if [[ uuuu%4 -eq 0 ]]; then
          printf -v ddLLuuuu "29%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        else
          printf -v ddLLuuuu "28%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        fi
      else
        printf -v ddLLuuuu ${last_dd[$LL]}"%02d%04d" $LL $uuuu
        API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
        API_URLs["$ddLLuuuu"]=$API_URL
      fi
    done;
  else
    uuuu=$uuuu_start
    for ((LL=$((10#$LL_start));LL<=$((10#$LL_end));LL++)); do
      if [[ LL -eq 2 ]]; then
        if [[ uuuu%4 -eq 0 ]]; then
          printf -v ddLLuuuu "29%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        else
          printf -v ddLLuuuu "28%02d%04d" $LL $uuuu
          API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
          API_URLs["$ddLLuuuu"]=$API_URL
        fi
      else
        printf -v ddLLuuuu ${last_dd[$LL]}"%02d%04d" $LL $uuuu
        API_URL="${API_URL_BASE}${ddLLuuuu}${API_URL_FILE_EXTENSION}"
        API_URLs["$ddLLuuuu"]=$API_URL
      fi
    done
  fi

  # Create temporary JSON file with the same format as in API using 31082009 data as dummy
  curl -s "https://www.thaibma.or.th/download/monthly/m2m/ThaiBMA_MarktoMarket_MonthEnd_31082009.pdf" > "$MONTHLY_PDF"
  python ThaiBMA_Bond_Price_MTM_PDF_table_to_JSON.py $MONTHLY_PDF 31082009
  cp "$MONTHLY_JSON" "$TEMP_JSON"

  # Fetch data from API and append to temporary JSON
  unset ddLLuuuu
  for ddLLuuuu in "${!API_URLs[@]}"; do
    echo "Fetching $ddLLuuuu data from API..."
    if curl -s "${API_URLs[$ddLLuuuu]}" > "$MONTHLY_PDF"; then
      # Check if response is valid PDF
      if [[ $(head -c 4 "$FILE") == "%PDF" ]]; then
        echo "PDF fetched successfully"
        python ThaiBMA_Bond_Price_MTM_PDF_table_to_JSON.py $MONTHLY_PDF $ddLLuuuu
        # Check if PDF is converted to valid JSON
        if jq empty "$MONTHLY_JSON" 2>/dev/null; then
          echo "PDF converted to JSON successfully"
          cp "$TEMP_JSON" "$TEMP_TEMP_JSON"
          jq -s add "$TEMP_TEMP_JSON" "$MONTHLY_JSON" > "$TEMP_JSON"
        else
          echo "Error: PDF fetched but conversion to JSON failed"
          rm -f "$MONTHLY_PDF" "$MONTHLY_JSON" "$TEMP_JSON"
          return 1
        fi
      else
        echo "Error: Failed to fetch PDF"
        rm -f "$MONTHLY_PDF" "$MONTHLY_JSON" "$TEMP_JSON"
        return 1
      fi
    else
      echo "Error: Failed to fetch PDF"
      rm -f "$MONTHLY_PDF" "$MONTHLY_JSON" "$TEMP_JSON"
      return 1
    fi
  done
  return 0
}

# Find date of newest local entry & update metadata file
find_newest_local () {

  # Get newest local date (convert dd/LL/uuuu HH:mm:ss to uuuu-LL-dd HH:mm:ss for comparison)
  local newest_local=$(jq -r '[.[] | .["As of"] | (.[4:8] + .[2:4] + .[0:2])] | sort | .[-1]' "$LOCAL_JSON")
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
if [ ! -f "$LOCAL_JSON" ]; then
  echo "Local file doesn't exist. Creating initial file with all API data..."

  # Initiate local file with entire data since 31082009 for the first run
  if fetch_api_data 08 2009; then
    mv "$TEMP_JSON" "$LOCAL_JSON"
    entry_count=$(jq 'length' "$LOCAL_JSON")
    echo "Successfully created $LOCAL_JSON with $entry_count entries"

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
  newest_local_LL=${newest_local:4:2}
  echo "Latest local date: $newest_local"

  # Query data since latest month in local file
  echo "Checking for new entries..."
  if fetch_api_data $newest_local_LL $newest_local_uuuu; then

    # Filter API data for entries newer than newest_local
    new_entries=$(jq --arg newest_local "$newest_local" '
      [.[] | select(
        (.["As of"] | (.[4:8] + .[2:4] + .[0:2])) > $newest_local
      )]
    ' "$TEMP_JSON")

    if [ "$new_count" -gt 0 ]; then
      echo "Found $new_count new entries"

      # Merge with existing data
      jq --argjson new_entries "$new_entries" '. + $new_entries' "$LOCAL_JSON" > "${LOCAL_JSON}.tmp"

      if [ $? -eq 0 ]; then
        mv "${LOCAL_JSON}.tmp" "$LOCAL_JSON"
        echo "Successfully added $new_count new entries to $LOCAL_JSON"

        # Show total count
        total_count=$(jq 'length' "$LOCAL_JSON")
        echo "Total entries in local file: $total_count"

        # Find and update date of newest local entry
        find_newest_local

      else
        echo "Error: Failed to merge new entries"
        rm -f "${LOCAL_JSON}.tmp"
        exit 1
      fi
    else
      echo "No new entries found. Local file is up to date."
    fi
  else
    echo "fetch_api_data encountered error"
    exit 1
  fi
fi

echo "ThaiBMA Bond Price MTM data crawler completed successfully!"

# Clean up temporary files
rm -f "$MONTHLY_JSON" "$MONTHLY_PDF" "$TEMP_JSON" "$TEMP_TEMP_JSON"
