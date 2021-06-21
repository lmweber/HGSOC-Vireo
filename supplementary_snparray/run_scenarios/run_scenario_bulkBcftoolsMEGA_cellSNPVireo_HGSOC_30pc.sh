#!/bin/bash

##################################################
# Shell script to run doublets simulation scenario
##################################################

# These scripts run the selected demultiplexing tool (e.g. cellSNP/Vireo) for a 
# given doublets simulation scenario (VCF file, dataset, percent doublets).

# Requires the modified BAM file from the previous script "parse_BAM_doublets_X.sh".


# qsub -cwd -pe local 10 -l mem_free=5G,h_vmem=6G,h_fsize=100G run_scenario.sh


# start runtime
start=`date +%s`


# -------------------------------------------------------------------------------
# Scenario: bulk samples VCF from bcftools (subset MEGA SNP array), cellSNP/Vireo
# -------------------------------------------------------------------------------

# run cellSNP

mkdir -p ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo

# using recommended parameters for cellSNP
cellsnp-lite \
-s ../../../benchmarking/scenarios/HGSOC/30pc/bam_merged_doublets_HGSOC_30pc.bam \
-b ../../../benchmarking/scenarios/HGSOC/30pc/barcodes_merged_HGSOC_30pc.tsv \
-O ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/cellSNP \
-R ../../../genotype/MEGA/subset_MEGA_bcftools.vcf \
-p 10 \
--minMAF=0.1 \
--minCOUNT=20 \
--gzip


# end runtime
end=`date +%s`
runtime=`expr $end - $start`

# save runtime
mkdir -p ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/runtimes
echo runtime: $runtime seconds > ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/runtimes/runtime_bulkBcftoolsMEGA_cellSNPVireo_cellSNP_HGSOC_30pc.txt

# start runtime
start=`date +%s`


# run Vireo

# note parameter for known number of samples (3 for HGSOC dataset, 6 for lung dataset)
vireo \
-c ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/cellSNP \
-N 3 \
-o ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/vireo \
--randSeed=123


# end runtime
end=`date +%s`
runtime=`expr $end - $start`

# save runtime
mkdir -p ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/runtimes
echo runtime: $runtime seconds > ../../../supplementary_snparray/scenarios/HGSOC/30pc/bulkBcftoolsMEGA_cellSNPVireo/runtimes/runtime_bulkBcftoolsMEGA_cellSNPVireo_vireo_HGSOC_30pc.txt

