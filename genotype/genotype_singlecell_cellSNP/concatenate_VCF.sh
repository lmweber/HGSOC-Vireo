#!/bin/bash

#######################################
# Shell script to concatenate VCF files
#######################################

# This script concatenates VCF files from all 3 samples in the HGSOC dataset, 
# generated with the scripts "genotype_singlecell_HGSOC_16030XX.sh".


# qsub -V -cwd -l mem_free=2G,h_vmem=3G,h_fsize=300G concatenate_VCF.sh


# start runtime
start=`date +%s`


# ---------------------
# Concatenate VCF files
# ---------------------

# convert gzipped output files to bgzipped format (required by vcftools)

gunzip -c ../../../genotype/16030X2/cellSNP_singlecell/cellSNP.base.vcf.gz > ../../../genotype/16030X2/cellSNP_singlecell/cellSNP.base-bgz.vcf
bgzip ../../../genotype/16030X2/cellSNP_singlecell/cellSNP.base-bgz.vcf
gunzip -c ../../../genotype/16030X3/cellSNP_singlecell/cellSNP.base.vcf.gz > ../../../genotype/16030X3/cellSNP_singlecell/cellSNP.base-bgz.vcf
bgzip ../../../genotype/16030X3/cellSNP_singlecell/cellSNP.base-bgz.vcf
gunzip -c ../../../genotype/16030X4/cellSNP_singlecell/cellSNP.base.vcf.gz > ../../../genotype/16030X4/cellSNP_singlecell/cellSNP.base-bgz.vcf
bgzip ../../../genotype/16030X4/cellSNP_singlecell/cellSNP.base-bgz.vcf


# concatenate VCF files using vcftools (vcf-concat)

mkdir -p ../../../genotype/cellSNP_singlecell_merged

vcf-concat ../../../genotype/16030X2/cellSNP_singlecell/cellSNP.base-bgz.vcf.gz ../../../genotype/16030X3/cellSNP_singlecell/cellSNP.base-bgz.vcf.gz ../../../genotype/16030X4/cellSNP_singlecell/cellSNP.base-bgz.vcf.gz > \
../../../genotype/cellSNP_singlecell_merged/cellSNP.base-merged.vcf


# keep both unzipped and gzipped versions

gzip -c ../../../genotype/cellSNP_singlecell_merged/cellSNP.base-merged.vcf > ../../../genotype/cellSNP_singlecell_merged/cellSNP.base-merged.vcf.gz


# end runtime
end=`date +%s`
runtime=`expr $end - $start`

# save runtime
mkdir -p ../../../genotype/runtimes/genotype_singlecell_cellSNP
echo runtime: $runtime seconds > ../../../genotype/runtimes/genotype_singlecell_cellSNP/runtime_concatenate_VCF.txt

