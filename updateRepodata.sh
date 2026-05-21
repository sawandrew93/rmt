#!/bin/bash

DEST_BASE="/hana/log/suse_packages_renamed"

# Find all 15-SP6 directories under DEST_BASE
find "$DEST_BASE" -type d -path "*/15-SP6/*" | while read -r dest_dir; do
    echo "Processing: $dest_dir"

    # Rename RPMs with '+' to '-'
    find "$dest_dir" -type f -name "*+*.rpm" | while read -r rpm_file; do
        new_name="$(echo "$rpm_file" | sed 's/+/-/g')"
        echo "Renaming: $rpm_file -> $new_name"
        mv "$rpm_file" "$new_name"
    done

    # Regenerate repodata
    echo "Regenerating repodata in $dest_dir"
    createrepo --update "$dest_dir"
done