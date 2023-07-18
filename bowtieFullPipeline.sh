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

NUMCORES=5

FORCERUN=true

RUNFLAG=""

if [FORCERUN]
then  
   RUNFLAG="--forceall"
fi 


# just do prefetch and dump
echo "doing prefetch + dump"
echo "this might take a while ... (ಥ﹏ಥ)"
snakemake --snakefile workflow/rules/prefetchDump.smk --cores $NUMCORES $RUNFLAG

# this does rule removeGeneCatalogueDupicates
echo "doing removeGeneCatalogueDuplicates"
echo "note: this step is run manually as a shell command I hard coded"
awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa" & disown

echo "run runIndex.smk"
echo "making the Bowtie index! (♡-_-♡)"
echo "this might also take a while ... (ಥ﹏ಥ)"
snakemake --snakefile workflow/rules/runIndex.smk --cores $NUMCORES $RUNFLAG

echo "run runActualBowtie.smk ((ε(*´･ω･)っ†*ﾟ¨ﾟﾟ･*:..☆"
snakemake --snakefile workflow/rules/runActualBowtie.smk --cores $NUMCORES $RUNFLAG

echo "run summarise.smk ᕕ(⌐■_■)ᕗ ♪♬"
snakemake --snakefile workflow/rules/summarise.smk --cores $NUMCORES $RUNFLAG

echo "run finalCleanup.smk ｡+.｡☆ﾟ:;｡+ﾟ ☆*ﾟ¨ﾟﾟ･*:..ﾞ((ε(*⌒▽⌒)†"
snakemake --snakefile workflow/rules/finalCleanup.smk --cores $NUMCORES $RUNFLAG

echo "BOWTIE PIPELINE DONE! ＼＼\(۶•̀ᴗ•́)۶//／／"
echo "୧(๑•̀ヮ•́)૭ LET'S GO!"
echo "ヾ( ˃ᴗ˂ )◞ • *✰"