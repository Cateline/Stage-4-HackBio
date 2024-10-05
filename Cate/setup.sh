#!/bin/bash

# Create a conda environment
conda create -n ngs_pipeline python=3.9 -y
conda activate ngs_pipeline

# Install required tools
conda install -c bioconda fastqc fastp bwa samtools bcftools -y

echo "Environment setup completed. Activate it with 'conda activate ngs_pipeline'."
