#!/bin/bash

# BOT Exchange Rate Fetcher
# Fetches DAILY_AVG_EXG_RATE from the Bank of Thailand API and keeps a local
# per-currency-pair JSON file up to date.
#
# Usage: ./bot_fx_fetch.sh USD

CURRENCY="$1"

if [ -z "$CURRENCY" ]; then
    echo "Usage: $0 CURRENCYCODE"
    echo "Example: $0 USD"
    exit 1
fi

CURRENCY=$(echo "$CURRENCY" | tr '[:lower:]' '[:upper:]')

# --- Config ---
API_KEY_FILE="$HOME/.config/bot_api/credentials"
DATA_DIR="$HOME/bot_fx_data"
LOCAL_FILE="${DATA_DIR}/${CURRENCY}THB.json"
BASE_URL="https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/DAILY_AVG_EXG_RATE/"
DEFAULT_START_PERIOD="2026-01-01"  # used only on the very first run for a currency; adjust to taste

mkdir -p "$DATA_DIR"

# --- Check dependencies ---
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    exit 1
fi

# --- Load API key ---
if [ ! -f "$API_KEY_FILE" ]; then
    echo "Error: API key file not found at $API_KEY_FILE"
    echo "Create it with:"
    echo "  mkdir -p ~/.config/bot_api && chmod 700 ~/.config/bot_api"
    echo "  printf '%s' 'YOUR_API_KEY' > ~/.config/bot_api/credentials"
    echo "  chmod 600 ~/.config/bot_api/credentials"
    exit 1
fi
API_KEY=$(tr -d '[:space:]' < "$API_KEY_FILE")

# --- Determine start_period ---
if [ -f "$LOCAL_FILE" ]; then
    start_period=$(jq -r '[.[] | .period] | sort | .[-1]' "$LOCAL_FILE")
    echo "Local file found ($LOCAL_FILE). Fetching from last saved date: $start_period"
else
    start_period="$DEFAULT_START_PERIOD"
    echo "No local file found. Fetching from default start date: $start_period"
fi

end_period=$(date -d "yesterday" +%F)  # exclude today: today's rate isn't final yet

# --- Fetch from API ---
echo "Requesting $CURRENCY/THB rates from $start_period to $end_period..."

response=$(curl -s --request GET \
    --url "${BASE_URL}?start_period=${start_period}&end_period=${end_period}&currency=${CURRENCY}" \
    --header 'Accept: */*' \
    --header "Authorization: ${API_KEY}")

if ! echo "$response" | jq empty 2>/dev/null; then
    echo "Error: API did not return valid JSON."
    echo "$response"
    exit 1
fi

# --- Extract period + mid_rate pairs ---
fetched=$(echo "$response" | jq '
    [(.result.data.data_detail // [])[] | {period: .period, rate: (.mid_rate | tonumber)}]
')

fetched_count=$(echo "$fetched" | jq 'length')

if [ "$fetched_count" -eq 0 ]; then
    echo "No entries returned for this period."
    echo "Raw response for troubleshooting:"
    echo "$response" | jq '.result.api, .result.timestamp' 2>/dev/null
    exit 0
fi

echo "Fetched $fetched_count entries."

# --- Merge with local file (dedupe by period, local entries win on conflict) ---
if [ -f "$LOCAL_FILE" ]; then
    jq --argjson fetched "$fetched" '
        (. + $fetched) | unique_by(.period)
    ' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp" && mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
else
    echo "$fetched" | jq 'unique_by(.period)' > "$LOCAL_FILE"
fi

total_count=$(jq 'length' "$LOCAL_FILE")
echo "Done. $LOCAL_FILE now has $total_count entries."
