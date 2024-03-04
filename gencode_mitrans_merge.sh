#!/usr/bin/env bash

# Download annotations into ./Data/Annotations  (in gz file format)
## https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_45/gencode.v45.annotation.gtf.gz
## https://mitranscriptome.org/download/mitranscriptome.gtf.tar.gz

# Download required utils into ./Utils
## https://github.com/julienlag/buildLoci/blob/master/buildLoci.pl
## https://github.com/julienlag/utils/blob/master/tmerge

# Process data
## Filter exons and . strand for mitrans
zcat ./Data/Annotations/gencode.v45.annotation.gtf.gz | awk '$3=="exon"' > ./Data/Processed/exons.gencode.v45.annotation.gtf
zcat ./Data/Annotations/mitranscriptome.v2.gtf.gz | awk '$3=="exon" && $7!="."' > ./Data/Processed/exons.mitranscriptome.v2.gtf

## Concatenate, sort and tmerge
cat ./Data/Processed/exons.gencode.v45.annotation.gtf ./Data/Processed/exons.mitranscriptome.v2.gtf | sort -k1,1 -k4,4n | ./Utils/tmerge - > ./Data/Processed/tmerged_gencode_mitrans.gtf 

## BuildLoci
bedtools intersect -s -wao -a ./Data/Processed/tmerged_gencode_mitrans.gtf -b ./Data/Processed/tmerged_gencode_mitrans.gtf | ./Utils/buildLoci.pl - > ./Data/Processed/tmerged_gencode_mitrans.loci.gff

## Resulting file: tmerged_gencode_mitrans.loci.gff is too big for GitHub,
## but is available here:
## https://drive.google.com/drive/folders/1xQBRTB0k0CMPPBn2RjZE4S3ao_yWtG10?usp=sharing

