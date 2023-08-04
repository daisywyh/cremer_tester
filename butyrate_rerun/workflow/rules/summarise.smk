from os.path import join
import os

configfile: "butyrate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["butyrate_rerun"]
OVERALL_PATHWAY = 'butyrate"'

rule all:
    input:
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.txt",
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_butyrate_rerun.csv",

        expand("butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.txt", pathway=PATHWAY),
        expand("butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.csv", pathway=PATHWAY),

        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS)



# known issue
# need to put in pathway_abundance for this to work
#"butyrate_rerun/workflow/out/compiled_bt_hit_summaries.txt"
rule compileSummaries:
    output:
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.txt"

    params:
        dir = (join(config["hitSummaries"]))
    shell:
        """
        for f in {params.dir}/*.json ; do cat $f ; done > {output}
        """


# # known bug
# # just forgot to put in the directory
# # this should be the correct version?

#"butyrate_rerun/workflow/out/compiled_bt_hit_summaries.txt"

#"butyrate_rerun/workflow/out/compiled_bt_hit_summaries.csv"

rule writeSummaryCSV:
    input:
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.txt"

    output:
        "butyrate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.csv"

    shell:
        """
        python3 butyrate_rerun/workflow/scripts/write_hit_summary_csv.py {input} {output}
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
