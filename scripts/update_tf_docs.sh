#!/bin/bash

# This script is intended to be run from the terraform directory and assumes
# there is a stacks directory below it that contains all of the stacks to be updated

# Directory containing all stacks
STACKS_DIR="./stacks"

# Find all directories in the STACKS_DIR
# The 'printf' command is used to format the output to get the relative paths
STACK_PATHS=$(find "$STACKS_DIR" -mindepth 1 -maxdepth 1 -type d | sort -u)

# Loop through each stack path and run terraform-docs
for STACK_PATH in $STACK_PATHS; do
  echo "Updating Terraform docs for stack: $STACK_PATH"
  terraform-docs -c .terraform-docs.yml "$STACK_PATH"
done

# Output the list of stack paths (optional)
echo "----------------"
echo "All stack paths:"
echo "$STACK_PATHS"
