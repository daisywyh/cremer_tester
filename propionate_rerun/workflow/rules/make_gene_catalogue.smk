rule nucProdigal:
    input:
        join(config["strainGenomeDir"],"{hit_strain}.fa")
    output:
        join(config["nucProdigalDir"],"{hit_strain}_prodigal_nuc.fna")
    conda:
        config["prodigalEnv"]
    shell:
        """
        prodigal -i {input} -d {output}
        """
rule addHeaderInfo:
    input:
        join(config["nucProdigalDir"],"{hit_strain}_prodigal_nuc.fna")
    output:
        join(config["nucProdigalDirwHeader"],"{hit_strain}_prodigal_nuc_addHeader.fna")
    shell:
        """
        python3 workflow/scripts/add_fasta_header.py {input} {output} {wildcards.hit_strain}
        """


rule compileNucProdigal:
    input:
        expand(join(config["nucProdigalDirwHeader"],"{hit_strain}_prodigal_nuc_addHeader.fna"), hit_strain=HIT_STRAINS)
    output:
        "propionate_rerun/workflow/out/compiled_nuc_prodigal_translation_hit_strains.fna"
    params:
        input_dir=config["nucProdigalDirwHeader"]
    shell:
        """
        for f in {params.input_dir}/*.fna ; do cat $f ; done > {output}
        """

rule makeGeneCatalogue:
    input:
        compiled_fasta_f="propionate_rerun/workflow/out/compiled_nuc_prodigal_translation_hit_strains.fna",
        strain_hits_csv_f="config/{pathway}/0.75scoreFilter_nGenes_{pathway}_HMMER_hits.csv"
    output:
        "propionate_rerun/workflow/out/{pathway}/{pathway}_{gene}_catalogue.faa"
    shell:
        """
        python3 workflow/scripts/make_gene_catalogue.py {input.compiled_fasta_f} {input.strain_hits_csv_f} {output} {wildcards.gene}
        """

rule compileGeneCatalogue:
    input:
        expand("propionate_rerun/workflow/out/{pathway}/{pathway}_{gene}_catalogue.faa", pathway=PATHWAY, gene=GENES)
    output:
        "propionate_rerun/workflow/out/compiled_pathway_catalogues/compiled_{pathway}_catalogue.faa"
    shell:
        """
        cat {input} > {output}
        """

