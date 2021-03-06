
import sys
import gzip

def write01(chr, pos, NAME, REF, ALT, CR, CA, QC, GQC, output01):
	CR = str(CR)
	CA = str(CA)
	output01.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + '0' + '\t' + QC + '\t' + '0' + '\t' + GQC + '\t' + '.' + '\t' + '.' + '\t' + CR + '\t' + CA + '\t' + '0' + '\t' + '1' + '\n')

def write10(chr, pos, NAME, REF, ALT, ER, EA, QE, GQE, output10):
	ER = str(ER)
	EA = str(EA)
	output10.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + QE + '\t' + '0' + '\t' + GQE + '\t' + '0' + '\t' + ER + '\t' + EA + '\t' + '.' + '\t' + '.' + '\t' + '1' + '\t' + '0' + '\n')

def write11(chr, pos, NAME, REF, ALT, ER, EA, CR, CA, QE, QC, GQE, GQC, output11):
	CR = str(CR)
	CA = str(CA)
	ER = str(ER)
	EA = str(EA)
	output11.write(chr + '\t' + pos + '\t' + NAME + '\t' + REF + '\t' + ALT + '\t' + QE + '\t' + QC + '\t' + GQE + '\t' + GQC + '\t' + ER + '\t' + EA + '\t' + CR + '\t' + CA + '\t' + '1' + '\t' + '1' + '\n')

vcf = gzip.open(sys.argv[1], 'r')
vcfctrl = gzip.open(sys.argv[2], 'r')
output11 = open(sys.argv[3],'w')
output01 = open(sys.argv[4],'w')
output10 = open(sys.argv[5],'w')
	
exp = dict()
ctrl = dict()

Nucleotides = {'A','T','G','C'}

def read_from_file(vcf, out):
	for line in vcf:
		line = line.decode('UTF-8')
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
read_from_file(vcfctrl, ctrl)

skipped = 0
skip_dif = 0

for (chr, pos) in exp.keys():
	(ER, EA, NAME, REF, ALT, QE, GQE, GTE) = exp[(chr, pos)]
	
	Cpair = ctrl.pop((chr, pos), None)	
	if Cpair:
		CR = Cpair[0]
		CA = Cpair[1]
		QC = Cpair[5]
		GQC = Cpair[6]
		GTC = Cpair[7]
		if Cpair[2] != NAME or Cpair[4] != ALT:
			skip_dif += 1
			continue
		if Cpair[3] != REF:
			print('Reference genomes for exp and ctrl don\'t match!')
		if GTE != '0/1' and GTC != '0/1':
			skipped += 1
			continue
		write11(chr, pos, NAME, REF, ALT, ER, EA, CR, CA, QE, QC, GQE, GQC, output11)
	else:
		if GTE != '0/1':
			skipped += 1
			continue
		write10(chr, pos, NAME, REF, ALT, ER, EA, QE, GQE, output10)

for (chr, pos) in ctrl.keys():
	(CR, CA, NAME, REF, ALT, QC, GQC, GTC) = ctrl[(chr, pos)]
	if GTC != '0/1':
		skipped += 1
		continue
	write01(chr, pos, NAME, REF, ALT, CR, CA, QC, GQC, output01)

print('Skipped {0} homozigous SNPs and {1} mismatched SNPS'.format(skipped, skip_dif))
