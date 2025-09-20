#!/bin/bash

# Gold Price Mean Calculator
# Fetches gold price data from Finnomena API and calculates mean prices

API_URL="https://www.finnomena.com/fn3/api/gold/trader/history/graph?period=MAX"
LOCAL_FILE="finnomena_gold_traders_means.json"
NEW_ENTRIES_FILE="finnomena_gold_traders_new_entries.json"
TEMP_FILE="finnomena_gold_traders_temp.json"
LOG_FILE="Finnomena_Gold_Traders_crawler.log"
#OUTPUT_FILE="gold_prices_with_means.json"

if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Please install jq first." | tee -a $LOG_FILE
  notify-send "Finnomena Thai Gold Traders crawler" "Error: jq is required but not installed. Please install jq first."
  exit 1
fi

# Fetch data
echo "Fetching gold price data from Finnomena API..." | tee -a $LOG_FILE
if curl -s "$API_URL" | jq '.data[:-1]' > "$TEMP_FILE"; then
  # Check if response is valid JSON
  if jq empty "$TEMP_FILE" 2>/dev/null; then

    # Check if this is the first run
    if [ ! -f "$LOCAL_FILE" ]; then
      # Calculate means price and insert back to JSON
      jq 'map(
          . + {
            "barMeanPrice": (((.barBuyPrice | tonumber) + (.barSellPrice | tonumber)) * 0.5),
            "ornamentMeanPrice": (((.ornamentBuyPrice | tonumber) + (.ornamentSellPrice | tonumber)) * 0.5)
          }
        )' "$TEMP_FILE" > "${LOCAL_FILE}.tmp"
      if [ $? -eq 0 ]; then
        mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
        entry_count=$(jq 'length' "$LOCAL_FILE")
        echo "Successfully created $LOCAL_FILE with $entry_count entries" | tee -a $LOG_FILE
        notify-send "Finnomena Thai Gold Traders crawler" "Successfully created $LOCAL_FILE with $entry_count entries"
      else
        echo "Error: Failed to create initial file" | tee -a $LOG_FILE
        notify-send "Finnomena Thai Gold Traders crawler" "Error: Failed to create initial file"
        rm -f "${LOCAL_FILE}.tmp" "$TEMP_FILE"
        exit 1
      fi
    else
      # Find newest local entry
      F_newest_local=$(jq -r '[.[] | .createdAt | split("T") as [$F, $T] | $F] | sort | .[-1]' "$LOCAL_FILE")
      echo "Latest local date: $F_newest_local" | tee -a $LOG_FILE

      # Filter API data for entries newer than newest_local
      jq --arg F_newest_local "$F_newest_local" '
        [.[] | select(
          (.createdAt | split("T") as [$F, $T] |
           $F) > $F_newest_local
        )]
        ' "$TEMP_FILE" > "$NEW_ENTRIES_FILE"

      # Check if we found new entries
      new_count=$(jq 'length' "$NEW_ENTRIES_FILE")

      if [ "$new_count" -gt 0 ]; then
        echo "Found $new_count new entries" | tee -a $LOG_FILE

        echo "line 63"

        # Calculate means price and insert back to JSON
        new_entries_means=$(jq 'map(
            . + {
              "barMeanPrice": (((.barBuyPrice | tonumber) + (.barSellPrice | tonumber)) * 0.5),
              "ornamentMeanPrice": (((.ornamentBuyPrice | tonumber) + (.ornamentSellPrice | tonumber)) * 0.5)
            }
          )' "$NEW_ENTRIES_FILE")

        echo "line 73"

        # Merge with existing data
        jq --argjson new_entries_means "$new_entries_means" '. + $new_entries_means' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp"

        if [ $? -eq 0 ]; then
          mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
          echo "Successfully added $new_count new entries to $LOCAL_FILE" | tee -a $LOG_FILE
          notify-send "Finnomena Thai Gold Traders crawler" "Successfully added $new_count new entries to $LOCAL_FILE"

          # Show total count
          total_count=$(jq 'length' "$LOCAL_FILE")
          echo "Total entries in $LOCAL_FILE: $total_count" | tee -a $LOG_FILE

        else
          echo "Error: Failed to merge new entries" | tee -a $LOG_FILE
          notify-send "Finnomena Thai Gold Traders crawler" "Error: Failed to merge new entries"
          rm -f "${LOCAL_FILE}.tmp" "$TEMP_FILE" "$NEW_ENTRIES_FILE"
          exit 1
        fi

      else
        echo "No new entries found. Local file is up to date." | tee -a $LOG_FILE
        notify-send "Finnomena Thai Gold Traders crawler" "No new entries found. Local file is up to date."
      fi
    fi
  else
    echo "Error: API returned invalid JSON" | tee -a $LOG_FILE
    notify-send "Finnomena Thai Gold Traders crawler" "Error: API returned invalid JSON"
    rm -f "$TEMP_FILE"
    exit 1
  fi
else
  echo "Error: Failed to fetch data from API" | tee -a $LOG_FILE
  notify-send "Finnomena Thai Gold Traders crawler" "Error: Failed to fetch data from API"
  rm -f "$TEMP_FILE"
  exit 1
fi
rm -f "$TEMP_FILE" "$NEW_ENTRIES_FILE"
