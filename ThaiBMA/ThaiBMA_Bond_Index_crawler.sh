#!/bin/bash

# ThaiBMA Data Crawler Script
# Updates local JSON file with new entries from ThaiBMA API

# Get index name from passed argument
INDEX=$1

# File prefix
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
# ต้องเปลี่ยนเป็นรายวัน ? MONTHLY_FILE="${FILE_PREFIX[$INDEX]}_data_monthly.json"

# Metadata
METADATA_FILE="${FILE_PREFIX[$INDEX]}_data_metadata.json"

# ThaiBMA API URLs
API_URL=
declare -A API_URLs
API_URL_ORIGIN="https://www.gpf.or.th"
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

# ThaiBMA API data range API
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

echo "Starting ThaiBMA data crawler..."

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Please install jq first."
  exit 1
fi
