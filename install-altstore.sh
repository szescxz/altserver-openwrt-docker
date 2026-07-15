#!/bin/ash

set -e

echo "Fetching AltStore release information"

altstore_info=$(wget -qO- "https://cdn.altstore.io/file/altstore/apps.json" | jq '.apps[] | select(.bundleIdentifier == "com.rileytestut.AltStore") | .versions[0]')
altstore_version=$(echo $altstore_info | jq -r .version)
altstore_url=$(echo $altstore_info | jq -r .downloadURL)
altstore_sha256=$(echo $altstore_info | jq -r .sha256)

echo "Downloading AltStore $altstore_version"
wget $altstore_url -O altstore.ipa
echo "$altstore_sha256 altstore.ipa" | sha256sum -c -

udid=""
for file in /var/lib/lockdown/*.plist; do
  udid=$(basename $file .plist)
  if [[ $udid == "SystemConfiguration" ]]; then
    udid=""
  else
    break
  fi
done

while [ -z "$udid" ]; do
  read -p "UDID: " udid
done

echo "Using UDID: $udid"

appleid=""
while [ -z "$appleid" ]; do
  read -p "Apple ID: " appleid
done

password=""
while [ -z "$password" ]; do
  read -s -p "Password: " password
done

echo "Installing AltStore"
./altserver -u $udid -a "$appleid" -p "$password" altstore.ipa

rm altstore.ipa
