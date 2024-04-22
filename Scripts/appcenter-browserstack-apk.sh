#!/bin/bash

# Logging function

log() {
    local log_file=/c/Users/AlenToholj/Downloads/script.log
    echo "$(date "+%Y-%m-%d %H:%M:%S") $1" >> "$log_file"
}

# Log script start

log ""
log "Script Started"
log ""
log "--------------------------------------------------------------------------------------------------------------------------------"

# Variables

OWNER=""
APP_NAME=""
TOKEN=""
PATH_TO_FOLDER=""
PATH_TO_IPA_FILE=""
BROWSERSTACK_USERNAME=""
BROWSERSTACK_ACCESS_TOKEN=""
BROWSERSTACK_API="https://api-cloud.browserstack.com/app-automate/upload"
APP_CENTER_BUILD_API="https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/branches/development/builds"
PATH_TO_ID=""


# Get latest build information from AppCenter

latest_build=$(curl -s -H "X-API-Token: $TOKEN" "$APP_CENTER_BUILD_API")

# Extract latest build id from development branch 

build_id=$(echo "$latest_build" | jq -r '.[].id' | head -1)

if [ -z "$build_id" ]; then
  log "Failed to retrieve URL. Check your organization, app name, and API token."
  exit 1
fi

log ""
log "The latest build ID from Development branch: $build_id"

# Download the latest build from development branch

url=$(curl -s -H "X-API-Token: $TOKEN" "https://api.appcenter.ms/v0.1/apps/$OWNER/$APP_NAME/builds/$build_id/downloads/build")

download_url=$(echo "$url" | jq -r '.uri')

if [ -z "$download_url" ]; then
  log "Failed to retrieve download URL."
  exit 1
fi

log "Download URL for $build_id build ID: $download_url"

curl -L -o "$PATH_TO_FOLDER/development_android_$build_id.zip" "$download_url"

if [ $? -eq 0 ]; then
  log "Latest build downloaded successfully to $PATH_TO_FOLDER"
else
  log "Failed to download latest build."
  exit 1
fi

# Unzip  the downloaded file

unzip -o $PATH_TO_FOLDER/development_android_$build_id.zip

# Upload ipa file to the BrowserStack

app_android_id=$(curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_TOKEN" \
    -X POST "$BROWSERSTACK_API" \
    -F "file=$PATH_TO_IPA_FILE")

app_android_id_output=$(echo $app_android_id | jq -r '.app_url')

if [ -z "$app_android_id_output" ]; then
  log "Failed to write down ID to the TXT file."
  exit 1
fi

log "Upload ID: $app_android_id_output"

echo $app_android_id_output > $PATH_TO_ID


log ""
log "--------------------------------------------------------------------------------------------------------------------------------"

# Log script finished
log ""
log "Script finished"
log ""
log "--------------------------------------------------------------------------------------------------------------------------------"
