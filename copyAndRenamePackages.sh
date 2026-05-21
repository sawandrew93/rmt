#!/bin/bash

# Source base directory
SRC_BASE="/hana/shared/rmt"
# Destination base directory
DEST_BASE="/hana/log/suse_packages_renamed"

# Find all directories under SRC_BASE that contain "15-SP6"
find "$SRC_BASE" -type d -path "*/15-SP6/*" | while read -r src_dir; do
    # Build the destination path by replacing SRC_BASE with DEST_BASE
    dest_dir="${src_dir/$SRC_BASE/$DEST_BASE}"

    echo "Copying: $src_dir -> $dest_dir"

    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"

    # Copy contents recursively
    cp -r "$src_dir/"* "$dest_dir/"

    # Rename RPM files with '+' to '-'
    find "$dest_dir" -type f -name "*+*.rpm" | while read -r rpm_file; do
        new_name="$(echo "$rpm_file" | sed 's/+/-/g')"
        echo "Renaming: $rpm_file -> $new_name"
        mv "$rpm_file" "$new_name"
    done
done