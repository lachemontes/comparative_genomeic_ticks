#!/bin/bash
#SBATCH -A naiss2024-5-647
#SBATCH -p shared
#SBATCH -c 8                         # Number of CPUs
#SBATCH --mem=120GB                 # Total memory
#SBATCH -t 3-00:00:00               # Max wall time: 3 days
#SBATCH -J busco_ticks              # Job name
#SBATCH --array=4-13                # Run as an array job for species 4 to 13
#SBATCH --mail-type=ALL            # Send email on all job events
#SBATCH --mail-user=zaide.montes_ortiz@biol.lu.se
#SBATCH -o /cfs/klemming/projects/supr/naiss2025-23-132/Ticks/analysis/busco/logs/busco_%A_%a.out
#SBATCH -o /cfs/klemming/projects/supr/naiss2025-23-132/Ticks/analysis/busco/logs/busco_%A_%a.out

# --- Load conda environment (adjust these lines if needed) ---
# source $HOME/miniconda3/etc/profile.d/conda.sh
# conda activate BUSCO
# or load your module via module load ...

# --- Define paths ---
BASE_DIR=/cfs/klemming/projects/supr/naiss2025-23-132/Ticks
GENOME_DIR=$BASE_DIR/data/genomes
OUTPUT_DIR=$BASE_DIR/analysis/busco
SPECIES_LIST=$BASE_DIR/scripts/tick_species_list.txt

# --- Get species name for current SLURM task ---
SPECIES=$(sed -n "$((SLURM_ARRAY_TASK_ID + 1))p" $SPECIES_LIST)

# --- Find the .fna file (genome assembly) ---
# Search recursively inside the 'data' folder for each species
FASTA=$(find "$GENOME_DIR/$SPECIES/data" -type f -name "*_genomic.fna" | head -n 1)

# --- Check if FASTA file was found ---
if [[ ! -f "$FASTA" ]]; then
    echo "ERROR: No .fna file found for $SPECIES in $GENOME_DIR/$SPECIES/data/" >&2
    exit 1
fi

# --- Create output directory for this species ---
OUT_SPECIES="$OUTPUT_DIR/$SPECIES"
mkdir -p "$OUT_SPECIES"

# --- Run BUSCO ---
# Note: The -o flag is used for the result prefix inside --out_path
busco -i "$FASTA" \
      -l arthropoda_odb10 \
      -o "$SPECIES" \
      -m genome \
      -c 8 \