import sys


def write10(chr, pos, NAME, REF, ALT, ER, EA, output10):
    ER = str(ER)
    EA = str(EA)
    output10.write(
        chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + ER + '\t' + EA + '\t' + '.' + '\t' + '.' + '\t' + '1' + '\t' + '0' + '\n')


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
                R = int(line[-1].split(':')[1].split(',')[0])
                A = int(line[-1].split(':')[1].split(',')[1])
                NAME = line[2]
                REF = line[3]
                ALT = line[4]
                out[(line[0], line[1])] = (R, A, NAME, REF, ALT)


read_from_file(vcf, exp)

skipped = 0

for (chr, pos) in exp.keys():
    (ER, EA, NAME, REF, ALT) = exp[(chr, pos)]

    if ER == 0:
        skipped += 1
        continue
    else:
        write10(chr, pos, NAME, REF, ALT, ER, EA, output10)

print('Skipped {} homozigous SNPs'.format(skipped))
