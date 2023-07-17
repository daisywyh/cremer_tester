set -euo pipefail

# cute little ascii art because we deserve nice things!
echo "             ____"
echo "snakemake   / . .\ "
echo "pipeline    \  ---< "
echo "start!       \  /"
echo "   __________/ / "
echo "-=:___________/ "

echo "how many cores do you want to use today?"

read numCores

# just do prefetch and dump
echo "doing prefetch + dump"
echo "this might take a while ... (ಥ﹏ಥ)"
snakemake -p --snakefile workflow/rules/prefetchDump.smk --cores $numCores

# this does rule removeGeneCatalogueDupicates
echo "doing removeGeneCatalogueDuplicates"
echo "note: this step is run manually as a shell command I hard coded"
awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"

echo "run runIndex.smk"
echo "making the Bowtie index! (♡-_-♡)"
echo "this might also take a while ... (ಥ﹏ಥ)"
snakemake -p --snakefile workflow/rules/runIndex.smk --cores $numCores

echo "run runActualBowtie.smk ((ε(*´･ω･)っ†*ﾟ¨ﾟﾟ･*:..☆"
snakemake -p --snakefile workflow/rules/runActualBowtie.smk --cores $numCores

echo "run summarise.smk ᕕ(⌐■_■)ᕗ ♪♬"
snakemake -p --snakefile workflow/rules/summarise.smk --cores $numCores

echo "run finalCleanup.smk ｡+.｡☆ﾟ:;｡+ﾟ ☆*ﾟ¨ﾟﾟ･*:..ﾞ((ε(*⌒▽⌒)†"
snakemake -p --snakefile workflow/rules/finalCLeanup.smk --cores $numCores

echo "SNAKEMAKE PIPELINE DONE!"