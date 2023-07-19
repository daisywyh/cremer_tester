""""
so i guess i write comments now. this code is to making a goddamn gene catalogue from a given fasta file of compiled
HMMER hits and a csv file of strains that passed the filtering process.
"""

import csv
import sys
from Bio import SeqIO

# input
fasta_file = sys.argv[1]
csv_file = sys.argv[2]
# output
output_fasta = sys.argv[3]
# param
gene = sys.argv[4]

# csv_file = "/Users/rebeccachristensen/Desktop/Cremer_Lab_2022/propionate_gene_catalogue/config/P1_SP/0.75scoreFilter_nGenes_P1_SP_HMMER_hits_pract.csv"
# fasta_file = "/Users/rebeccachristensen/Desktop/Cremer_Lab_2022/propionate_gene_catalogue/workflow/out/nucProdigalTranslation/compiled_nuc_prodigal_translation_hit_strains.fna"
# gene = "methylmalonyl-CoA-mutase-EC5-4-99-2"
# output_fasta = "/Users/rebeccachristensen/Desktop/Cremer_Lab_2022/propionate_gene_catalogue/workflow/scripts/pract.fna"


gene_catalogue_records = []
sequence_catalogue = []

with open(csv_file, 'r') as f:
    dict_reader = csv.DictReader(f)
    for row in dict_reader:
        row_description = row[("hit_id." + gene)] + " " + row[("description." + gene)]
        for record in SeqIO.parse(fasta_file, "fasta"):
            row_gene_coord = row_description.split("/")[0]
            record_gene_coord = (str(record.id)).split(";")[0]
            # print(row_gene_coord)
            # print(record_gene_coord)

            row_strain = row["strain"]
            record_strain = (str(record.id)).split(";")[1]
            # print(row_strain)
            # print(record_strain)

            if row_gene_coord == record_gene_coord and row_strain == record_strain:
                coord = row_description.split("/")[1].split(" ")[0]
                start = int(coord.split("-")[0]) - 1
                end = int(coord.split("-")[1]) - 1
                record.id = row_description
                record.seq = record.seq[start:end]

                if str(record.seq) not in sequence_catalogue:
                    sequence_catalogue.append(str(record.seq))
                    gene_catalogue_records.append(record)

SeqIO.write(gene_catalogue_records, output_fasta, "fasta")
