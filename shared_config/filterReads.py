reads = set()

prefetched = set()

complete = set()

incomplete = set()

with open('reads.txt') as f:
    lines = [line.rstrip() for line in f]
    for word in lines:
        word = word.split()
        for i in word:
            reads.add(i)

with open('prefetched.txt') as f:
    lines = [line.rstrip() for line in f]
    for word in lines:
        word = word.split()
        for i in word:
            prefetched.add(i)

with open('sra_run_accessions_Nayfach.txt') as f:
    lines = [line.rstrip() for line in f]
    for word in lines:
        word = word.split()
        for i in word:
            complete.add(i)
            incomplete.add(i)

for i in complete:
    if i in reads and i in prefetched:
        incomplete.remove(i)

complete = complete - incomplete

with open('incomplete_sra_run_accessions_Nayfach.txt', 'w') as f:
    for sra in incomplete:
        f.write(sra)
        f.write('\n')

with open('completed_sra_run_accessions_Nayfach.txt', 'w') as f:
    for sra in complete:
        f.write(sra)
        f.write('\n')