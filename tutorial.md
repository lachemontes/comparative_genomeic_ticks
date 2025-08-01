# Genomic insights on the evolution of chemosensory receptor genes across different tick species

**Chemosensation is essential for ticks, helping them locate habitats, hosts, mates, and oviposition sites. Chemosensory receptor genes — including olfactory and gustatory receptor genes — play a central role in this process. Different tick species occupy diverse ecological niches and vary in life cycles and host preferences (e.g., reptiles, mammals, birds). As a result, they may have evolved distinct repertoires of chemosensory receptor genes to adapt to their specific environments and lifestyles.**

This repository contains all the data, scripts, programs, and step-by-step instructions for performing a comparative genomic analysis across 14 tick species, with a special focus on the castor bean tick, ***Ixodes ricinus***. The goal is to explore patterns in chemosensory gene evolution and provide a reproducible pipeline for others working on similar questions in tick genomics.

## **Programs and Tools**

**If you are working on an HPC system from your institution, the programs you need are likely already installed. In my case, I used the **[UPPMAX](https://www.uu.se/en/centre/uppmax) from Uppsala University, [Dardel HPC system](https://www.pdc.kth.se/hpc-services/computing-systems/dardel-hpc-system) from KTH and [COSMOS](https://www.lunarc.lu.se/systems/cosmos/) from Lund University — it’s always better to have access to more computing and storage resources, especially if you're trying to save your PhD (like I was!).

**Personally, I prefer to install software using **[conda](https://anaconda.org/anaconda/conda), [mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html), or [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/installation.html). Many people rely on their HPC support teams to install software, which can sometimes take a while. So, if you have the skills (or the curiosity) to do it yourself and save time, go for it! Of course, if your HPC support team is fast and efficient, that's also a great option.

`QUAST (v5.3.0)`

`BUSCO (6.0.0)`

`ncbi-datasets-cli`

`orthofinder ()`

`CAFE ()`

## **Directory Structure**

```
tick_genomics/
├── data/
│   ├── genomes/
│   │   ├── A_americanum/
│   │   ├── A_maculatum/
│   │   ├── D_albipictus/
│   │   ├── D_andersoni/
│   │   ├── D_silvarum/
│   │   ├── D_variabilis/
│   │   ├── H_asiaticum/
│   │   ├── H_longicornis/
│   │   ├── I_persulcatus/
│   │   ├── I_ricinus/
│   │   ├── I_scapularis/
│   │   ├── O_turicata/
│   │   ├── R_microplus/
│   │   ├── R_sanguineus/
│   │   ├── logs/
│   │   └── tick_species_list.txt
│   └── receptors/
├── scripts/
│   └── busco_downloads/
│       └── lineages/
│           └── arthropoda_odb10/
│               ├── hmms/
│               ├── info/
│               └── prfl/
├── analysis/
│   ├── busco/
│   │   └── [Species-specific BUSCO outputs]
│   ├── orthofinder/
│   └── quast/
│       └── quast_results/
│           └── [Species folders with QUAST output]
├── notebooks/          # (Optional: for Jupyter or Markdown analysis)
└── README.md
```

## Data Collection

**For this analysis, I used both ****genomic** and **transcriptomic** data from multiple public repositories, mainly [GenBank](https://www.ncbi.nlm.nih.gov/genbank/) and [RefSeq](https://www.ncbi.nlm.nih.gov/refseq/). Additionally, I generated new **RNA-seq data** as part of this study to complement the available resources and ensure better coverage for *Ixodes ricinus*, the focal species.

**Below you’ll find a table with details of the genomes used, including the assembly level, accession number, and how to download each dataset using the **`datasets` command-line tool from NCBI (if available). This made it easier to keep things organized and reproducible. **I really recommend using this tool to avoid manual errors or inconsistencies.**

**In the case of ***I. ricinus*, I used a curated assembly available through the BIPAA platform because it wasn’t available on NCBI with a formal accession. The download link (use wget) is included in the table as well.

> **💡 ***Tip:* I always keep a note of the day I collected each dataset, it helps to keep track in case versions change later or for reproducibility when writing the methods section.

### Genomic data

| **Specie_name**           | **Assembly_level** | **Accession_number** | **Assembly_name**           | **Publication_date** | **NCBI dataset command or link**                                                                                                                                                                                    | **data_collection_day** |
| ------------------------------- | ------------------------ | -------------------------- | --------------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| **A. americanum**         | **Scaffold**       | **GCA_030143305.2**  | **ASM3014330v2**            | **May, 2024**        | **datasets download genome accession GCA_030143305.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **16/07/2025**          |
| **A. maculatum**          | **Scaffold**       | **GCA_023969395.1**  | **ASM2396939v1**            | **Jun, 2022**        | **datasets download genome accession GCA_023969395.1 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **16/07/2025**          |
| **D. albipictus**         | **Chromosome**     | **GCA_038994185.2**  | **USDA_Dalb.pri_finalv2**   | **Oct, 2024**        | **datasets download genome accession GCF_038994185.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **22/07/2025**          |
| **D. andersoni**          | **Chromosome**     | **GCA_023375885.3**  | **qqDerAnde1_hic_scaffold** | **Nov, 2024**        | **datasets download genome accession GCF_023375885.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **17/07/2025**          |
| **D. silvarum**           | **Chromosome**     | **GCA_013339745.2**  | **BIME_Dsil_1.4**           | **Jun, 2022**        | **datasets download genome accession GCF_013339745.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **16/07/2025**          |
| **D. variabilis**         | **Contig**         | **GCA_049308735.1**  | **dogtick1.0**              | **Apr, 2025**        | **datasets download genome accession GCA_049308735.1 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **16/07/2025**          |
| **H. asiaticum**          | **Chromosome**     | **GCA_013339685.2**  | **BIME_Hyas_1.3**           | **Jun, 2020**        | **datasets download genome accession GCA_013339685.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **30/07/2025**          |
| **H. longicornis**        | **Chromosome**     | **GCA_013339765.2**  | **BIME_HaeL_1.3**           | **Jun, 2020**        | **datasets download genome accession GCA_013339765.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **16/07/2025**          |
| **I. persulcatus**        | **Chromosome**     | **GCA_964199295.2**  | **IXPE_v2**                 | **Jan, 2017**        | **datasets download genome accession GCA_964199295.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **30/07/2025**          |
| **I. ricinus**            | **Chromosome**     | **:(**               | **:(**                      | **Apr, 2024**        | [https://bipaa.genouest.org/sp/ixodes_ricinus/download/ixodes_ricinus/assembly_1.0/fasta/Iricinus_assembly.fa](https://bipaa.genouest.org/sp/ixodes_ricinus/download/ixodes_ricinus/assembly_1.0/fasta/Iricinus_assembly.fa) | **30/07/2025**          |
| **I. scapularis**         | **Chromosome**     | **GCA_031841145.1**  | **IscapMGN**                | **Sep, 2023**        | **datasets download genome accession GCA_031841145.1 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **16/07/2025**          |
| **Ornithodoros turicata** | **Chromosome**     | **GCA_037126465.1**  | **ASM3712646v1**            | **Mar, 2024**        | **datasets download genome accession GCF_037126465.1  --include  genome,protein,cds,rna,gff3,seq-report   --filename Ornithodoros_turicata_genome.zip**                                                             | **16/07/2025**          |
| **R. microplus**          | **Chromosome**     | **GCA_013339725.1**  | **BIME_Rmic_1.3**           | **Jun, 2020**        | **datasets download genome accession GCF_013339725.1 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **30/07/2025**          |
| **R. sanguineus**         | **Chromosome**     | **GCA_013339695.2**  | **BIME_Rsan_1.4**           | **Jun, 2022**        | **datasets download genome accession GCF_013339695.2 --include  gff3,rna,cds,protein,genome,seq-report**                                                                                                            | **30/07/2025**          |

### Transcriptomic data

## **Genome Quality Assessment**

### QUAST

**I used **[QUAST](https://quast.sourceforge.net/docs/manual.html)  via conda. **QUAST** stands for **Quality ASsessment Tool**, and it's used to evaluate the quality of genome assemblies.

**In simple terms, QUAST helps you ****check how good your genome assemblies are** by calculating useful metrics such as:

* **Total length of the assembly**
* **Number of contigs/scaffolds**
* **N50 and L50 statistics**
* **GC content**
* **Genome completeness (when a reference is provided)**

**It also generates helpful ****interactive visualizations** through a tool called **Icarus**, which makes it easier to explore and compare multiple assemblies.

**For this project, I used ****QUAST v5.3.0** to assess the genome assemblies of all tick species included in the study. This helped me identify differences in assembly quality, which is especially important before running any downstream analyses like gene prediction or orthology detection.

> **💡 ***Tip:* If you're dealing with fragmented or draft assemblies (as is often the case with non-model species), QUAST is a must-have to quickly spot assembly issues or gaps.

**You can install QUAST via **[Conda](https://anaconda.org/bioconda/quast) or check their latest releases and documentation on their [official website](http://quast.sf.net/).

```
#!/bin/bash
#SBATCH -A naiss2024-5-647
#SBATCH -p shared
#SBATCH -c 12                     # Number of CPUs for QUAST
#SBATCH --mem=30GB                # Total memory for QUAST (adjust if needed)
#SBATCH -t 1-00:00:00
#SBATCH -J quast_combined         # Slurm job name
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
COMBINED_RESULTS_DIR=$BASE_DIR/quast_combined_results  # Output directory for all combined results

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
```

### BUSCO

[BUSCO](https://busco.ezlab.org/) stands for **Benchmarking Universal Single-Copy Orthologs**. It's a tool used to **evaluate the completeness of genome assemblies** (or gene annotations) by searching for a set of highly conserved genes expected to be present in nearly all species within a given lineage.

**Think of BUSCO as a way to answer:**

> **"How complete is my genome?"**

### 🔍 What Does BUSCO Actually Do?

**BUSCO scans your genome (or transcriptome/protein set) for universal single-copy orthologs genes that should ****almost always be present and single-copy** in your species group.

**It gives you results like:**

* **Complete**: The gene was found and looks good
* **Duplicated**: Found more than once (e.g. possible assembly duplication)
* **Fragmented**: Found only partially
* **Missing**: Not found at all

**For this tick genomics project, I used BUSCO with the **`arthropoda_odb10` dataset (insects, ticks, crustaceans, etc.) to check the quality of genome assemblies across all 14 tick species. This is super helpful before doing any gene prediction or downstream analysis — you want to be sure your genome isn't missing large chunks!

> **💡 ***Tip:* A BUSCO completeness score above ~90% usually means you’re working with a pretty solid genome.

**You can run BUSCO easily on the command line with:**

```
busco -i your_genome.fna -l arthropoda_odb10 -m genome -o output_name
```

**Here is the script I used:**

```
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
```
