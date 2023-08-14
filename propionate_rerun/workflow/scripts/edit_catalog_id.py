from Bio import SeqIO
import sys

# file = "/Users/rebeccachristensen/Desktop/Cremer_Lab_2022/propionate_gene_catalogue/workflow/out/compiled_gene_catalogue.fa"
# new_file = "../out/compiled_gene_catalogue_2.fa"

file = sys.argv[1]
new_file = sys.argv[2]

records = SeqIO.parse(file, 'fasta')
new_records = []

for record in records:
    strain_gene = str(record.description).split(" ")[1].split(" ")[0]
    record.id = strain_gene
    # print(record.id)
    new_records.append(record)

# print(new_records)

SeqIO.write(new_records, new_file, "fasta")


Alistipes-indistinctus-YIT-12060-MAF-2_methylmalonyl-CoA-decarboxylaseAlpha-KOK01604 1_2103/3-520 Alistipes-indistinctus-YIT-12060-MAF-2_methylmalonyl-CoA-decarboxylaseAlpha-KOK01604 1_2103;Alistipes-indistinctus-YIT-12060-MAF-2 1_2103 # 2575795 # 2577357 # -1 # ID=1_2103;partial=00;start_type=ATG;rbs_motif=None;rbs_spacer=None;gc_cont=0.575

Anaerotruncus-colihominis-DSM-17241-MAF-2_buk 1_709/6-358 Anaerotruncus-colihominis-DSM-17241-MAF-2_buk 1_709;Anaerotruncus-colihominis-DSM-17241-MAF-2 1_709 # 745328 # 746407 # -1 # ID=1_709;partial=00;start_type=ATG;rbs_motif=AGGAGG;rbs_spacer=5-10bp;gc_cont=0.550
