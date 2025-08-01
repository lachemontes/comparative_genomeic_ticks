#!/bin/bash
#SBATCH -A naiss2024-5-647
#SBATCH -p shared
#SBATCH -c 12                     # Number of CPUs for QUAST
#SBATCH --mem=30GB                # Total memory for QUAST (adjust if needed)
#SBATCH -t 1-00:00:00
#SBATCH -J quast_combined         # Slurm job name
#SBATCH -o logs/quast_combined.out # Standard output file
#SBATCH -e logs/quast_combined.err # Standard error file
#SBATCH --mail-type=ALL
#SBATCH --mail-user=zaide.montes_ortiz@biol.lu.se

# --- Conda Setup (MAKE SURE THESE LINES ARE CORRECT AND UNCOMMENTED) ---
# If your miniconda is in your $HOME and your environment is 'quast_env':
# source $HOME/miniconda3/etc/profile.d/conda.sh
# conda activate quast_env
# or load the module
# -------------------------------------------------------------------------

# Main paths
BASE_DIR=/cfs/klemming/projects/supr/naiss2025-23-132/Ticks/data/genomes
COMBINED_RESULTS_DIR=$BASE_DIR/quast_combined_results  # Output directory for all combined results

# Create the combined results directory if it doesn't exist
mkdir -p "$COMBINED_RESULTS_DIR"

# Build the list of all assembly FASTA files
# IMPORTANT NOTE: The '-maxdepth 4' is key here.
# It searches:
# Level 0 → $BASE_DIR
# Level 1 → Species folder (e.g., A_americanum)
# Level 2 → 'data' folder
# Level 3 → GCA_/GCF_ folder
# Level 4 → .fna file
ALL_FASTA_FILES=$(find "$BASE_DIR" -maxdepth 4 -type f -name "*.fna" | tr '\n' ' ')

# Check that FASTA files were found before running QUAST
if [ -z "$ALL_FASTA_FILES" ]; then
    echo "ERROR: No assembly FASTA files matching *.fna found in the expected structure." >&2
    echo "Search path: $BASE_DIR" >&2
    echo "Make sure your .fna files are under subdirectories like: $BASE_DIR/Species/data/GCA_ID/file.fna" >&2
    exit 1
fi

# Print which FASTA files will be processed (useful for debugging)
echo "The following FASTA files will be processed:"
echo "$ALL_FASTA_FILES"
echo ""

# QUAST flags setup
# Assuming all are eukaryotic genomes
QUAST_FLAGS="--eukaryote"

# If most of your assemblies are fragmented, you can add:
# QUAST_FLAGS="$QUAST_FLAGS --fragmented"

# Run QUAST on all assemblies
# The thread number (-t) must not exceed the CPUs requested (-c) in SBATCH
echo "Starting combined QUAST run..."
quast.py -t 12 -o "$COMBINED_RESULTS_DIR" $QUAST_FLAGS $ALL_FASTA_FILES

echo "Combined QUAST process completed."
echo "Results are saved in: $COMBINED_RESULTS_DIR"
echo "Check 'report.html' and 'transposed_report.tsv' for figures and comparative metrics."