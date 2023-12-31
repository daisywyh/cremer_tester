from os.path import join
import os

configfile: "propionate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["propionate_rerun"]
OVERALL_PATHWAY = 'propionate'

rule all:
    input:
        join(config["indexDir"], "propionate/propionate_gene_catalogue.1.bt2"),

        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/gene_catalogues/propionate/propionate_compiled_gene_catalogue_editIDs.fa",
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/gene_catalogues/propionate/propionate_compiled_gene_catalogue_editIDs_noDups.fa",

        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS),


# overall_pathway is still `propionate/propionate`

# note from running on sherlock: the overall pathway is still propionate/propionate 
rule buildIndex:
    input:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs_noDups.fa"
    params:
        index_name=lambda w: {w.overall_pathway}
    output:
        join(config["indexDir"], "{overall_pathway}_gene_catalogue.1.bt2")
    shell:
        """
        bowtie2-build -f {input} /home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/index/{params.index_name}_gene_catalogue
        """

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