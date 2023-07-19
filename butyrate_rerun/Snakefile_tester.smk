'''
title: Snakefile_tester.smk
author: Daisy Wang
time last modified: 7 July 2023
description: for some reason, the expand command doesn't work within the actual master snakefile, 
hence i've created a shorter version of it, only containing the "expand" related rules
'''

from os.path import join
import os

configfile: "config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["butyrate_rerun"]
OVERALL_PATHWAY = 'butyrate"'


rule all:
    input:
        # expand(join(config["sraRepo"], "{read}"), read=READS),
        # expand(join(config["readsDir"], "{read}.fa"), read=READS),

        # "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa",
        # "workflow/out/gene_catalogues/butyrate_compiled_gene_catalogue_editIDs_noDups.fa",
        # "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa",


        #join(config["indexDir"], "butyrate/butyrate_gene_catalogue.1.bt2"),
        
        expand(join(config["bowtieOutput"],"butyrate/butyrate_{read}_bt.sam"), read=READS),
        expand(join(config["bowtieOutputHits"],"butyrate/butyrate_{read}_bt_hits.sam"), read=READS),
        expand(join(config["hitSummaries"],"butyrate_{read}_hit_summary.json"), read=READS),

        #"workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.txt",
        #"workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.csv",

        #expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS),
        #"workflow/out/pathway_abundance/compiled_readCounts.csv",

        #expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.txt", pathway=PATHWAY),
        #expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.csv", pathway=PATHWAY),

        #expand("workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv", pathway = PATHWAY)


include:
    "workflow/rules/runBowtie.smk"