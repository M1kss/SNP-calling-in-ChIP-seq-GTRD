import sys
from scipy import stats
import math

def est_p(N, X, P_m=0.5, max_dup=10):
	D = N - 2*X
	p = 0
	Lmin = float('inf')
	x_t = 0
	y_t = 1
	for x in range(1, max_dup//2 + 2):
		for y in range(x, max_dup + 3 - x):
			L = -1*(X*math.log(x/(x+y)) + (N-X)*math.log(y/(x+y)) + math.log(1 + (y/x)**(-D)) - math.log((x+y)//2) + (x+y-2)*math.log(P_m))
			#print('{0} {1}:{2}'.format(L,x,y))
			if L < Lmin and x+y <= max_dup+2:
				Lmin = L
				p = x/(x+y)
				x_t = x
				y_t = y
	p = str(x_t)+':'+str(y_t)
	return p


table = open(sys.argv[1], 'r')
ape = open(sys.argv[2], 'r')
out = open(sys.argv[3], 'w')

ape.readline()
out.write('#header\n')

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
		pb = stats.binom_test((EA,ER), p=0.5)
		if EA < ER:
			sign = -1
		else:
			sign = 1
		pb = sign*round(-1*math.log10(pb), 3)
		
		X = min(ER, EA)
		N = ER + EA
		p_exp = est_p(N, X)

		if int(table_line[14]):
			CR = int(table_line[11])
			CA = int(table_line[12])
			
			X = min(CR, CA)
			N = CR + CA
			p_ctrl = est_p(N, X)
			
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
			p_ctrl = est_p(N, X)
		else:
			p = '.'
	
	fc = float(ape_line[-1])
	fc = round(math.log10(fc), 3)
	
	p2 = round(float(ape_line[-2]), 50)
	p1 = round(float(ape_line[-3]), 50)
	
	out.write('\t'.join(table_line)+'\t'+'\t'.join(map(str, [pb, fisher_p, p1, p2, fc]))+'\t'+'\t'.join([p_exp, p_ctrl])+'\n')
	
	ape_line = ape.readline()
	table_line = table.readline()
	
