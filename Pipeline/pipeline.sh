#!/bin/bash

# Create a directory for the results
mkdir -p results/qc results/trimmed results/aligned results/variants

# List of datasets
declare -A datasets=(
    ["ACBarrie"]="https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/ACBarrie_R1.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/ACBarrie_R2.fastq.gz"
    ["Alsen"]="https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Alsen_R1.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Alsen_R2.fastq.gz"
    ["Baxter"]="https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Baxter_R1.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Baxter_R2.fastq.gz"
    ["Chara"]="https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Chara_R1.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Chara_R2.fastq.gz"
    ["Drysdale"]="https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Drysdale_R1.fastq.gz https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Drysdale_R2.fastq.gz"
)

# Reference genome
REF_GENOME="https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/raw_reads/reference.fasta"
wget -O results/reference.fasta $REF_GENOME

# Loop through each dataset
for sample in "${!datasets[@]}"; do
    echo "Processing sample: $sample"
    
    # Download reads
    IFS=' ' read -r -a reads <<< "${datasets[$sample]}"
    wget -O results/${sample}_R1.fastq.gz "${reads[0]}"
    wget -O results/${sample}_R2.fastq.gz "${reads[1]}"

    # Quality Control
    fastqc results/${sample}_R1.fastq.gz results/${sample}_R2.fastq.gz -o results/qc/

    # Trimming
    fastp -i results/${sample}_R1.fastq.gz -I results/${sample}_R2.fastq.gz \
          -o results/trimmed/${sample}_R1_trimmed.fastq.gz -O results/trimmed/${sample}_R2_trimmed.fastq.gz \
          -h results/trimmed/${sample}_fastp_report.html

    # Genome Mapping
    bwa index results/reference.fasta
    bwa mem results/reference.fasta results/trimmed/${sample}_R1_trimmed.fastq.gz results/trimmed/${sample}_R2_trimmed.fastq.gz > results/aligned/${sample}_aligned.sam

    # Convert SAM to BAM and Sort
    samtools view -S -b results/aligned/${sample}_aligned.sam | samtools sort -o results/aligned/${sample}_sorted.bam

    # Variant Calling
    bcftools mpileup -f results/reference.fasta results/aligned/${sample}_sorted.bam | bcftools call -mv -Oz -o results/variants/${sample}_variants.vcf.gz
done

echo "Pipeline completed."

