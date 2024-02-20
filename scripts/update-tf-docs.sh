#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))
ROOT_DIR=$(dirname "$SCRIPT_DIR")

# Directory containing all stacks
STACKS_DIR="${ROOT_DIR}/infra/tf/stacks"

# Find all directories in the STACKS_DIR
# The 'printf' command is used to format the output to get the relative paths
STACK_PATHS=$(find "$STACKS_DIR" -mindepth 1 -maxdepth 1 -type d | sort -u)

# Loop through each stack path and run terraform-docs
for STACK_PATH in $STACK_PATHS; do
  echo "Updating Terraform docs for stack: ${STACK_PATH##*/}"
  terraform-docs -c $ROOT_DIR/infra/tf/.terraform-docs.yml "$STACK_PATH" >/dev/null 2>&1
done
