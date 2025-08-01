#!/bin/bash

# This script renames BUSCO summary files in all species directories.

# Current location of the species directories
BASE_DIR="/cfs/klemming/projects/supr/naiss2025-23-132/Ticks/analysis/busco"

# Change to the main directory to work
cd "$BASE_DIR"

# List of all species to process
SPECIES_LIST=("A_americanum" "A_maculatum" "D_albipictus" "D_andersoni" "D_silvarum" "D_variabilis" "H_asiaticum" "H_longicornis" "I_persulcatus" "I_ricinus" "I_scapularis" "O_turicata" "R_microplus" "R_sanguineus")

# Iterate through each species in the list
for species in "${SPECIES_LIST[@]}"; do

    echo "Processing species: $species"

    # The results path has a nested folder with the same name
    # We check if the species directory exists
    if [[ -d "$species/$species" ]]; then

        # Build the old and new filenames for the .txt file
        OLD_TXT_FILE="$species/$species/short_summary.specific.arthropoda_odb10.${species}.txt"
        NEW_TXT_FILE="$species/$species/${species}.txt"
    
        # Build the old and new filenames for the .json file
        OLD_JSON_FILE="$species/$species/short_summary.specific.arthropoda_odb10.${species}.json"
        NEW_JSON_FILE="$species/$species/${species}.txt"

        # Rename the files if they exist
        if [[ -f "$OLD_TXT_FILE" ]]; then
            mv "$OLD_TXT_FILE" "$NEW_TXT_FILE"
            echo "  -> Renamed '$OLD_TXT_FILE' to '$NEW_TXT_FILE'"
        else
            echo "  -> .txt file not found at '$OLD_TXT_FILE'"
        fi

        if [[ -f "$OLD_JSON_FILE" ]]; then
            mv "$OLD_JSON_FILE" "$NEW_JSON_FILE"
            echo "  -> Renamed '$OLD_JSON_FILE' to '$NEW_JSON_FILE'"
        else
            echo "  -> .json file not found at '$OLD_JSON_FILE'"
        fi
    else
        echo "  -> Results directory does not exist at the expected path: '$species/$species'"
    fi

    echo "" # Add a blank line for clarity
done

echo "Renaming process finished."