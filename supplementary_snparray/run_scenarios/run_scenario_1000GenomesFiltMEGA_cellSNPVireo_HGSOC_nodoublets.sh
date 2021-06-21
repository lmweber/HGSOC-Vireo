#!/bin/bash

##################################################
# Shell script to run doublets simulation scenario
##################################################

# These scripts run the selected demultiplexing tool (e.g. cellSNP/Vireo) for a 
# given doublets simulation scenario (VCF file, dataset, percent doublets).


# qsub -cwd -pe local 10 -l mem_free=5G,h_vmem=6G,h_fsize=100G run_scenario.sh


# start runtime
start=`date +%s`


# ----------------------------------------------------------------------------------
# Scenario: 1000 Genomes Project VCF filtered (subset MEGA SNP array), cellSNP/Vireo
# ----------------------------------------------------------------------------------

# run cellSNP

mkdir -p ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo

# using recommended parameters for cellSNP
cellsnp-lite \
-s ../../../benchmarking/outputs/HGSOC/bam_merged/bam_merged.bam \
-b ../../../benchmarking/outputs/HGSOC/barcodes_merged/barcodes_merged.tsv \
-O ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/cellSNP \
-R ../../../genotype/MEGA/subset_MEGA_1000GenomesFilt.vcf \
-p 10 \
--minMAF=0.1 \
--minCOUNT=20 \
--gzip


# end runtime
end=`date +%s`
runtime=`expr $end - $start`

# save runtime
mkdir -p ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/runtimes
echo runtime: $runtime seconds > ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/runtimes/runtime_1000GenomesFiltMEGA_cellSNPVireo_cellSNP_HGSOC_nodoublets.txt

# start runtime
start=`date +%s`


# run Vireo

# note parameter for known number of samples (3 for HGSOC dataset, 6 for lung dataset)
vireo \
-c ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/cellSNP \
-N 3 \
-o ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/vireo \
--randSeed=123


# end runtime
end=`date +%s`
runtime=`expr $end - $start`

# save runtime
mkdir -p ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/runtimes
echo runtime: $runtime seconds > ../../../supplementary_snparray/scenarios/HGSOC/nodoublets/1000GenomesFiltMEGA_cellSNPVireo/runtimes/runtime_1000GenomesFiltMEGA_cellSNPVireo_vireo_HGSOC_nodoublets.txt

