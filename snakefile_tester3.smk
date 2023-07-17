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

rule all:
    input:
        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS),
        "workflow/out/pathway_abundance/compiled_readCounts.csv",

        expand("workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv", pathway = PATHWAY)

include:
    "workflow/rules/finalCleanup.smk"
