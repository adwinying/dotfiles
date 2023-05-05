#! /bin/sh

# This script uses the bitwarden CLI to add/update secrets in the vault.
# The secret is stored in a secret note, which contains all secrets for a given
# host in JSON format.
# The first argument is the name of the secret note, the second argument is the
# name of the secret to add/update, and the third argument is the value of the
# secret to add/update.
# The script will create the secret note if it does not exist.

set -e

# Variables
SECRET_NOTE_NAME=$1
SECRET_NAME=$2
SECRET_VALUE=$3

# Check if all variables are set
if [ -z "$SECRET_NOTE_NAME" ] || [ -z "$SECRET_NAME" ] || [ -z "$SECRET_VALUE" ]; then
  echo "Usage: $0 <secret note name> <secret name> <secret value>"
  exit 1
fi

# Search for the secret note
echo "Searching for secret note: $SECRET_NOTE_NAME"
SECRET_NOTE=$(bw list items --search "$SECRET_NOTE_NAME" | jq ".[] | select(.name == \"$SECRET_NOTE_NAME\")")

# If the secret note does not exist, create it.
if [ -z "$SECRET_NOTE" ]; then
  echo "Secret note not found. Attempting to create note..."
  SECRET_NOTE=$(bw get template item | jq ".type = 2 | .secureNote.type = 0 | .notes = \"{}\" | .name = \"$SECRET_NOTE_NAME\"" | bw encode | bw create item)
fi

SECRET_NOTE_ID=$(echo "$SECRET_NOTE" | jq -r ".id")
SECRET_NOTE_VALUE=$(echo "$SECRET_NOTE" | jq -r ".notes")

# Set the new secret
SECRET_NOTE_VALUE=$(echo "$SECRET_NOTE_VALUE" | jq ".$SECRET_NAME = \"$SECRET_VALUE\" | tostring")
SECRET_NOTE=$(echo "$SECRET_NOTE" | jq -r ".notes = $SECRET_NOTE_VALUE | tostring")

# Update the secret note
echo "Syncing secret note to vault..."
echo "$SECRET_NOTE" | bw encode | bw edit item "$SECRET_NOTE_ID"
