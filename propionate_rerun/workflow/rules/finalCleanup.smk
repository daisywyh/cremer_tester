from os.path import join
import os

configfile: "propionate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["propionate_rerun"]


rule all:
    input:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_readCounts.csv",

        expand("propionate_rerun/workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv", pathway = PATHWAY)

rule countTotalReads:
    input:
        join(config["readsDir"], "{read}.fa")
    output:
        join(config["readCounts"], "{read}_readCount.csv")
    shell:
        """
        count=$(grep ">" {input} | wc -l)
        echo {wildcards.read}","$count >> {output}
        """

# try fixing this by changing the ending?
# for f in {params.dir}/*.txt ; do cat $f ; done > {output}

rule compileReadCounts:
    output:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_readCounts.csv"
    params:
        dir=(join(config["readCounts"]))
    shell:
        """
        for f in {params.dir}/*.csv ; do cat $f ; done > {output}
        """

# # known issue -> fix by putting correct filepath
rule getGeneLengthsInCatalogue:
    input:
       "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/gene_catalogues/{pathway}_compiled_gene_catalogue.fa"

    output:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv"

    shell:
        # fixed this because it seems like it's the wrong filepath??
        #python3 propionate_rerun/workflow/out/scripts/gene_catalogue_seqlenths.py {input} {output}
        """
        python3 /home/users/daisywyh/cremer_tester/propionate_rerun/workflow/scripts/gene_catalogue_seqlengths.py {input} {output}
        """