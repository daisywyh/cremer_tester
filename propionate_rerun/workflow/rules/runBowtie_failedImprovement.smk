rule prefetch:
    params:
        acc_num=lambda w: {w.read}
    output:
        join(config["sraRepo"],"{read}")
    shell:
        """
        prefetch {params.acc_num} -o {output}
        """

rule dump:
    input:
        join(config["sraRepo"],"{read}")
    output:
        join(config["readsDir"],"{read}.fa")
    shell:
        "vdb-dump -f fasta {input} --output-file {output}"

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
#
# rule editCatalogueIDs:
#     input:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue.fa"
#     output:
#         "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs.fa"
#     shell:
#         """
#         python3 workflow/scripts/edit_catalog_id.py {input} {output}
#         """

rule buildIndex:
    input:
        "workflow/out/gene_catalogues/{overall_pathway}_compiled_gene_catalogue_editIDs.fa"
    params:
        index_name=lambda w: {w.overall_pathway}
    output:
        join(config["indexDir"], "{overall_pathway}_gene_catalogue.1.bt2")
    shell:
        """
        bowtie2-build -f {input} workflow/out/index/{params.index_name}_gene_catalogue
        """

rule runBowtie:
    input:
        reads=join(config["readsDir"], "{read}.fa")
    output:
        join(config["bowtieOutput"], "{overall_pathway}/{overall_pathway}_{read}_bt.sam")
    params:
        index_name=lambda w: {w.overall_pathway}
    shell:
        """
        bowtie2 --very-sensitive --end-to-end -x workflow/out/index/{params.index_name}_gene_catalogue -f -U {input.reads} -S {output} 
        """

rule filterBowtieOutput:
    input:
        join(config["bowtieOutput"],"{overall_pathway}/{overall_pathway}_{read}_bt.sam")
    output:
        join(config["bowtieOutputHits"],"{overall_pathway}/{overall_pathway}_{read}_bt_hits.sam")
    shell:
        """
        samtools view {input} -S -F 4 > {output}
        """

rule summarizeHits:
    input:
        join(config["bowtieOutputHits"],"{overall_pathway}/{overall_pathway}_{read}_bt_hits.sam")
    output:
        join(config["hitSummaries"], "{overall_pathway}_{read}_hit_summary.json")
    shell:
        """
        python3 workflow/scripts/summarize_hits.py {input} {output} {wildcards.overall_pathway} {wildcards.read}
        """

rule compileSummaries:
    output:
        "workflow/out/compiled_bt_hit_summaries.txt"
    params:
        dir = (join(config["hitSummaries"]))
    shell:
        """
        for f in {params.dir}/*.json ; do cat $f ; done > {output}
        """

rule writeSummaryCSV:
    input:
        "workflow/out/compiled_bt_hit_summaries.txt"
    output:
        "workflow/out/compiled_bt_hit_summaries.csv"
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

rule compileReadCounts:
    output:
        "workflow/out/compiled_readCounts.csv"
    params:
        dir=(join(config["readCounts"]))
    shell:
        """
        for f in {params.dir}/*.txt ; do cat $f ; done > {output}
        """