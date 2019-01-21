
import sys

def write01(chr, pos, NAME, REF, ALT, CR, CA, QC, output01, bed01):
	CR = str(CR)
	CA = str(CA)
	bed01.write(chr+'\t'+str(int(pos)-1)+'\t'+ pos +'\n')
	output01.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + '0' + '\t' + QC + '\t' + '.' + '\t' + '.' + '\t' + CR + '\t' + CA + '\t' + '0' + '\t' + '1' + '\n')

def write10(chr, pos, NAME, REF, ALT, ER, EA, QE, output10, bed10):
	ER = str(ER)
	EA = str(EA)
	bed10.write(chr+'\t'+str(int(pos)-1)+'\t'+ pos +'\n')
	output10.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + QE + '\t' + '0' + '\t' + ER + '\t' + EA + '\t' + '.' + '\t' + '.' + '\t' + '1' + '\t' + '0' + '\n')

def write11(chr, pos, NAME, REF, ALT, ER, EA, CR, CA, QE, QC, output11):
	CR = str(CR)
	CA = str(CA)
	ER = str(ER)
	EA = str(EA)
	output11.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + QE + '\t' + QC + '\t' + ER + '\t' + EA + '\t' + CR + '\t' + CA + '\t' + '1' + '\t' + '1' + '\n')


vcf = open(sys.argv[1], 'r')
vcfctrl = open(sys.argv[2], 'r')
output11 = open(sys.argv[3],'w')
output10 = open(sys.argv[5],'w')
output01 = open(sys.argv[4],'w')
bed01 = open(sys.argv[6], 'w')
bed10 = open(sys.argv[7], 'w')
	
exp = dict()
ctrl = dict()

Nucleotides = {'A','T','G','C'}

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
				QUAL = line[5]
				out[(line[0], line[1])] = (R, A, NAME, REF, ALT, QUAL)

read_from_file(vcf, exp)
read_from_file(vcfctrl, ctrl)

skipped = 0
skip_dif = 0


for (chr, pos) in exp.keys():
	(ER, EA, NAME, REF, ALT, QE) = exp[(chr, pos)]
	#del exp[(chr, pos)]
	
	Cpair = ctrl.pop((chr, pos), None)	
	if Cpair:
		CR = Cpair[0]
		CA = Cpair[1]
		QC = Cpair[5]
		if Cpair[2] != NAME or Cpair[4] != ALT:
			skip_dif += 1
			continue
		if Cpair[3] != REF:
			print('Reference genomes for exp and ctrl don\'t match!')
		if CR == 0 and ER == 0:
			skipped += 1
			continue
		write11(chr, pos, NAME, REF, ALT, ER, EA, CR, CA, QE, QC, output11)
	else:
		write10(chr, pos, NAME, REF, ALT, ER, EA, QE, output10, bed10)
	
for (chr, pos) in ctrl.keys():
	(CR, CA, NAME, REF, ALT, QC) = ctrl[(chr, pos)]
	#del ctrl[(chr, pos)]
	write01(chr, pos, NAME, REF, ALT, CR, CA, QC, output01, bed01)

print('Skipped {0} homozigous SNPs and {1} mismatched SNPS'.format(skipped, skip_dif))
