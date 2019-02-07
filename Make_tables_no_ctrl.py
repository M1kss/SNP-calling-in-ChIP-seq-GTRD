import sys


def write10(chr, pos, NAME, REF, ALT, ER, EA, QE, GQE, output10):
    ER = str(ER)
    EA = str(EA)
    output10.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + QE + '\t' + '0' + '\t' + GQE + '\t' + '0' + '\t' + ER + '\t' + EA + '\t' + '.' + '\t' + '.' + '\t' + '1' + '\t' + '0' + '\n')


vcf = open(sys.argv[1], 'r')
output10 = open(sys.argv[2], 'w')

exp = dict()

Nucleotides = {'A', 'T', 'G', 'C'}


def read_from_file(vcf, out):
    for line in vcf:
        if line[0] == '#':
            continue
        line = line.split()
        if len(line[3]) == 1 and len(line[4]) == 1:
            if line[3] in Nucleotides and line[4] in Nucleotides:
                Inf = line[-1].split(':')
                R = int(Inf[1].split(',')[0])
                A = int(Inf[1].split(',')[1])
                GQ = Inf[3]
                GT = Inf[0]
                NAME = line[2]
                REF = line[3]
                ALT = line[4]
                QUAL = line[5]
                out[(line[0], line[1])] = (R, A, NAME, REF, ALT, QUAL, GQ, GT)


read_from_file(vcf, exp)

skipped = 0

for (chr, pos) in exp.keys():
    (ER, EA, NAME, REF, ALT, QE, GQE, GT) = exp[(chr, pos)]

    if GT != '0/1':
        skipped += 1
        continue
    else:
        write10(chr, pos, NAME, REF, ALT, ER, EA, QE, GQE, output10)

print('Skipped {} homozigous SNPs'.format(skipped))
