# Documentation for `bowtieFullPipeline.sh`

This is the documentation for the `bowtieFullPipeline.sh` pipeline. This pipeline is based on work first done by Rebecca Christensen

This documentation was last updated on **19 July 2023** by **Yu Han Daisy Wang**. For any questions or issues, please contact Daisy.

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

The input to this pipeline is controlled by the `reads_files` input. My current input is as belows.

```shell
reads_file: "config/sra_run_accessions_Nayfach_short.txt"
```
 
In the `reads_file`, input the SRA accession numbers of the samples you'd like to analyse. Input each SRA number on a seperate line, so that the file looks a little something like this:

```
SRA1
SRA2
SRA3
SRA4
```

### Running the actual pipeline

1. Make sure that you're in the correct working directory
   1. You should be in the most "base" (?) folder. In the case of this repository, its the `cremer_tester` folder.
2. Make sure that you've activated the correct `mamba`/`conda` environment
3. Change the value for `NUMCORES`
   1. In the file `bowtieFullPipeline.sh`, there is a variable called `NUMCORES` that specifies the number of cores you'd like like Snakemake to run on. Change this to our desired number. 
4. Run the actual file!
   1. You can do this by running `bash bowtieFullPipeline.sh`
   2. If you want this to run in the background



## 2. How to clean up if you messed up (`bowtieFullClean.sh`)
So you did something, there's some error, and now things didn't go well. You're running out of space on your machine. Whatever it is, say that for some reason, you want to delete all the output files. Luckily, I've also made a script for that. 

## 3. A breakdown of the pipeline and its files

### `prefetchDump.smk`

#### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

#### Rules

##### `prefetch`

Description: runs the `prefetch` comamnd to start downloading reads from NCBI.

##### `dump`

Description: runs the `dump` command to finish downloading reads from NCBI. 

#### Last output file

### `removeGeneCatalogueDuplicates`

#### Description

This rule is manually run by the script, as it doesn't quite seem to work with Snakemake. 

#### Input files

`workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa`

#### Last output file

`workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa`

### `runIndex.smk`

#### Description

This step makes the Bowtie index, but also counts the total reads for each sample.

#### Rules ran

`buildIndex`, `countTotalReads`

#### Input files

`"workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"`

all the reads from the `readsDir`

#### Last output files

`join(config["indexDir"], "{overall_pathway}_gene_catalogue.1.bt2")`

### `runActualBowtie.smk`

#### Description

This runs the actual steps for sequence alignment using bowtie. 

#### Rules ran

`filterBowtieOutput`, `runBowtie`, `summarizeHits`

#### Input files



#### Last output file

## `summarise.smk`

#### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

#### Rules ran

`prefetch`, `dump`

#### Input files

#### Last output file

### `finalCleanup.smk`

#### Description
This step takes in a list of SRA accession numbers, then uses them to download the actual reads from NCBI. 

#### Rules ran

`prefetch`, `dump`

#### Input files

#### Last output file

## Known Issues
1. `mamba` doesn't seem to work on Apple M1 chip systems
   1. Solution: run this process on something with an x86_64 chip. In my case, I ran it on the lab server, which runs on an x86_64 system.
