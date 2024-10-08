#!/bin/bash

# Update the package list
sudo apt-get update

# Install FastQC
echo "Installing FastQC..."
sudo apt-get install -y fastqc

# Install FastP
echo "Installing FastP..."
sudo apt-get install -y fastp

# Install BWA
echo "Installing BWA..."
sudo apt-get install -y bwa

# Install SAMtools
echo "Installing SAMtools..."
sudo apt-get install -y samtools

# Install bcftools
echo "Installing bcftools..."
sudo apt-get install -y bcftools
