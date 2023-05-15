#!/bin/sh

# This script is used to generate files containing secrets for a particular
# host. It is intended to be run on the host itself.
#
# The secrets are obtained from a bitwarden vault, and the bitwarden CLI must
# be installed and configured. The secrets are stored in a secret note, which
# contains all secrets for a given host in JSON format. This JSON string will
# be parsed, traversed recursively and each property containing a string be
# exported into a shell variable.
#
# The script will then make a copy of the secrets directory to ~/.secrets, and
# will replace all instances of $secret_name in the files with the value of the
# corresponding shell variable using envsubst.

set -eu

CWD=$(realpath -e $(dirname $0))
HOSTNAME=$(hostname)
SECRET_NOTE_NAME="secrets.$HOSTNAME"
SECRETS_DIR="$CWD/../secrets/$HOSTNAME"
OUTPUT_DIR="$HOME/.secrets"

# Get all secrets for host
SECRETS=$($CWD/get_secrets.sh "$SECRET_NOTE_NAME")

# Parse JSON string and export variables
export_secrets() {
  local json=$1
  local prefix=${2:-}

  for key in $(jq -r 'keys[]' <<< $json); do
    local value=$(jq -r ".$key" <<< $json)

    if [ -n "$prefix" ]; then
      newkey="${prefix^^}__${key^^}"
    else
      newkey="${key^^}"
    fi

    if [ "$(jq . <<< $value > /dev/null 2>&1 && \
      jq 'type == "object"' <<< $value)" = "true" ]; then
      export_secrets "$value" "$newkey"
    else
      export "$newkey"="$value"
    fi
  done
}

export_secrets "$SECRETS"

# Remove secrets directory if it exists
if [ -d $OUTPUT_DIR ]; then
  rm -rf $OUTPUT_DIR
fi

# Make a copy of the secrets directory
mkdir -p $(dirname $OUTPUT_DIR)
cp -r $SECRETS_DIR $OUTPUT_DIR

# Temporarily change to output directory
pushd $OUTPUT_DIR > /dev/null

# Recursively loop through all files in output directory and replace all
# instances of $secret_name with the value of the corresponding shell variable
for file in $(find . -type f); do
  echo "Bootstrapping: $file"
  envsubst < $file > $file.tmp
  cat $file.tmp > $file
  rm $file.tmp
done

# Return to original directory
popd > /dev/null

echo "Done."
