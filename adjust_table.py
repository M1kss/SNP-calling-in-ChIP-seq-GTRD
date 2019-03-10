import sys
from scipy import stats
import math

def est_p(N, X, P_m, max_n):
	D = N - 2*X
	p = 0
	Lmin = float('inf')
	x_t = 0
	y_t = 1
	x = 1
	for y in range(1, max_n+1):
		L = -1*(X*math.log(x/(x+y)) + (N-X)*math.log(y/(x+y)) + math.log(1 + (y/x)**(-D)) + (x+y-2)*math.log(P_m))
		if L < Lmin:
			Lmin = L
			p = x/(x+y)
			x_t = x
			y_t = y
	p = x_t/(x_t + y_t)
	return p

def est_p_list(N, X, P_m, max_n):
	p = 0
	Lmin = float('inf')
	x_t = 0
	y_t = 1
	x = 1
	for y in range(1, max_n+1):
		L = 0
		for i in range(len(N)):
			L += -1*(X[i]*math.log(x/(x+y)) + (N[i]-X[i])*math.log(y/(x+y)) + math.log(1 + (y/x)**(2*X[i]-N[i]))+(x+y-2)*math.log(P_m))
		if L < Lmin:
			Lmin = L
			p = x/(x+y)
			x_t = x
			y_t = y
	p = x_t/(x_t + y_t)
	return p

table = open(sys.argv[1], 'r')
ape = open(sys.argv[2], 'r')
out = open(sys.argv[3], 'w')


out.write('#header\n')

NE = dict()
XE = dict()
NC = dict()
XC = dict()

P_m = 0.99
n_max = 5

chr_l=[248956422, 242193529, 198295559, 190214555, 181538259, 170805979, 159345973, 145138636, 138394717, 133797422, 135086622, 133275309, 114364328, 107043718, 101991189, 90338345, 83257441, 80373285, 58617616, 64444167, 46709983, 50818468, 156040895, 57227415]

chrs = []
chr_lengths = dict()
for i in range(1,23):
	chrs.append('chr'+str(i))
	chr_lengths['chr'+str(i)] = chr_l[i-1]
chrs.append('chrX')
chrs.append('chrY')
chr_lengths['chrX'] = chr_l[-2]
chr_lengths['chrY'] = chr_l[-1]

for chr in chrs:
	NE[chr] = []
	XE[chr] = []
	NC[chr] = []
	XC[chr] = []

LS = []
for i in range(1, n_max):
	LS.append(dict())
	for chr in chrs:
		LS[i-1][chr] = dict()



ape.readline()
ape_line = ape.readline()
table_line = table.readline()

while ape_line and table_line:
	ape_line = ape_line.split()
	table_line = table_line.split()
	
	ape_name = ape_line[0].split('_')
	ape_chr = ape_name[0]
	ape_pos = ape_name[1]
	
	chr = table_line[0]
	pos = table_line[1]
	
	assert ape_chr == chr
	assert ape_pos == pos
	
	p2 = round(float(ape_line[-2]), 50)
	p1 = round(float(ape_line[-3]), 50)

	if int(table_line[13]) and table_line[2] != '.' and min(p1, p2) >= 0.005:
		ER = int(table_line[9])
		EA = int(table_line[10])
		X = min(ER, EA)
		N = ER + EA
		NE[chr].append(N)
		XE[chr].append(X)
		for i in range(1, n_max):
			LS[i-1][chr][pos] = -1*(X*math.log(1/(1+i)) + (N-X)*math.log(i/(1+i)) + math.log(1 + (i)**(2*X-N)) + (i-1)*math.log(P_m))
	
	ape_line = ape.readline()
	table_line = table.readline()

ape.seek(0)
table.seek(0)

p_chr = dict()
for chr in chrs:
	p_chr[chr] = est_p_list(NE[chr], XE[chr], P_m, n_max)


ape.readline()
ape_line = ape.readline()
table_line = table.readline()	

while ape_line and table_line:
	ape_line = ape_line.split()
	table_line = table_line.split()
	
	ape_name = ape_line[0].split('_')
	ape_chr = ape_name[0]
	ape_pos = ape_name[1]
	
	chr = table_line[0]
	pos = table_line[1]
	
	assert ape_chr == chr
	assert ape_pos == pos
	
	if int(table_line[13]):
		ER = int(table_line[9])
		EA = int(table_line[10])
		
		i_f = 0
		Lmin = float('inf')
		positions = []

		for position in LS[0][chr].keys():
			if abs(int(pos) - int(position)) <= 5000000:
				positions.append(position)

		for i in range(1, n_max):
			L = 0
			countp = 0
			for position in positions:
				countp += 1
				L += LS[i-1][chr][position]
			if L < Lmin:
				Lmin = L
				i_f = i



		if countp < 30:
			p_e = p_chr[chr]
		else:
			p_e = 1/(1+i_f)
		
		print(chr, pos, p_e)		
		
		X = min(ER, EA)
		N = ER + EA

		pb = min(max(stats.binom_test(X, n=N, p=p_e), stats.binom_test(X, n=N, p=p_chr[chr])), 1)
		if EA < ER:
			sign = -1
		else:
			sign = 1
		pb = sign*round(-1*math.log10(pb), 3)
		
		X = min(ER, EA)
		N = ER + EA
		p_exp = '1:'+str(i_f)

		if int(table_line[14]):
			CR = int(table_line[11])
			CA = int(table_line[12])
			
			X = min(CR, CA)
			N = CR + CA
			p_ctrl = '.'
			
			if table_line[2] != '.':
				NC[chr].append(N)
				XC[chr].append(X)
			
			fisher_p = stats.fisher_exact([[EA, ER],[CA, CR]])[1]
			fisher_p = sign * round(-1 * math.log10(fisher_p), 3)
		else:
			fisher_p = '.'
			p_ctrl = '.'
	else:
		pb = '.'
		fisher_p = '.'
		p_exp = '.'

		if int(table_line[14]):
			CR = int(table_line[11])
			CA = int(table_line[12])

			X = min(CR, CA)
			N = CR + CA
			p_ctrl = '.'

		else:
			p = '.'

	fc = float(ape_line[-1])
	fc = round(math.log10(fc), 3)
	
	p2 = round(float(ape_line[-2]), 50)
	p1 = round(float(ape_line[-3]), 50)
	
	out.write('\t'.join(table_line)+'\t'+'\t'.join(map(str, [pb, fisher_p, p1, p2, fc]))+'\t'+'\t'.join([p_exp, p_ctrl])+'\n')
	
	ape_line = ape.readline()
	table_line = table.readline()
