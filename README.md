# Documentation for `bowtieFullPipeline.sh`

## Setup

### `mamba` environment

### Variables

#### `NUMCORES`

This refers to the number of cores you'd like Snakemake to run on. Specify this by changing the value for the variable `NUMCORES`.

## `prefetchDump.smk`

### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules

#### `prefetch`

Description: runs the `prefetch` comamnd to start downloading reads from NCBI.

#### `dump`

Description: runs the `dump` command to finish downloading reads from NCBI. 

### Last output file

## `removeGeneCatalogueDuplicates`

### Description

This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules ran

`prefetch`, `dump`

### Input files

### Last output file

## `runIndex.smk`

### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules ran

`prefetch`, `dump`

### Input files

### Last output file

## `runActualBowtie.smk`

### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules ran

`prefetch`, `dump`

### Input files

### Last output file

## `summarise.smk`

### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules ran

`prefetch`, `dump`

### Input files

### Last output file

## `finalCleanup.smk`

### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules ran

`prefetch`, `dump`

### Input files

### Last output file
