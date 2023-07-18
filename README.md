# Documentation for `bowtieFullPipeline.sh`

This is the documentation for the `bowtieFullPipeline.sh` pipeline. 

This documentation was last updated on **18 July 2023** by **Yu Han Daisy Wang**. For any questions or issues, please contact Daisy.

## 1. How to run this pipeline

### Setup

#### How to set up the `mamba` environment

1. Install `mamba` (or `conda`). I personally recommend `mamba`, but if `mamba` doesn't work (see Known Issues), `conda` works just fine as well, it's just slower.
   1. Link to install `mamba` using the Mambaforge: https://github.com/conda-forge/miniforge#mambaforge
   2. Link to install `conda` (specifically miniconda): https://docs.conda.io/en/latest/miniconda.html 
2. Fork/clone this GitHub repository into the location that you'd like to work in. 
3. Set up the `mamba`/`conda` environment.
``` bash
$ mamba env create -f workflow/envs/environment.yml
```

#### How to configure filepaths

The file paths directly below are not pertient to this pipeline, and you shouldn't have to change them.

```plain text
nucProdigalDir: "workflow/out/nucProdigalTranslation"
nucProdigalDirwHeader: "workflow/out/nucProdigalwHeader"
```

The following filepaths are self contained within this project, and you don't have to make change them. They represent where all the outputs of this pipeline will go. 

```
strainGenomeDir: "referenceGeneFiles"
prodigalEnv: "workflow/envs/prodigal_local.yml"
indexDir: "workflow/out/index"
readsDir: "workflow/out/scratch/reads"
bowtieOutput: "workflow/out/scratch/bt_output"
bowtieOutputHits: "workflow/out/scratch/bt_hits"
sraRepo: "workflow/out/scratch/prefetched"
readCounts: "workflow/out/readCounts"
hitSummaries: "workflow/out/bt_hit_summaries"
```

The `reads_file` is perhaps the most important file in the entire pipeline. It 
reads_file: "config/sra_run_accessions_Nayfach_short.txt"





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

This rule is manually run by the script, as it doesn't quite seem to work with Snakemake. 

### Input files

### Last output file

## `runIndex.smk`

### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

### Rules ran

`prefetch`, `dump`

### Input files

`workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa`
### Last output file

`workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa`

## `runActualBowtie.smk`

### Description

This 

### Rules ran

`filterBowtieOutput`, `runBowtie`, `summarizeHits`

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

## Known Issues
1. `mamba` doesn't seem to work on Apple M1 chip systems
   1. Solution: run this process on something with an x86_64 chip. In my case, I ran it on the lab server, which runs on an x86_64 system.
