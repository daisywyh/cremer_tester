set -euo pipefail

# just do prefetch and dump
#echo "doing prefetch + dump"
#snakemake -p --snakefile workflow/rules/prefetchDump.smk --cores 5 --forceall

# this does rule removeGeneCatalogueDupicates
#echo "doing removeGeneCatalogueDuplicates"
#awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"

# now i attempt to do buildIndex???
echo "do the rest of the pipeline"
snakemake -p --snakefile snakefile_tester2.smk --cores 5 --rerun-incomplete