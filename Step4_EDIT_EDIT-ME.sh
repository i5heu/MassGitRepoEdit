#!/bin/bash

# Echo the current path
echo "Current path: $(pwd)"

# Set the file extension the script will process
file_extension=".md"
# ☝️☝️☝️ Edit this line


# Function to process files with a given extension
process_files() {
  find . -type f -name "*$file_extension" ! -path "*/.*" -print0 | while IFS= read -r -d '' file; do
    echo "Processing $file"
    #🔽🔽🔽🔽 Here is place to add your processing logic


    sed -i 's/\[Overview\](#overview)/\[Bazinga\](#Bazinga)/g' $file



    #🔼🔼🔼🔼 End of processing logic
  done
}

# Process the files with the given extension
process_files "$file_extension"

echo "All files processed."
