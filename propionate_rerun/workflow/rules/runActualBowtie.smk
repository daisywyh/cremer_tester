from os.path import join
import os

configfile: "propionate_rerun/config/config.yml"

with open(config["reads_file"], 'r') as f:
    READS = f.read().split()

PATHWAY = ["propionate_rerun"]
OVERALL_PATHWAY = 'propionate'

rule all:
    input:
        expand(join(config["bowtieOutput"], "propionate/propionate_{read}_bt.sam"), read=READS),
        expand(join(config["bowtieOutputHits"],"propionate/propionate_{read}_bt_hits.sam"),read=READS,overall_pathway=OVERALL_PATHWAY),
        expand(join(config["hitSummaries"], "propionate_{read}_hit_summary.json"), read=READS, overall_pathway=OVERALL_PATHWAY),

rule runBowtie:
    input:
        reads=join(config["readsDir"], "{read}.fa")
    output:
        join(config["bowtieOutput"], "{overall_pathway}/{overall_pathway}_{read}_bt.sam")
    params:
        index_name=lambda w: {w.overall_pathway}
    shell:
        """
        bowtie2 --very-sensitive --end-to-end -x /home/users/daisywyh/cremer_tester/propionate_rerun/workflow/out/index/{params.index_name}/{params.index_name}_gene_catalogue -f -U {input.reads} -S {output}
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
        python3 /home/users/daisywyh/cremer_tester/propionate_rerun/workflow/scripts/summarize_hits.py {input} {output} {wildcards.overall_pathway} {wildcards.read}
        """