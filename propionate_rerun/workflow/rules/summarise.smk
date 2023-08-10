from os.path import join
import os

configfile: "propionate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["propionate_rerun"]
OVERALL_PATHWAY = 'propionate'

rule all:
    input:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_propionate_rerun.txt",
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_propionate_rerun.csv",

        expand("/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.txt", pathway=PATHWAY),
        expand("/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{pathway}.csv", pathway=PATHWAY),

        expand(join(config["readCounts"],"{read}_readCount.csv"), read=READS)



# known issue
# need to put in pathway_abundance for this to work
#"propionate_rerun/workflow/out/compiled_bt_hit_summaries.txt"
rule compileSummaries:
    output:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.txt"

    params:
        dir = (join(config["hitSummaries"]))
    shell:
        """
        for f in {params.dir}/*.json ; do cat $f ; done > {output}
        """


# # known bug
# # just forgot to put in the directory
# # this should be the correct version?

#"propionate_rerun/workflow/out/compiled_bt_hit_summaries.txt"

#"propionate_rerun/workflow/out/compiled_bt_hit_summaries.csv"

rule writeSummaryCSV:
    input:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.txt"

    output:
        "/home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/pathway_abundance/compiled_bt_hit_summaries_{overall_pathway}.csv"

    shell:
        """
        python3 /home/users/daisywyh/cremer_tester/propionate_rerun/workflow/scripts/write_hit_summary_csv.py {input} {output}
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
