#!/bin/bash

# Dry-run mode: pass --dry-run (or -n) to preview actions without doing anything
DRY_RUN=0
if [ "$1" = "--dry-run" ] || [ "$1" = "-n" ]; then
    DRY_RUN=1
    echo "*** DRY RUN — nothing will be extracted or deleted ***"
    echo
fi

# Loop through every .iso file in the current directory
for iso in *.iso; do
    # Skip if no .iso files are present
    [ -e "$iso" ] || continue

    # Strip the .iso extension to build the output folder name
    game_name="${iso%.iso}"

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "Would extract: \"$iso\"  ->  \"$game_name/\""
        echo "Would delete:  \"$iso\""
        echo
        continue
    fi

    echo "Extracting \"$iso\" to folder \"$game_name\" ..."
    extract-xiso -x -s -d "$game_name" "$iso"

    if [ $? -eq 0 ]; then
        echo "Extraction successful. Deleting \"$iso\" ..."
        rm "$iso"
    else
        echo "Extraction failed for \"$iso\". ISO not deleted."
    fi
    echo
done

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry run complete. No changes made."
else
    echo "All done."
fi
