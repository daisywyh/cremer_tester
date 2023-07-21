set -euo pipefail

# cute little ascii art because we deserve nice things!
echo "             ____"
echo "clean       / ಥ ಥ\ "
echo "pipeline    \  --< "
echo "start        \  /"
echo "   __________/ / "
echo "-=:___________/ "

# get user input for number of cores to use
# echo "how many cores do you want to use today?"

# read NUMCORES

# default number for number of cores
NUMCORES=5

# FORCERUN=true

# RUNFLAG=""

# # if user indicated they wanted to make this a forced run, change flags to indicate this
# if [$FORCERUN]
# then  
#    RUNFLAG="--forceall"
# fi 

# just do prefetch and dump
echo "(ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ) (ಥ﹏ಥ)"
echo "removing all files from prefetch + dump"
snakemake --snakefile workflow/rules/prefetchDump.smk --delete-all-output --cores $NUMCORES 

echo "removing the output from removeGeneCatalogueDuplicates"
rm "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"

echo "removing runIndex.smk"
snakemake --snakefile workflow/rules/runIndex.smk --delete-all-output --cores $NUMCORES 

echo "removing runActualBowtie.smk ((ε(*´･ω･)っ†*ﾟ¨ﾟﾟ･*:..☆"
snakemake --snakefile workflow/rules/runActualBowtie.smk --delete-all-output --cores $NUMCORES

echo "removing summarise.smk ᕕ(⌐■_■)ᕗ ♪♬"
snakemake --snakefile workflow/rules/summarise.smk --delete-all-output --cores $NUMCORES

echo "removing finalCleanup.smk ｡+.｡☆ﾟ:;｡+ﾟ ☆*ﾟ¨ﾟﾟ･*:..ﾞ((ε(*⌒▽⌒)†"
snakemake --snakefile workflow/rules/finalCleanup.smk --delete-all-output --cores $NUMCORES

echo "The world has been cleansed. The files have been removed. May peace be with you once again."
