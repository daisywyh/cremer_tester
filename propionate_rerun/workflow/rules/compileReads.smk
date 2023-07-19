from os.path import join
import os

configfile: "config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["propionate_rerun"]
OVERALL_PATHWAY = 'propionate'

rule all:
    input:
        "workflow/out/pathway_abundance/compiled_readCounts.csv",

# try fixing this by changing the ending?
# for f in {params.dir}/*.txt ; do cat $f ; done > {output}

rule compileReadCounts:
    output:
        "workflow/out/pathway_abundance/compiled_readCounts.csv"
    params:
        dir=(join(config["readCounts"]))
    shell:
        """
        for f in {params.dir}/*.csv ; do cat $f ; done > {output}
        """