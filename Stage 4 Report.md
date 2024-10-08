**NGS Data Pipeline**

**Contibutors:** Cateline Atieno Ouma(@Cateline)

**Simple NGS Analysis**: https://github.com/Cateline/Stage-4-HackBio/blob/main/Simple%20NGS%20Analysis/NGS%20Bash%20Script

**Pipeline**: https://github.com/Cateline/Stage-4-HackBio/blob/main/Pipeline/pipeline.sh

In this project, I began by performing a simple next-generation sequencing (NGS) analysis using a bioinformatics pipeline to process raw sequencing data, assess its quality, map the reads to a reference genome, and identify genetic variants.

Using wget, I retrieved the forward and reverse reads from the provided URLs. Following this, I performed quality control using FastQC, a tool that checks for common issues in sequencing data such as low-quality reads, overrepresented sequences, and GC content bias. These were the generated reports;

Forward Strand:

![](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image002.png)

The quality metrics in the forward strand were within acceptable ranges showing that the raw reads were of high quality. There was a warning regarding the per sequence GC content indicating that the GC content distribution deviated from the expected range for the organism being studied.

Additionally, the per base sequence quality was flagged as a fail because some bases did not fall within the high-quality "green zone" on the FastQC report, particularly at the start and towards the ends of the reads. The per base sequence content was also flagged as a fail, indicating that the nucleotide distribution across the reads was not as balanced as expected. Ideally, the proportion of each nucleotide (A, T, G, C) should remain fairly consistent across the length of the reads. However, the FastQC report revealed noticeable imbalances, particularly at the start of the reads, which can be a sign of the presence of adapter sequences.

Reverse Strand:

![](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image004.png)

The reverse strand passed all the quality metrics except for the per base sequence content. The nucleotide distribution across the bases was not as expected, particularly at the start.

![](file:///C:/Users/ADMINI~1/AppData/Local/Temp/msohtmlclip1/01/clip_image006.png)

To address these issues, I used FastP to trim low-quality bases and remove adapter sequences from the raw reads. The average read length was 151 base pairs (bp) for both forward and reverse reads. After trimming, the average read length decreased slightly to 150 bp.  Duplicate reads present in the data were at about 11.67%. About 89.05% of the reads passed the filtering criteria, which is a good retention rate. The report also mentions a low adapter percentage (~0.096%), suggesting that there was minimal contamination from adapters

This step improved the overall quality of the reads and also prepared them for more accurate mapping to the reference genome. Next, I proceeded with genome mapping. I downloaded and indexed the reference genome using BWA, a tool for aligning sequencing reads to a reference genome. I then used BWA-MEM to map the trimmed reads to the reference, resulting in an alignment file (SAM format). This file was converted to BAM format and sorted using SAMtools for easier handling in downstream analyses.

Finally, I performed variant calling using bcftools. The result was a VCF file containing identified variants, such as SNPs and indels. I then developed a pipeline using Bash that integrates all these steps for a larger set of data. This pipeline automates the entire workflow, from downloading raw sequencing data to quality control, trimming, genome mapping, and variant calling.
