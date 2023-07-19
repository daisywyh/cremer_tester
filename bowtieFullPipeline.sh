set -euo pipefail

# cute little ascii art because we deserve nice things!
echo "             ____"
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


# just do prefetch and dump
echo "doing prefetch + dump"
echo "this might take a while ... (ಥ﹏ಥ)"
snakemake --snakefile workflow/rules/prefetchDump.smk --forceall --cores $NUMCORES -p

# this does rule removeGeneCatalogueDupicates
echo "________________________________________________"
echo "doing removeGeneCatalogueDuplicates"
echo "note: this step is run manually as a shell command I hard coded"
awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"

echo "________________________________________________"
echo "run runIndex.smk"
echo "making the Bowtie index! (♡-_-♡)"
echo "this might also take a while ... (ಥ﹏ಥ)"                                                                                                                                                                                                                         
snakemake --snakefile workflow/rules/runIndex.smk --forceall --cores $NUMCORES -p

echo "________________________________________________"
echo "run runActualBowtie.smk ((ε(*´･ω･)っ†*ﾟ¨ﾟﾟ･*:..☆"
snakemake --snakefile workflow/rules/runActualBowtie.smk --forceall --cores $NUMCORES -p

echo "________________________________________________"
echo "run summarise.smk ᕕ(⌐■_■)ᕗ ♪♬"
snakemake --snakefile workflow/rules/summarise.smk --forceall --cores $NUMCORES -p

echo "________________________________________________"
echo "run finalCleanup.smk ｡+.｡☆ﾟ:;｡+ﾟ ☆*ﾟ¨ﾟﾟ･*:..ﾞ((ε(*⌒▽⌒)†"
snakemake --snakefile workflow/rules/finalCleanup.smk --forceall --cores $NUMCORES -p

echo "BOWTIE PIPELINE DONE! ＼＼\(۶•̀ᴗ•́)۶//／／"
echo "୧(๑•̀ヮ•́)૭ LET'S GO!"
echo "ヾ( ˃ᴗ˂ )◞ • *✰"