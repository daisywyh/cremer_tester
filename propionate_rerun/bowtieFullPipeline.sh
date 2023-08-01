set -euo pipefail

# cute little ascii art because we deserve nice things!
echo "propionate   ____"
echo "snakemake   / . .\ "
echo "pipeline    \  ---< "
echo "start!       \  /"
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

# # just do prefetch and dump
echo "doing prefetch + dump"
echo "this might take a while ... (ಥ﹏ಥ)"
snakemake --snakefile propionate_rerun/workflow/rules/prefetchDump.smk --slurm --cores $NUMCORES -p --latency-wait 120

echo "doing editCatalogueIDs"
echo "note: this step is run manually as a python command I hard coded"
python3 propionate_rerun/workflow/scripts/edit_catalog_id.py "propionate_rerun/workflow/out/gene_catalogues/propionate_compiled_gene_catalogue.fa" "propionate_rerun/workflow/out/gene_catalogues/propionate_compiled_gene_catalogue_editIDs.fa"

# this does rule removeGeneCatalogueDupicates
echo "________________________________________________"
echo "doing removeGeneCatalogueDuplicates"
echo "note: this step is run manually as a shell command I hard coded"
awk '/^>/{f=!d[$1];d[$1]=1}f' "propionate_rerun/workflow/out/gene_catalogues/propionate_compiled_gene_catalogue_editIDs.fa" > "propionate_rerun/workflow/out/gene_catalogues/propionate_compiled_gene_catalogue_editIDs_noDups.fa"

echo "________________________________________________"
echo "run runIndex.smk"
echo "making the Bowtie index! (♡-_-♡)"
echo "this might also take a while ... (ಥ﹏ಥ)"                                                                                                                                                                                                                         
snakemake --snakefile propionate_rerun/workflow/rules/runIndex.smk --slurm --cores $NUMCORES -p

echo "________________________________________________"
echo "run runActualBowtie.smk ((ε(*´･ω･)っ†*ﾟ¨ﾟﾟ･*:..☆"
snakemake --snakefile propionate_rerun/workflow/rules/runActualBowtie.smk --slurm --cores $NUMCORES -p

echo "________________________________________________"
echo "run summarise.smk ᕕ(⌐■_■)ᕗ ♪♬"
snakemake --forcerun --snakefile propionate_rerun/workflow/rules/summarise.smk --slurm --cores $NUMCORES -p

echo "________________________________________________"
echo "run finalCleanup.smk ｡+.｡☆ﾟ:;｡+ﾟ ☆*ﾟ¨ﾟﾟ･*:..ﾞ((ε(*⌒▽⌒)†"
snakemake --forcerun --snakefile propionate_rerun/workflow/rules/finalCleanup.smk --slurm --cores $NUMCORES -p

echo "BOWTIE PIPELINE DONE! ＼＼\(۶•̀ᴗ•́)۶//／／"
echo "୧(๑•̀ヮ•́)૭ LET'S GO!"
echo "ヾ( ˃ᴗ˂ )◞ • *✰"