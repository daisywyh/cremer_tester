from os.path import join
import os

configfile: "config/config.yml"

# this part for initial parsing of catalogue
# PATHWAYS = ["lysine", "glutarate", "aminobutyrate_buk", "aminobutyrate_but", "acetylCoA_buk", "acetylCoA_but"]
# PATHWAY = PATHWAYS[0]
#
# gene_file = "config/" + PATHWAY + "/" + PATHWAY + "_gene_list.txt"
# with open(gene_file, 'r') as f:
#     genes = f.read()
#     GENES = genes.split()
#
# with open(config["hitStrainF"], 'r') as f:
#     hit_strains = f.read()
#     HIT_STRAINS = hit_strains.split()

# this part for compiled catalogue of overall propionate/butyrate
# read in READS from list of accession in a read file
with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["butyrate_rerun"]

# new addition from daisy on the overall_pathway

OVERALL_PATHWAY = ['']


rule all:
    input:
        # download the metagenomic info and perform bowtie

        # run this in one batch first 

        #expand(join(config["sraRepo"],"{read}"),read=READS),
        #expand(join(config["readsDir"], "{read}.fa"), read = READS),
        # combine all pathways into the overarching butyrate or propionate catalogue
        # expand("workflow/out/compiled_pathway_catalogues/compiled_{pathway}_catalogue.faa",pathway=PATHWAYS),
        # expand("workflow/out/gene_catalogues/butyrate_compiled_gene_catalogue.fa", overall_pathway=OVERALL_PATHWAY),

        # this is the original
        #"workflow/out/gene_catalogues/butyrate_compiled_gene_catalogue_editIDs.fa",



        # this is my bad fix to the code
        # keep this when rerunning
        "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa",
        # known issue - unclear as to why it happens
        # solve by making a duplicate

	# bowtie search and following parsing

        # KEEP THE NEXT LINE
        join(config["indexDir"], "butyrate/butyrate_gene_catalogue.1.bt2"),
        # expand(join(config["bowtieOutput"],"butyrate/butyrate_{read}_bt.sam"), read=READS, overall_pathway=OVERALL_PATHWAY),
        # expand(join(config["bowtieOutputHits"],"butyrate/butyrate_{read}_bt_hits.sam"),read=READS,overall_pathway=OVERALL_PATHWAY),
        # expand(join(config["hitSummaries"], "butyrate_{read}_hit_summary.json"), read=READS, overall_pathway=OVERALL_PATHWAY),


        #KEEP THE FOLLOWING LINES
        expand(join(config["bowtieOutput"],"butyrate/butyrate_{read}_bt.sam"), read=READS),
        expand(join(config["bowtieOutputHits"],"butyrate/butyrate_{read}_bt_hits.sam"), read=READS),
        expand(join(config["hitSummaries"],"butyrate_{read}_hit_summary.json"), read=READS),


        # this is the original
        #"workflow/out/compiled_bt_hit_summaries.txt",
        #"workflow/out/compiled_bt_hit_summaries.csv",

        # this is my modified version
        # KEEP THE FOLLOWING LINES
        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.txt",
        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.csv",

        # do pathway counts!
        # KEEP THE NEXT TWO LINES
        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS),
        "workflow/out/pathway_abundance/compiled_readCounts.csv",


        # compiling results from bowtie search
        # expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.txt", pathway=PATHWAYS),
        # expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.csv", pathway=PATHWAYS),

        # KEEP THE NEXT TWO LINES
        expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.txt", pathway=PATHWAY),
        expand("workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.csv", pathway=PATHWAY),

        # getting gene lengths to perform gene length correctino for pathway abundance calcualtions'
        # KEEP THE NEXT LINE
        expand("workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv", pathway = PATHWAY)


include:
    # "workflow/rules/make_gene_catalogue.smk"
    "workflow/rules/runBowtie.smk"
