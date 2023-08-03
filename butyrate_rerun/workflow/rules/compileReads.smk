from os.path import join
import os

configfile: "butyrate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["butyrate_rerun"]
OVERALL_PATHWAY = 'butyrate'

rule all:
    input:
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_readCounts.csv",

# try fixing this by changing the ending?
# for f in {params.dir}/*.txt ; do cat $f ; done > {output}

rule compileReadCounts:
    output:
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_readCounts.csv"
    params:
        dir=(join(config["readCounts"]))
    shell:
        """
        for f in {params.dir}/*.csv ; do cat $f ; done > {output}
        """