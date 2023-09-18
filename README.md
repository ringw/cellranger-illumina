# What is Cell Ranger?

Cell Ranger is an open source analysis pipeline from 10X Genomics. To build this Docker image, you should download a Cell Ranger Linux binary from 10X Genomics. This image in particular includes the bcl2fastq dependency. Instead of creating a bcl2fastq sample sheet using
[bcl2fastq directly](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/bcl2fastq-direct),
you may call `cellranger count`. You will still manage a CSV file which is one of the arguments to `cellranger`, but instead of including indexes (DNA sequences) in your CSV file, you will only need to know a 10X genomics sample index id, which is a shorter identifier than the index.

# What is bcl2fastq?

The Illumina bcl2fastq2 Conversion Software demultiplexes sequencing data and converts base call (BCL) files into FASTQ files. For more information, please see the latest [software guide](https://support.illumina.com/content/dam/illumina-support/documents/documentation/software_documentation/bcl2fastq/bcl2fastq2-v2-20-software-guide-15051736-03.pdf).