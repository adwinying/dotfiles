#! /bin/sh

# This script is used to generate files containing secrets for a particular
# host.
# It is intended to be run on the host itself, and will generate the files in
# ~/.secrets.
# The secrets are obtained from a bitwarden vault, and the bitwarden CLI must
# be installed and configured.

set -e

RED="\033[0;31m"
NOCOLOR="\033[0m"

CWD=$(realpath -e $(dirname $0))
HOSTNAME=$(hostname)
SECRET_NOTE_NAME="secrets.$HOSTNAME"
SECRETS_DIR="$CWD/../secrets/$HOSTNAME"
OUTPUT_DIR="$HOME/.secrets"

# Get all secrets for host
SECRETS=$($CWD/get_secrets.sh "$SECRET_NOTE_NAME")

# Remove secrets directory if it exists
if [ -d $OUTPUT_DIR ]; then
  rm -rf $OUTPUT_DIR
fi

# Make a copy of the secrets directory
mkdir -p $(dirname $OUTPUT_DIR)
cp -r $SECRETS_DIR $OUTPUT_DIR

# Temporarily change to output directory
pushd $OUTPUT_DIR

# Get all instances of %.+% in files
for file in $(grep -H -r -E -o '%.[^%]+%' .); do
  file_path=$(echo $file | cut -d ':' -f 1)
  secret_name=$(echo $file | cut -d '%' -f 2)
  secret_value=$(echo $SECRETS | jq -r ".$secret_name" | sed ':a;N;$!ba;s/\n/\\n/g')

  echo "file_path: $file_path"
  echo "secret_name: $secret_name"

  # If secret value is empty, exit
  if [ -z "$secret_value" ]; then
    echo -e "${RED}ERROR:${NOCOLOR} Secret value for $secret_name is empty"
    rm -rf $OUTPUT_DIR
    exit 1
  fi

  # Replace secret name with secret value
  sed -i "s/%$secret_name%/$secret_value/g" $file_path
done

# Return to original directory
popd
