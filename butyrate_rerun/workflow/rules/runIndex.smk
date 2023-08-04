from os.path import join
import os

configfile: "butyrate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["butyrate_rerun"]
OVERALL_PATHWAY = 'butyrate'

rule all:
    input:
        join(config["indexDir"], "butyrate/butyrate_gene_catalogue.1.bt2"),

        "butyrate_rerun/workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa",
        "butyrate_rerun/workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa",

        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS),


# overall_pathway is still `butyrate/butyrate`
rule buildIndex:
    input:
        "butyrate_rerun/workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs_noDups.fa"
    params:
        index_name=lambda w: {w.overall_pathway}
    output:
        join(config["indexDir"], "{overall_pathway}_gene_catalogue.1.bt2")
    shell:
        """
        bowtie2-build -f {input} butyrate_rerun/workflow/out/index/{params.index_name}_gene_catalogue
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