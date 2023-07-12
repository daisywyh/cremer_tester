# this is for actually running in Sherlock
strainGenomeDir="referenceGeneFiles"
prodigalEnv="workflow/envs/prodigal_local.yml"
indexDir="workflow/out/index"
readsDir="workflow/out/scratch/reads"
reads_file="config/sra_run_accessions_Nayfach_short.txt"
bowtieOutput="workflow/out/scratch/bt_output"
bowtieOutputHits="workflow/out/scratch/bt_hits"
sraRepo="workflow/out/scratch/prefetched"
hitSummaries="workflow/out/bt_hit_summaries"
readCounts="workflow/out/readCounts"

# now i attempt to do buildIndex???
snakemake -p --snakefile snakefile_tester2.smk --cores 2

# this does rule removeGeneCatalogueDupicates:
# awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"
