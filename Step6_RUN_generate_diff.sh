#!/bin/bash

# Define the directory containing the repositories
REPOS_DIR="./repos"
DIFF_DIR="./diff"
DIFF_DIR_IN_REPO="../../diff"

# Width of the line
LINE_WIDTH=80

# Check if the REPOS_DIR exists
if [ ! -d "$REPOS_DIR" ]; then
  echo "Directory $REPOS_DIR does not exist."
  exit 1
fi

# Create the DIFF_DIR if it doesn't exist
if [ ! -d "$DIFF_DIR" ]; then
  echo "Creating diff directory at $DIFF_DIR"
  mkdir -p "$DIFF_DIR"
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
    repo_name=$(basename "$repo")
    print_separator "Generating diff for $repo_name"
    # Change to the repository directory
    cd "$repo" || continue
    # Generate the diff file
    git --no-pager diff

    diff_file="$DIFF_DIR_IN_REPO/${repo_name}_diff.txt"
    echo "Generating diff file at $diff_file"
    git diff $1 > "$diff_file"
    # Change back to the original directory
    cd - > /dev/null
    print_separator "Diff file created for $repo_name"
    echo ""
  fi
done

print_separator "🎉🎉🎉 All repositories processed. 🎉🎉🎉"
