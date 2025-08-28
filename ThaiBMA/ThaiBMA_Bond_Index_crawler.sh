#!/bin/bash

# ThaiBMA Bond Index Crawler Script
# Updates local JSON file with new entries from ThaiBMA API

: '
Variables storing date & time data are named according to their format using GNU date format specifier (https://www.gnu.org/software/coreutils/manual/html_node/Date-format-specifiers.html)
'

# Get index name from passed argument
INDEX=$1

# File prefixes
declare -A FILE_PREFIX
  FILE_PREFIX["corp"]="thaibma_index_isShowSubGroup-false"
  FILE_PREFIX["comp"]="thaibma_CompositeIndex_IndexType-Composite(Corp)"
  FILE_PREFIX["ZRR"]="thaibma_zrrindex_ratingName-RF"
  FILE_PREFIX["TB"]="thaibma_index_bondtype-TB"
  FILE_PREFIX["CP"]="thaibma_index_bondtype-CP"
  FILE_PREFIX["gov-shortterm"]="thaibma_index_bondtype-shortterm"
  FILE_PREFIX["gov-MTM"]="thaibma_index_bondtype-GOV-MTM"
  FILE_PREFIX["corp-MTM"]="thaibma_index_bondtype-corporate"
  FILE_PREFIX["corp-fixedterm"]="thaibma_index_bondtype-FixedTerm-Corporate"
  FILE_PREFIX["ESG"]="thaibma_index_bondtype-esg"
  FILE_PREFIX["a3gbi"]="thaibma_a3gbi"

# Local JSON
LOCAL_FILE="${FILE_PREFIX[$INDEX]}_data.json"

# Temporary files
TEMP_FILE="${FILE_PREFIX[$INDEX]}_data_temp.json"
TEMP_TEMP_FILE="${FILE_PREFIX[$INDEX]}_data_temp_temp.json"
DAILY_FILE="${FILE_PREFIX[$INDEX]}_data_daily.json"

# Metadata
METADATA_FILE="${FILE_PREFIX[$INDEX]}_data_metadata.json"

# ThaiBMA API URLs
API_URL=
declare -A API_URLs
API_URL_ORIGIN="https://www.thaibma.or.th"
declare -A API_URL_PATH
  API_URL_PATH["corp"]="/api/index"
  API_URL_PATH["comp"]="/api/CompositeIndex"
  API_URL_PATH["ZRR"]="/api/zrrindex"
  API_URL_PATH["TB"]="/api/index"
  API_URL_PATH["CP"]="/api/index"
  API_URL_PATH["gov-shortterm"]="/api/index"
  API_URL_PATH["gov-MTM"]="/api/index"
  API_URL_PATH["corp-MTM"]="/api/index"
  API_URL_PATH["corp-fixedterm"]="/api/index"
  API_URL_PATH["ESG"]="/api/index"
  API_URL_PATH["a3gbi"]="/api/a3gbi"
declare -A API_URL_SEARCH_BASE
  API_URL_SEARCH_BASE["corp"]="?isShowSubGroup=false&asof="
  API_URL_SEARCH_BASE["comp"]="?IndexType=Composite(Corp)&asof="
  API_URL_SEARCH_BASE["ZRR"]="?ratingName=RF&asof="
  API_URL_SEARCH_BASE["TB"]="?bondtype=TB&asof="
  API_URL_SEARCH_BASE["CP"]="?bondType=CP&asof="
  API_URL_SEARCH_BASE["gov-shortterm"]="?bondType=shortterm&asof="
  API_URL_SEARCH_BASE["gov-MTM"]="?bondType=GOV-MTM&asof="
  API_URL_SEARCH_BASE["corp-MTM"]="?bondType=corporate&asof="
  API_URL_SEARCH_BASE["corp-fixedterm"]="?bondType=FixedTerm-Corporate&asof="
  API_URL_SEARCH_BASE["ESG"]="?bondType=esg&asof="
  API_URL_SEARCH_BASE["a3gbi"]="?asof="
API_URL_BASE="${API_URL_ORIGIN}${API_URL_PATH[$INDEX]}${API_URL_SEARCH_BASE[$INDEX]}"

# ThaiBMA API data range API URLs
declare -A RANGE_API_URL_PATH
  RANGE_API_URL_PATH["corp"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["comp"]="/api/CompositeIndex"
  RANGE_API_URL_PATH["ZRR"]="/api/ZrrIndex"
  RANGE_API_URL_PATH["TB"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["CP"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["gov-shortterm"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["gov-MTM"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["corp-MTM"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["corp-fixedterm"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["ESG"]="/api/indexavailabledate"
  RANGE_API_URL_PATH["a3gbi"]="/api/indexavailabledate"
declare -A RANGE_API_URL_SEARCH
  RANGE_API_URL_SEARCH["corp"]="?BondType=corporate-Trade"
  RANGE_API_URL_SEARCH["comp"]=""
  RANGE_API_URL_SEARCH["ZRR"]="?ratingName=RF"
  RANGE_API_URL_SEARCH["TB"]="?BondType=TB"
  RANGE_API_URL_SEARCH["CP"]="?BondType=CP"
  RANGE_API_URL_SEARCH["gov-shortterm"]="?BondType=shortterm"
  RANGE_API_URL_SEARCH["gov-MTM"]="?BondType=GOV-MTM"
  RANGE_API_URL_SEARCH["corp-MTM"]="?BondType=corporate"
  RANGE_API_URL_SEARCH["corp-fixedterm"]="?BondType=FixedTerm-Corporate"
  RANGE_API_URL_SEARCH["ESG"]="?BondType=esg"
  RANGE_API_URL_SEARCH["a3gbi"]="?BondType=A3GBI"
RANGE_API_URL="${API_URL_ORIGIN}${RANGE_API_URL_PATH[$INDEX]}${RANGE_API_URL_SEARCH[$INDEX]}"

# Range file & variables
RANGE_FILE="${FILE_PREFIX[$INDEX]}_range.json"
F_first=""
F_latest=""

echo "Starting ThaiBMA data crawler..."

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Please install jq first."
  exit 1
fi

# Function to fetch API data range
fetch_api_range() {
  if curl -s "$RANGE_API_URL" > "$RANGE_FILE"; then
    F_first=$(jq -r '.[0]' $RANGE_FILE)
    F_latest=$(jq -r '.[1]' $RANGE_FILE)
    F_first=`date -d $F_first +"%F"`
    F_latest=`date -d $F_latest +"%F"`
    rm -f $RANGE_FILE
    return 0
  else
    echo "Error: failed to fetch API data range"
    rm -f $RANGE_FILE
    return 1
  fi
}

# Function to fetch API data with error checking
fetch_api_data() {

  # ThaiBMA API uses ISO 8601 date & time format. No reformatting is necessary.

  # Input ISO 8601 date query range
  local F_start=$1
  local F_end=$F_latest

  # Reset API URLs list
  API_URLs=()

  # Loop through days to generate API URLs list within query range
  local F=$F_start
  until [[ $F > $F_end ]]; do
    API_URL="${API_URL_BASE}${F}"
    API_URLs["$F"]=$API_URL
    F=$(date -d "$F + 1 day" +"%F")
  done

  # Create temporary JSON file with an empty array
  jq -n '[]' > "$TEMP_FILE"

  # Fetch data from API and append to temporary JSON
  unset F
  success_counter=0
  for F in "${!API_URLs[@]}"; do
    echo "Fetching $F data from API..."
    if curl -s "${API_URLs[$F]}" > "$DAILY_FILE"; then
      # Check if response is valid JSON
      if jq empty "$DAILY_FILE" 2>/dev/null; then
        # ThaiBMA API returns JSON object in case of no data
        case `jq type "$DAILY_FILE"` in
          '"array"')
            cp "$TEMP_FILE" "$TEMP_TEMP_FILE"
            jq -s add "$TEMP_TEMP_FILE" "$DAILY_FILE" > "$TEMP_FILE"
            if [ $? -eq 0 ]; then
              echo "API data fetched & merged to $TEMP_FILE successfully"
              success_counter+=1
            else
              echo "Error: Failed to merge fetched data to $TEMP_FILE"
              rm -f "$DAILY_FILE" "$TEMP_TEMP_FILE"
            fi
            ;;
          '"object"')
            echo 'Error: API returned JSON with no data (type="object")'
            rm -f "$DAILY_FILE"
            ;;
          *)
            echo 'Error: API returned JSON with no data (type=other)'
            rm -f "$DAILY_FILE"
            ;;
        esac
      else
        echo "Error: API returned invalid JSON"
        rm -f "$DAILY_FILE"
      fi
    else
      echo "Error: Failed to fetch data from API"
      rm -f "$DAILY_FILE"
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

  # Get newest local date; ThaiBMA API uses ISO 8601 date & time format. No reformatting is necessary.
  local F_newest_local=$(jq -r '[.[] | .Asof | split("T") as [$F, $T] | $F] | sort | .[-1]' "$LOCAL_FILE")
  echo "Latest local date: $F_newest_local"

  if [ ! -f "$METADATA_FILE" ]; then
    jq -n --arg nl "$F_newest_local" '{"newest_local": $nl}' > $METADATA_FILE
    if [ $? -eq 0 ]; then
      echo "No metadata file existed, successfully created new metadata file with updated value(s)"
      return 0
    else
      echo "Error: No metadata file existed, failed to create new metadata file"
      return 1
    fi
  else
    jq -n --arg nl "$F_newest_local" '.newest_local = $nl' $METADATA_FILE > "${METADATA_FILE}.tmp"
    if [ $? -eq 0 ]; then
      mv "${METADATA_FILE}.tmp" "$METADATA_FILE"
      echo "Successfully updated metadata file"
      return 0
    else
      echo "Error: Failed to update metadata file"
      rm -f "${METADATA_FILE}.tmp"
      return 1
    fi
  fi
}

# Fetch API data range
if fetch_api_range; then
  echo "Successfully fetched API data range"
else
  echo "Error, failed to fetch API data range"
  exit 1
fi

# Check if this is the first run
if [ ! -f "$LOCAL_FILE" ]; then
  echo "Local file doesn't exist. Creating initial file with all API data..."

  # Initiate local file with entire data since F_first for the first run
  if fetch_api_data $F_first; then
    mv "$TEMP_FILE" "$LOCAL_FILE"
    entry_count=$(jq 'length' "$LOCAL_FILE")
    echo "Successfully created $LOCAL_FILE with $entry_count entries"

    # Find and update date of newest local entry
    find_newest_local

  else
    echo "Error: Failed to create initial file"
    exit 1
  fi

else

  echo "Local file exists."

  # Query stored date of newest local entry, find if not exist
  if [ ! -f "$METADATA_FILE" ]; then
    find_newest_local
  fi
  F_newest_local=$(jq -r '.newest_local' $METADATA_FILE)
  echo "Latest local date: $F_newest_local"

  # Query data since latest day in local file
  echo "Checking for new entries..."
  if fetch_api_data $F_newest_local; then

    # Filter API data for entries newer than newest_local; ThaiBMA API uses ISO 8601 date & time format. No reformatting is necessary.
    new_entries=$(jq --arg F_newest_local "$F_newest_local" '[.[] | select((.Asof | split("T") as [$F, $T] | $F) > $F_newest_local)]' "$TEMP_FILE")

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
        echo "Total entries in $LOCAL_FILE: $total_count"

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
    echo "Error: Failed to fetch API data"
    exit 1
  fi
fi

echo "ThaiBMA Bond Index data crawler completed successfully!"

# Clean up temporary files
rm -f "$DAILY_FILE" "$TEMP_FILE" "$TEMP_TEMP_FILE"
