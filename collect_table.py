import sys

table_pre = open(sys.argv[1], 'r')
table = open(sys.argv[2], 'w')


c01 = 0
c11 = 0
c10 = 0
total = 0

for line_r in table_pre:
	line = line_r.split()
	
	total += 1
	table.write(line_r)
	
	if line[11] == line[12]:
		c11 += 1
	elif line[12] == '0':
		c10 += 1
	elif line[11] == '0':
		c01 += 1

print('{0} het SNPs in total. {1} of them present in both, {2} only in EXP, {3} only in CTRL.'.format(total, c11, c10, c01))
