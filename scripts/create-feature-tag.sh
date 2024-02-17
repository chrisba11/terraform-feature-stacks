#!/bin/bash

# ANSI color codes
RED='\033[0;31m'    # Red color
NC='\033[0m'        # No color (reset)


set -exo pipefail

# Expects 1 optional argument - branch name
BRANCH_NAME=$1

# This is the code used to identify this project in our project management software
PROJECT_CODE="ABC"
# Lowercase project code
PROJECT_CODE_LOWER=$(echo "$PROJECT_CODE" | awk '{print tolower($0)}')

# Set the regex pattern that branch names must adhere to
# This ensures our CI scripts are able to use the branch name to create a feature tag
REGEX_PATTERN="^(main|release|((revert-\d+-)?(feature|task|bugfix|hotfix|docs|refactor|test)/${PROJECT_CODE_LOWER}-[0-9X]{1,4}-.+))$"

# Grab ticket number from branch to use as a feature tag
# assuming branch name in the format of "feature/ABC-123-some-other-text",
# the feature tag becomes "abc123"
if [ -z "${BRANCH_NAME}" ]; then
  BRANCH_NAME=$(git branch --show-current)
fi

BRANCH_NAME_LOWER=$(echo "$BRANCH_NAME" | awk '{print tolower($0)}')

# If the branch name does not conform, provide feedback to developer and fail
if [[ ! $BRANCH_NAME_LOWER =~ $REGEX_PATTERN ]] && [ -n "${BRANCH_NAME_LOWER}" ]; then
  echo "\n${RED}Branch name, '${BRANCH_NAME}', does not meet naming standards.${NC}\n\n" \
    "Naming must be similar to the following format:\n" \
    "'feature/${PROJECT_CODE}-123-some-short-description'" \
    "or 'Docs/${PROJECT_CODE_LOWER}-321-descriptive-text'.\n\n" \
    "The prefix for the branch name may contain 'feature/', 'task/', 'bugfix/', 'hotfix/',\n" \
    "'docs/', 'refactor/', or 'test/' and should be immediately followed by the ticket number,\n" \
    "then a '-' and a short description.\n\n" \
    "The ticket number (i.e. ABCD-123) is what is used to generate a feature tag.\n\n" \
    "Branch names are case-insensitive.\n\n" \
    "Run 'git branch -m <new-branch-name>' to rename this branch before committing.\n"
  exit 1
fi

if [ "$BRANCH_NAME" == "main" ]; then
  TAG="MAIN"
elif [ -z "${BRANCH_NAME}" ]; then
  TAG="$(git rev-parse HEAD)"
else
  # Grab section of branch name after first "/" through second "-" and lowercase it
  TAG="$(echo "${BRANCH_NAME}" | awk -F '/' '{print tolower($2)}' | cut -f1,2 -d '-' | tr -d '-')"
fi

# Print lowercased ticket number for consumption by other scripts as the "feature tag"
echo "$TAG"
