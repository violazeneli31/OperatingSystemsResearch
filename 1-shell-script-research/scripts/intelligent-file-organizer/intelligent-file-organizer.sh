#!/bin/bash
# intelligent-file-organizer.sh
# Organizes files into folders based on file extension.

TARGET_DIR="${1:-.}"

echo "Starting file organization in: $TARGET_DIR"

cd "$TARGET_DIR" || {
  echo "Error: Directory not found."
  exit 1
}

mkdir -p Documents Images Archives Source_Code Others

for file in *; do
   [ -f "$file" ] || continue

   extension="${file##*.}"
   extension="${extension,,}"

   case "$extension" in
     pdf|doc|docx|txt)
        mv "$file" Documents/
        ;;
     jpg|jpeg|png|gif)
        mv "$file" Images/
        ;;
     zip|tar|gz|rar)
        mv "$file" Archives/
        ;;
     c|cpp|java|py|sh|html|css|js)
        mv "$file" Source_Code/
        ;;
     *)
        mv "$file" Others/
        ;;
   esac

  echo "Moved: $file"
done

echo "File organization completed."
