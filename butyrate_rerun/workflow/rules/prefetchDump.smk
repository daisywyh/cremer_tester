"""
title: prefetchDump.smk
author: Yu Han Daisy Wang
date last modified: 13 July 2023
description: this is portioned out of the runBowtie.smk file. this is only because running these two commands
takes so damn long, so I've portioned them out to make the program more modular
"""

from os.path import join
import os

configfile: "config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

rule all: 
    input:
        expand(join(config["sraRepo"],"{read}"),read=READS),
        # expand(join(config["readsDir"], "{read}.fa"), read = READS),

rule prefetch:
    params:
        acc_num=lambda w: {w.read}
    output:
        join(config["sraRepo"],"{read}")
    shell:
        """
        prefetch {params.acc_num} -o {output}
        """

# rule dump:
#     input:
#         join(config["sraRepo"],"{read}")
#     output:
#         join(config["readsDir"],"{read}.fa")
#     shell:
#         "vdb-dump -f fasta {input} --output-file {output}"