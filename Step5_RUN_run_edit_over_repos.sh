#!/bin/bash

# Define the directory containing the repositories
REPOS_DIR="./repos"
EDIT_ME_from_repo="../../Step4_EDIT_EDIT-ME.sh"

# Width of the line
LINE_WIDTH=80

# Check if the REPOS_DIR exists
if [ ! -d "$REPOS_DIR" ]; then
  echo "Directory $REPOS_DIR does not exist."
  exit 1
fi

# Function to print the separator line with the message
print_separator() {
  local message="$1"
  local message_length=${#message}
  local padding_length=$(( (LINE_WIDTH - message_length) / 2 ))
  local padding=$(printf '%*s' "$padding_length" '' | tr ' ' '#')
  printf "%s %s %s\n" "$padding" "$message" "$padding"
}

# Iterate over each subdirectory in the REPOS_DIR
for repo in "$REPOS_DIR"/*; do
  if [ -d "$repo" ]; then
    print_separator "Running Step4_EDIT_EDIT-ME.sh in $repo"
    # Change to the repository directory
    cd "$repo" || continue
    # Run the Step4_EDIT_EDIT-ME.sh script
    if [ -f $EDIT_ME_from_repo ]; then
      bash $EDIT_ME_from_repo
    else
      echo "Step4_EDIT_EDIT-ME.sh not found in $repo"
    fi
    # Change back to the original directory
    cd - > /dev/null
    print_separator "All operations completed in $repo."
    echo ""
  fi
done

echo "🎉🎉🎉 All repositories processed. 🎉🎉🎉"
