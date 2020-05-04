# Parse SAM files from Cell Ranger to add unique sample IDs to cell barcodes

# notes:
# syntax to search and replace: sed -i "s/regexp/replacement/g"
# regular expression matches cell barcode with format "CB:Z:AGCTTCCAGCAGTCTT-1"
# where the "-1" is the default sample ID added by Cell Ranger
# then we replace "-1" with a unique sample ID

# see also https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/output/bam


sed -i "s/\(CB\:Z\:[A-Z]\+\)\-1/\1\-X2/g" testing2.sam

