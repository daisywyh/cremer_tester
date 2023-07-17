'''
title: Snakefile_tester2.smk
author: Daisy Wang
time last modified: 14 July 2023
description: og tester broke. new attempt
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
        "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa",

        join(config["indexDir"], "butyrate/butyrate_gene_catalogue.1.bt2"),

        "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa",
        "workflow/out/gene_catalogues/butyrate_compiled_gene_catalogue_editIDs_noDups.fa",
        "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa",

        expand(join(config["bowtieOutput"], "butyrate/butyrate_{read}_bt.sam"), read=READS),
        expand(join(config["bowtieOutputHits"],"butyrate/butyrate_{read}_bt_hits.sam"),read=READS,overall_pathway=OVERALL_PATHWAY),
        expand(join(config["hitSummaries"], "butyrate_{read}_hit_summary.json"), read=READS, overall_pathway=OVERALL_PATHWAY),

        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.txt",
        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.csv",

        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS),
        "workflow/out/pathway_abundance/compiled_readCounts.csv",
        
        expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.txt", pathway=PATHWAY),
        expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.csv", pathway=PATHWAY),

        expand("workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv", pathway = PATHWAY)

include:
    "workflow/rules/runIndex.smk",
    "workflow/rules/runActualBowtie.smk",
    "workflow/rules/summarise.smk",
    "workflow/rules/compileReads.smk"