# mganske/computational-workflows-project

[![GitHub Actions CI Status](https://github.com/mganske/computational-workflows-project/actions/workflows/nf-test.yml/badge.svg)](https://github.com/mganske/computational-workflows-project/actions/workflows/nf-test.yml)
[![GitHub Actions Linting Status](https://github.com/mganske/computational-workflows-project/actions/workflows/linting.yml/badge.svg)](https://github.com/mganske/computational-workflows-project/actions/workflows/linting.yml)
[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/version-%E2%89%A525.10.4-green?style=flat&logo=nextflow&logoColor=white&color=%230DC09D&link=https%3A%2F%2Fnextflow.io)](https://www.nextflow.io/)
[![nf-core template version](https://img.shields.io/badge/nf--core_template-4.1.0-green?style=flat&logo=nfcore&logoColor=white&color=%2324B064&link=https%3A%2F%2Fnf-co.re)](https://github.com/nf-core/tools/releases/tag/4.1.0)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/mganske/computational-workflows-project)

## Introduction

**mganske/computational-workflows-project** is a bioinformatics pipeline or basic RNA-seq analysis of organisms with a reference genome and annotation. It takes a samplesheet with paired-end FASTQ files, a genome FASTA, a transcriptome FASTA and a GTF annotation as input. It performs quality control with FastQC, adapter and quality trimming with TrimGalore, transcript quantification with Salmon (transcriptome indexing plus mapping-based quantification, i.e. pseudo-alignment), genome alignment with HISAT2 and duplicate marking with Picard. It produces a gene expression table (TPM) per sample and a MultiQC report that aggregates the QC metrics.

![Metro Map Pipeline](https://raw.githubusercontent.com/mganske/computational-workflows-project/main/docs/images/metro_map.svg)

1. Read QC ([`FastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))
2. Adapter and quality trimming ([`TrimGalore`](https://www.trimgalore.com))
3. Transcriptome preparation: [`GFFREAD`](https://github.com/gpertea/gffread) builds the transcript FASTA from the genome and GTF
4. Genome alignment branch:
     1. Index building and alignment ([`HISAT2`](https://daehwankimlab.github.io/hisat2/))
     2. Sorting and indexing ([`SAMtools`]( https://www.htslib.org/))
     3. Duplicate marking ([`picard MarkDuplicates`](https://broadinstitute.github.io/picard/)), for QC only
     4. Transcript quantification ([`StringTie`](https://ccb.jhu.edu/software/stringtie/)), expression estimation against the GTF
5. Quantification branch:
     1. Index building and pseudo-alignment ([`Salmon`](https://combine-lab.github.io/salmon/))
     2. Gene-level merge ([`tximport`](https://bioconductor.org/packages/tximport/)) into one TPM table
6. QC summary ([`MultiQC`](http://multiqc.info/)) for FastQC, HISAT2, Picard and Salmon

## Requirements

- Nextflow version 26.04.6
- Docker with the daemon running, and internet access for the first container pulls.
- Memory: 13 GB RAM. 
- Disk: About 100 GB.
- Python 3 with pandas, or the container command, for the optional samplesheet script.
- Reference files: Ensembl release 102, GRCm38 (genome FASTA and GTF).

## Usage

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/get_started/environment_setup/overview) on how to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/get_started/run-your-first-pipeline) with `-profile test` before running the workflow on actual data.


First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq_1,fastq_2
SRX19144486,data/SRX19144486_SRR23195516_1.fastq.gz,data/SRX19144486_SRR23195516_2.fastq.gz
SRX19144488,data/SRX19144488_SRR23195511_1.fastq.gz,data/SRX19144488_SRR23195511_2.fastq.gz
```

Each row represents a fastq file (single-end) or a pair of fastq files (paired end). We only tested with paired-end reads.

If you have many paired-end files, we provide a python script that creates the samplesheet. It requires pandas and expects paired end files in a "data" folder. It might work with single-end files, but use at your own risk!

Now, you can run the pipeline using:

```bash
nextflow run mganske/computational-workflows-project -r 1.0.0 \
   -profile docker \
   --input samplesheet.csv \
   --fasta <genome.fa> \
   --transcript_fasta <transcript.fa> \
   --gtf <annotation.gtf> \
   --outdir <OUTDIR>
```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_; see [docs](https://nf-co.re/docs/running/run-pipelines#using-parameter-files).

## Credits

mganske/computational-workflows-project was originally written by Marcus Ganske & Davide Bordiga.

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](docs/CONTRIBUTING.md).

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use mganske/computational-workflows-project for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

<!-- TODO nf-core: Add bibliography of tools and data used in your pipeline -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/main/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
