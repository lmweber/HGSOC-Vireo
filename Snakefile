#####################################
# Snakefile to run Snakemake pipeline
#####################################

# ---------
# variables
# ---------

dir_scripts = "scripts"
dir_data = "../data"
dir_outputs = "../outputs"
dir_outputs_HGSOC = dir_outputs + "/HGSOC"
dir_outputs_lung = dir_outputs + "/lung"
dir_runtimes = "../runtimes"
dir_runtimes_HGSOC = dir_runtimes + "/HGSOC"
dir_runtimes_lung = dir_runtimes + "/lung"
dir_timestamps = "../timestamps"
dir_timestamps_HGSOC = dir_timestamps + "/HGSOC"
dir_timestamps_lung = dir_timestamps + "/lung"


sample_ids_HGSOC = ["16030X2_HJVMLDMXX", "16030X3_HJTWLDMXX", "16030X4_HJTWLDMXX"]
sample_ids_HGSOC_short = ["X2", "X3", "X4"]
sample_ids_HGSOC_short_named = {"16030X2_HJVMLDMXX": "X2", 
                                "16030X3_HJTWLDMXX": "X3", 
                                "16030X4_HJTWLDMXX": "X4"}

sample_ids_lung = ["LUNG_T08", "LUNG_T09", "LUNG_T20", "LUNG_T25", "LUNG_T28", "LUNG_T31"]
sample_ids_lung_short = ["T08", "T09", "T20", "T25", "T28", "T31"]
sample_ids_lung_short_named = {"LUNG_T08": "T08", 
                               "LUNG_T09": "T09", 
                               "LUNG_T20": "T20", 
                               "LUNG_T25": "T25", 
                               "LUNG_T28": "T28", 
                               "LUNG_T31": "T31"}

fastq_dirs_HGSOC = {"16030X2_HJVMLDMXX": "../../data/HGSOC/16030R/Fastq/16030X2_HJVMLDMXX", 
                    "16030X3_HJTWLDMXX": "../../data/HGSOC/16030R/Fastq/16030X3_HJTWLDMXX", 
                    "16030X4_HJTWLDMXX": "../../data/HGSOC/16030R/Fastq/16030X4_HJTWLDMXX"}

fastq_dirs_lung = {"LUNG_T08": "../../data/lung/LUNG_T08", 
                   "LUNG_T09": "../../data/lung/LUNG_T09", 
                   "LUNG_T20": "../../data/lung/LUNG_T20", 
                   "LUNG_T25": "../../data/lung/LUNG_T25", 
                   "LUNG_T28": "../../data/lung/LUNG_T28", 
                   "LUNG_T31": "../../data/lung/LUNG_T31"}


# ------------
# run pipeline
# ------------

# command to run pipeline on cluster

# snakemake --cluster "qsub -V -cwd -pe local 10 -l mem_free=5G,h_vmem=10G,h_fsize=100G" -j 9 --local-cores 30 --latency-wait 10


# --------------
# pipeline rules
# --------------

# default rule

rule all:
  input:
    dir_timestamps_HGSOC + "/vireo/timestamp_vireo.txt", 
    dir_timestamps_lung + "/vireo/timestamp_vireo.txt"


# ---------
# run Vireo
# ---------

# HGSOC (3 samples)
rule run_vireo_HGSOC:
  input:
    dir_timestamps_HGSOC + "/cellSNP/timestamp_cellSNP.txt", 
    script_vireo = dir_scripts + "/run_vireo.sh"
  output:
    dir_timestamps_HGSOC + "/vireo/timestamp_vireo.txt"
  params:
    n_samples = 3
  shell:
    "bash {input.script_vireo} {dir_runtimes_HGSOC} {dir_timestamps_HGSOC} NA "
    "{dir_outputs_HGSOC} {params.n_samples}"

# lung (6 samples)
rule run_vireo_lung:
  input:
    dir_timestamps_lung + "/cellSNP/timestamp_cellSNP.txt", 
    script_vireo = dir_scripts + "/run_vireo.sh"
  output:
    dir_timestamps_lung + "/vireo/timestamp_vireo.txt"
  params:
    n_samples = 6
  shell:
    "bash {input.script_vireo} {dir_runtimes_lung} {dir_timestamps_lung} NA "
    "{dir_outputs_lung} {params.n_samples}"


# -----------
# run cellSNP
# -----------

# HGSOC
rule run_cellSNP_HGSOC:
  input:
    dir_timestamps_HGSOC + "/parse_and_merge_barcodes/timestamp_parse_and_merge_barcodes.txt", 
    script_cellSNP = dir_scripts + "/run_cellSNP.sh"
  output:
    dir_timestamps_HGSOC + "/cellSNP/timestamp_cellSNP.txt"
  shell:
    "bash {input.script_cellSNP} {dir_runtimes_HGSOC} {dir_timestamps_HGSOC} 10 "
    "{dir_data} {dir_outputs_HGSOC}"

# lung
rule run_cellSNP_lung:
  input:
    dir_timestamps_lung + "/parse_and_merge_barcodes/timestamp_parse_and_merge_barcodes.txt", 
    script_cellSNP = dir_scripts + "/run_cellSNP.sh"
  output:
    dir_timestamps_lung + "/cellSNP/timestamp_cellSNP.txt"
  shell:
    "bash {input.script_cellSNP} {dir_runtimes_lung} {dir_timestamps_lung} 10 "
    "{dir_data} {dir_outputs_lung}"


# ----------------------------------
# parse and merge cell barcode files
# ----------------------------------

# HGSOC
rule parse_and_merge_barcodes_HGSOC:
  input:
    dir_timestamps_HGSOC + "/merge_and_index_BAM/timestamp_merge_and_index_BAM.txt", 
    script_parse_and_merge_barcodes = dir_scripts + "/parse_and_merge_barcodes_HGSOC.sh"
  output:
    dir_timestamps_HGSOC + "/parse_and_merge_barcodes/timestamp_parse_and_merge_barcodes.txt"
  params:
    sample_id_1 = lambda wildcards: sample_ids_HGSOC[0], 
    sample_id_2 = lambda wildcards: sample_ids_HGSOC[1], 
    sample_id_3 = lambda wildcards: sample_ids_HGSOC[2], 
    sample_id_1_short = lambda wildcards: sample_ids_HGSOC_short[0], 
    sample_id_2_short = lambda wildcards: sample_ids_HGSOC_short[1], 
    sample_id_3_short = lambda wildcards: sample_ids_HGSOC_short[2]
  shell:
    "bash {input.script_parse_and_merge_barcodes} {dir_runtimes_HGSOC} {dir_timestamps_HGSOC} NA "
    "{dir_outputs_HGSOC} "
    "{params.sample_id_1} {params.sample_id_2} {params.sample_id_3} "
    "{params.sample_id_1_short} {params.sample_id_2_short} {params.sample_id_3_short}"

# lung
rule parse_and_merge_barcodes_lung:
  input:
    dir_timestamps_lung + "/merge_and_index_BAM/timestamp_merge_and_index_BAM.txt", 
    script_parse_and_merge_barcodes = dir_scripts + "/parse_and_merge_barcodes_lung.sh"
  output:
    dir_timestamps_lung + "/parse_and_merge_barcodes/timestamp_parse_and_merge_barcodes.txt"
  params:
    sample_id_1 = lambda wildcards: sample_ids_lung[0], 
    sample_id_2 = lambda wildcards: sample_ids_lung[1], 
    sample_id_3 = lambda wildcards: sample_ids_lung[2], 
    sample_id_4 = lambda wildcards: sample_ids_lung[3], 
    sample_id_5 = lambda wildcards: sample_ids_lung[4], 
    sample_id_6 = lambda wildcards: sample_ids_lung[5], 
    sample_id_1_short = lambda wildcards: sample_ids_lung_short[0], 
    sample_id_2_short = lambda wildcards: sample_ids_lung_short[1], 
    sample_id_3_short = lambda wildcards: sample_ids_lung_short[2], 
    sample_id_4_short = lambda wildcards: sample_ids_lung_short[3], 
    sample_id_5_short = lambda wildcards: sample_ids_lung_short[4], 
    sample_id_6_short = lambda wildcards: sample_ids_lung_short[5]
  shell:
    "bash {input.script_parse_and_merge_barcodes} {dir_runtimes_lung} {dir_timestamps_lung} NA "
    "{dir_outputs_lung} "
    "{params.sample_id_1} {params.sample_id_2} {params.sample_id_3} "
    "{params.sample_id_4} {params.sample_id_5} {params.sample_id_6} "
    "{params.sample_id_1_short} {params.sample_id_2_short} {params.sample_id_3_short} "
    "{params.sample_id_4_short} {params.sample_id_5_short} {params.sample_id_6_short}"


# -------------------------
# merge and index BAM files
# -------------------------

# HGSOC
rule merge_and_index_BAM_HGSOC:
  input:
    expand(dir_timestamps_HGSOC + "/parse_BAM_files/timestamp_parse_BAM_files_{sample_HGSOC}.txt", sample_HGSOC = sample_ids_HGSOC), 
    script_merge_and_index_BAM = dir_scripts + "/merge_and_index_BAM_HGSOC.sh"
  output:
    dir_timestamps_HGSOC + "/merge_and_index_BAM/timestamp_merge_and_index_BAM.txt"
  params:
    sample_id_1 = lambda wildcards: sample_ids_HGSOC[0], 
    sample_id_2 = lambda wildcards: sample_ids_HGSOC[1], 
    sample_id_3 = lambda wildcards: sample_ids_HGSOC[2]
  shell:
    "bash {input.script_merge_and_index_BAM} {dir_runtimes_HGSOC} {dir_timestamps_HGSOC} NA "
    "{dir_outputs_HGSOC} {params.sample_id_1} {params.sample_id_2} {params.sample_id_3}"

# lung
rule merge_and_index_BAM_lung:
  input:
    expand(dir_timestamps_lung + "/parse_BAM_files/timestamp_parse_BAM_files_{sample_lung}.txt", sample_lung = sample_ids_lung), 
    script_merge_and_index_BAM = dir_scripts + "/merge_and_index_BAM_lung.sh"
  output:
    dir_timestamps_lung + "/merge_and_index_BAM/timestamp_merge_and_index_BAM.txt"
  params:
    sample_id_1 = lambda wildcards: sample_ids_lung[0], 
    sample_id_2 = lambda wildcards: sample_ids_lung[1], 
    sample_id_3 = lambda wildcards: sample_ids_lung[2], 
    sample_id_4 = lambda wildcards: sample_ids_lung[3], 
    sample_id_5 = lambda wildcards: sample_ids_lung[4], 
    sample_id_6 = lambda wildcards: sample_ids_lung[5]
  shell:
    "bash {input.script_merge_and_index_BAM} {dir_runtimes_lung} {dir_timestamps_lung} NA "
    "{dir_outputs_lung} {params.sample_id_1} {params.sample_id_2} {params.sample_id_3} "
    "{params.sample_id_4} {params.sample_id_5} {params.sample_id_6}"


# ---------------------------------------------------------
# parse BAM files to add unique sample IDs to cell barcodes
# ---------------------------------------------------------

# HGSOC
rule parse_BAM_files_HGSOC:
  input:
    dir_timestamps_HGSOC + "/cellranger/timestamp_cellranger_{sample_HGSOC}.txt", 
    script_parse_BAM_files = dir_scripts + "/parse_BAM_files.sh"
  output:
    dir_timestamps_HGSOC + "/parse_BAM_files/timestamp_parse_BAM_files_{sample_HGSOC}.txt"
  params:
    short_sample_id = lambda wildcards: sample_ids_HGSOC_short_named[wildcards.sample_HGSOC]
  shell:
    "bash {input.script_parse_BAM_files} {dir_runtimes_HGSOC} {dir_timestamps_HGSOC} NA "
    "{wildcards.sample_HGSOC} {params.short_sample_id} {dir_outputs_HGSOC}"

# lung
rule parse_BAM_files_lung:
  input:
    dir_timestamps_lung + "/cellranger/timestamp_cellranger_{sample_lung}.txt", 
    script_parse_BAM_files = dir_scripts + "/parse_BAM_files.sh"
  output:
    dir_timestamps_lung + "/parse_BAM_files/timestamp_parse_BAM_files_{sample_lung}.txt"
  params:
    short_sample_id = lambda wildcards: sample_ids_lung_short_named[wildcards.sample_lung]
  shell:
    "bash {input.script_parse_BAM_files} {dir_runtimes_lung} {dir_timestamps_lung} NA "
    "{wildcards.sample_lung} {params.short_sample_id} {dir_outputs_lung}"


# ---------------
# run Cell Ranger
# ---------------

# HGSOC
rule run_cellranger_HGSOC:
  input:
    script_cellranger = dir_scripts + "/run_cellranger.sh"
  output:
    dir_timestamps_HGSOC + "/cellranger/timestamp_cellranger_{sample_HGSOC}.txt"
  params:
    fastq_dir = lambda wildcards: fastq_dirs_HGSOC[wildcards.sample_HGSOC]
  shell:
    "bash {input.script_cellranger} {dir_runtimes_HGSOC} {dir_timestamps_HGSOC} 10 "
    "{wildcards.sample_HGSOC} ../{dir_data}/cellranger/refdata-gex-GRCh38-2020-A "
    "{params.fastq_dir} {dir_outputs_HGSOC}"

# lung
rule run_cellranger_lung:
  input:
    script_cellranger = dir_scripts + "/run_cellranger.sh"
  output:
    dir_timestamps_lung + "/cellranger/timestamp_cellranger_{sample_lung}.txt"
  params:
    fastq_dir = lambda wildcards: fastq_dirs_lung[wildcards.sample_lung]
  shell:
    "bash {input.script_cellranger} {dir_runtimes_lung} {dir_timestamps_lung} 10 "
    "{wildcards.sample_lung} ../{dir_data}/cellranger/refdata-gex-GRCh38-2020-A "
    "{params.fastq_dir} {dir_outputs_lung}"

