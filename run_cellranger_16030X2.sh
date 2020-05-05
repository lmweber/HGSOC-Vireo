# Bash script to run Cell Ranger to create BAM files for scRNA-seq samples

# see https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_ct


# note: Cell Ranger tends to give errors when running on JHPCE cluster, 
# possibly due to memory allocation and maximum file size issues; try adjusting 
# parameters in both 'qsub' and 'cellranger count' if it doesn't work


# runtime: up to 12 hours

#qsub -V -cwd -pe local 10 -l mem_free=10G,h_vmem=20G,h_fsize=200G run_cellranger.sh


cellranger count --id=16030X2_HJVMLDMXX \
--fastqs=../data/16030R/Fastq/16030X2_HJVMLDMXX \
--sample=16030X2_HJVMLDMXX \
--transcriptome=../data/GRCh38/refdata-cellranger-GRCh38-3.0.0 \
--nosecondary \
--jobmode=local \
--localcores=10 \
--localmem=50

# cellranger count --id=16030X3_HJTWLDMXX \
# --fastqs=../data/16030R/Fastq/16030X3_HJTWLDMXX \
# --sample=16030X3_HJTWLDMXX \
# --transcriptome=../data/GRCh38/refdata-cellranger-GRCh38-3.0.0 \
# --nosecondary \
# --jobmode=local \
# --localcores=10 \
# --localmem=50

# cellranger count --id=16030X4_HJTWLDMXX \
# --fastqs=../data/16030R/Fastq/16030X4_HJTWLDMXX \
# --sample=16030X4_HJTWLDMXX \
# --transcriptome=../data/GRCh38/refdata-cellranger-GRCh38-3.0.0 \
# --nosecondary \
# --jobmode=local \
# --localcores=10 \
# --localmem=50


