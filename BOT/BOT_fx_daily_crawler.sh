#!/bin/bash

# BOT Exchange Rate Fetcher
# Fetches DAILY_AVG_EXG_RATE from the Bank of Thailand API and keeps a local
# per-currency-pair JSON file up to date. Automatically chunks requests into
# <=31-day windows (BOT's API limit) and backfills fully in one run.
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
DATA_DIR="$HOME/Documents/Git/quotes-crawler/BOT"
LOCAL_FILE="${DATA_DIR}/${CURRENCY}THB.json"
LOG_FILE="${DATA_DIR}/BOT_fx_daily_crawler.log"
BASE_URL="https://gateway.api.bot.or.th/Stat-ExchangeRate/v2/DAILY_AVG_EXG_RATE/"
DEFAULT_START_PERIOD="2020-01-01"  # used only on the very first run for a currency; adjust to taste
MAX_WINDOW_DAYS=31                 # BOT's API rejects ranges longer than this

mkdir -p "$DATA_DIR"

# --- Log to both terminal and the log file ---
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== $(date '+%F %T') - Starting fetch for $CURRENCY ==="

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

# --- Determine overall start_period ---
if [ -f "$LOCAL_FILE" ]; then
    start_period=$(jq -r '[.[] | .period] | sort | .[-1]' "$LOCAL_FILE")
    echo "Local file found ($LOCAL_FILE). Fetching from last saved date: $start_period"
else
    start_period="$DEFAULT_START_PERIOD"
    echo "No local file found. Fetching from default start date: $start_period"
fi

end_period=$(date -d "yesterday" +%F)  # exclude today: today's rate isn't final yet

if [[ "$start_period" > "$end_period" ]]; then
    echo "Already up to date (last saved date is $start_period)."
    exit 0
fi

# --- Fetch one <=31-day window and merge it into the local file ---
fetch_window() {
    local window_start="$1"
    local window_end="$2"

    echo "Requesting $CURRENCY/THB rates from $window_start to $window_end..."

    local response
    response=$(curl -s --request GET \
        --url "${BASE_URL}?start_period=${window_start}&end_period=${window_end}&currency=${CURRENCY}" \
        --header 'Accept: */*' \
        --header "Authorization: ${API_KEY}")

    if ! echo "$response" | jq empty 2>/dev/null; then
        echo "Error: API did not return valid JSON."
        echo "$response"
        return 1
    fi

    # BOT returns an httpCode/moreInformation payload on errors (e.g. period too long)
    if echo "$response" | jq -e 'has("httpCode")' > /dev/null 2>&1; then
        echo "API error: $(echo "$response" | jq -r '.moreInformation[].message')"
        return 1
    fi

    local fetched
    fetched=$(echo "$response" | jq '
        [(.result.data.data_detail // [])[] | {period: .period, rate: (.mid_rate | tonumber)}]
    ')

    local fetched_count
    fetched_count=$(echo "$fetched" | jq 'length')

    if [ "$fetched_count" -eq 0 ]; then
        echo "No entries returned for this window."
        return 0
    fi

    echo "Fetched $fetched_count entries."

    if [ -f "$LOCAL_FILE" ]; then
        jq --argjson fetched "$fetched" '
            (. + $fetched) | unique_by(.period)
        ' "$LOCAL_FILE" > "${LOCAL_FILE}.tmp" && mv "${LOCAL_FILE}.tmp" "$LOCAL_FILE"
    else
        echo "$fetched" | jq 'unique_by(.period)' > "$LOCAL_FILE"
    fi
}

# --- Walk the full range in <=31-day windows ---
current_start="$start_period"
while [[ "$current_start" < "$end_period" || "$current_start" == "$end_period" ]]; do
    window_end=$(date -d "$current_start +$((MAX_WINDOW_DAYS - 1)) days" +%F)
    if [[ "$window_end" > "$end_period" ]]; then
        window_end="$end_period"
    fi

    fetch_window "$current_start" "$window_end" || exit 1

    current_start=$(date -d "$window_end +1 day" +%F)
    sleep 1  # be polite to the API between chunks
done

total_count=$(jq 'length' "$LOCAL_FILE")
echo "Done. $LOCAL_FILE now has $total_count entries."
