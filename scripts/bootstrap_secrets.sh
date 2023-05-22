#!/bin/sh

# This script is used to generate files containing secrets for a particular
# host. It is intended to be run on the host itself.
#
# The secrets are obtained from a bitwarden vault, and the bitwarden CLI must
# be installed and configured. The secrets are stored in a secret note, which
# contains an .env formatted text. This .env file will be eval-ed, which will
# export all the values as shell variables.
#
# The script will then make a copy of the secrets directory to ~/.secrets, and
# will replace all instances of $secret_name in the files with the value of the
# corresponding shell variable using envsubst.

set -eu

CWD=$(realpath -e $(dirname $0))
HOSTNAME=$(hostname)
SECRET_NOTE_NAME="secrets.$HOSTNAME"
INPUT_DIR="$CWD/../secrets/$HOSTNAME"
OUTPUT_DIR="$HOME/.secrets"

# Get all secrets for host
SECRETS=$(bw get notes $SECRET_NOTE_NAME)

# Expose secrets as shell variables
set -a
eval "$SECRETS"
set +a

# Remove secrets directory if it exists
if [ -d $OUTPUT_DIR ]; then
  rm -rf $OUTPUT_DIR
fi

# Make a copy of the secrets directory
mkdir -p $(dirname $OUTPUT_DIR)
cp -r $INPUT_DIR $OUTPUT_DIR

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
