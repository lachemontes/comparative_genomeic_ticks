#!/bin/bash

# This script copies all BUSCO .txt summary files to a central folder.

# Base directory where the BUSCO results are located (your current location)
BASE_DIR="/cfs/klemming/projects/supr/naiss2025-23-132/Ticks/analysis/busco"

# Destination directory for the copied files
OUTPUT_DIR="$BASE_DIR/busco_results"

# List of all species we are processing
SPECIES_LIST=("A_americanum" "A_maculatum" "D_albipictus" "D_andersoni" "D_silvarum" "D_variabilis" "H_asiaticum" "H_longicornis" "I_persulcatus" "I_ricinus" "I_scapularis" "O_turicata" "R_microplus" "R_sanguineus")

# --------------------------------------------------------------------------

# Step 1: Create the output directory if it does not exist
mkdir -p "$OUTPUT_DIR"
echo "Destination directory created at: $OUTPUT_DIR"
echo ""

# Step 2: Iterate over each species and copy the .txt file
for species in "${SPECIES_LIST[@]}"; do
    
    # The path to the species' .txt file
    SOURCE_FILE="$BASE_DIR/$species/$species/${species}.txt"
    
    # Check if the file exists before copying
    if [[ -f "$SOURCE_FILE" ]]; then
        echo "Copying file for $species..."
        cp "$SOURCE_FILE" "$OUTPUT_DIR/"
    else
        echo "Warning: File not found for $species at '$SOURCE_FILE'. Skipping."
    fi

done

echo ""
echo "Copy process finished. All files are in '$OUTPUT_DIR'."