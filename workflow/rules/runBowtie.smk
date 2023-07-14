# i can't get the following two rules to work so i just compiled (cat) and ran the python code manually
# rule combineCatalogues:
#     input:
#         expand("workflow/out/compiled_pathway_catalogues/compiled_{pathway}_catalogue.faa", pathway=PATHWAYS)
#     output:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue.fa"
#     params:
#         input_dir="workflow/out/compiled_pathway_catalogues/"
#     shell:
#         """
#         for f in {params.input_dir}/*.faa ; do cat $f ; done > {output}
#         """

# rule editCatalogueIDs:
#     input:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue.fa"
#     output:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs.fa"
#     shell:
#         """
#         python3 workflow/scripts/edit_catalog_id.py {input} {output}
#         """

# bug: overall_pathway == butyrate/butyrate
# even bigger bug: this doesn't really work
# fix: run the following command directly in the shell
# awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"
# '''
# rule removeGeneCatalogueDupicates:
#     input:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs.fa"

#     output:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs_noDups.fa"

#     shell:
#         """
#         awk '/^>/{f=!d[$1];d[$1]=1}f' {input} > {output}
#         """
#         #awk '/^>/{f=!d[$1];d[$1]=1}f' "workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs.fa" > "workflow/out/gene_catalogues/butyrate_compiled_gene_catalogue_editIDs_noDups.fa"
# '''


# # note: overall_pathway is still `butyrate/butyrate`
# rule buildIndex:
#     input:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs_noDups.fa"
#     params:
#         index_name=lambda w: {w.overall_pathway}
#     output:
#         join(config["indexDir"], "{overall_pathway}_gene_catalogue.1.bt2")
#     shell:
#         """
#         bowtie2-build -f {input} workflow/out/index/{params.index_name}_gene_catalogue
#         """

#         # bowtie2-build -f workflow/out/gene_catalogues/butyrate/butyrate_compiled_gene_catalogue_editIDs_noDups.fa workflow/out/index/butyrate/butyrate_gene_catalogue


# rule runBowtie:
#     input:
#         reads=join(config["readsDir"], "{read}.fa")
#     output:
#         join(config["bowtieOutput"], "{overall_pathway}/{overall_pathway}_{read}_bt.sam")
#     params:
#         index_name=lambda w: {w.overall_pathway}
#     shell:
#         """
#         bowtie2 --very-sensitive --end-to-end -x workflow/out/index/{params.index_name}/{params.index_name}_gene_catalogue -f -U {input.reads} -S {output}
#         """


# rule filterBowtieOutput:
#     input:
#         join(config["bowtieOutput"],"{overall_pathway}/{overall_pathway}_{read}_bt.sam")
#     output:
#         join(config["bowtieOutputHits"],"{overall_pathway}/{overall_pathway}_{read}_bt_hits.sam")
#     shell:
#         """
#         samtools view {input} -S -F 4 > {output}
#         """

# # # samtools view "workflow/out/scratch/bt_output/butyrate/butyrate_ERR525688_bt.sam" -S -F 4 > "workflow/out/scratch/bt_hits/butyrate/butyrate_ERR525688_bt_hits.sam"


# rule summarizeHits:
#     input:
#         join(config["bowtieOutputHits"],"{overall_pathway}/{overall_pathway}_{read}_bt_hits.sam")
#     output:
#         join(config["hitSummaries"], "{overall_pathway}_{read}_hit_summary.json")
#     shell:
#         """
#         python3 workflow/scripts/summarize_hits.py {input} {output} {wildcards.overall_pathway} {wildcards.read}
#         """


# python3 workflow/scripts/summarize_hits.py "workflow/out/scratch/bt_hits/butyrate/butyrate_ERR525688_bt_hits.sam" "workflow/out/bt_hit_summaries/butyrate_ERR525688_hit_summary.json" kamA ERR525688

# known issue
# need to put in pathway_abundance for this to work
#"workflow/out/compiled_bt_hit_summaries.txt"
rule compileSummaries:
    output:
        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.txt"

    params:
        dir = (join(config["hitSummaries"]))
    shell:
        """
        for f in {params.dir}/*.json ; do cat $f ; done > {output}
        """


# # known bug
# # just forgot to put in the directory
# # this should be the correct version?

#"workflow/out/compiled_bt_hit_summaries.txt"

#"workflow/out/compiled_bt_hit_summaries.csv"


rule writeSummaryCSV:
    input:
        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.txt"

    output:
        "workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.csv"

    shell:
        """
        python3 workflow/scripts/write_hit_summary_csv.py {input} {output}
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

# # known issue -> fix by putting correct filepath
rule getGeneLengthsInCatalogue:
    input:
       "workflow/out/gene_catalogues/{pathway}_compiled_gene_catalogue.fa"

    output:
        "workflow/out/pathway_abundance/{pathway}_gene_catalogue_seqlengths.csv"

    shell:
        # fixed this because it seems like it's the wrong filepath??
        #python3 workflow/out/scripts/gene_catalogue_seqlenths.py {input} {output}
        """
        python3 workflow/scripts/gene_catalogue_seqlengths.py {input} {output}
        """