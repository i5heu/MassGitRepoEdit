#!/bin/bash

# Define the directory containing the repositories
REPOS_DIR="./repos"
CONFIG_FILE="Step1_EDIT_repos.conf"

# Width of the line
LINE_WIDTH=80

# Check if the REPOS_DIR exists
if [ ! -d "$REPOS_DIR" ]; then
  echo "Directory $REPOS_DIR does not exist."
  exit 1
fi

# Check if the CONFIG_FILE exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file $CONFIG_FILE does not exist."
  exit 1
fi

# Read the commit message from the configuration file
COMMIT_MESSAGE=$(grep -E '^CommitMessage =' "$CONFIG_FILE" | cut -d'=' -f2- | xargs)

# Check if the commit message is set
if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Error: Commit message not found in $CONFIG_FILE."
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
    repo_name=$(basename "$repo")
    print_separator "Running git operations in $repo_name"
    # Change to the repository directory
    cd "$repo" || continue
    # Run git add, commit, and push
    git add *
    git commit -m "$COMMIT_MESSAGE"
    git push
    # Change back to the original directory
    cd - > /dev/null
    print_separator "All operations completed in $repo_name"
    echo ""
  fi
done

print_separator "🎉🎉🎉 All repositories processed. 🎉🎉🎉"
