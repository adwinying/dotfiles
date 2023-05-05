#! /bin/sh

# This script uses the bitwarden CLI to retrieve a secret from the vault.
# The secret is stored in a secret note, which contains all secrets for a given
# host in JSON format.
# The first argument is the name of the secret note.
# The second argument is optional; if provided, it will return the value of the
# specified key in the secret note.

set -e

# Variables
SECRET_NOTE_NAME=$1
SECRET_NAME=$2

# Check if all required arguments are provided
if [ -z "$SECRET_NOTE_NAME" ]; then
  echo "Usage: $0 <secret_note_name> [secret_name]"
  exit 1
fi

# Get the secret note contents
SECRET_NOTE=$(bw get notes $SECRET_NOTE_NAME)

# If a secret name is not provided, return the entire secret note
if [ -z "$SECRET_NAME" ]; then
  echo $SECRET_NOTE
  exit 0
fi

# Otherwise, get the value of that key
echo $SECRET_NOTE | jq -r ".$SECRET_NAME"
