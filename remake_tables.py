import sys

def write01(line01, tableline01, output01):
	if line01[0] == tableline01[0] and line01[1] == tableline01[1]:		
		I16 = line01[7].split(';')[1].split('=')[1].split(',')
		ER = str(int(I16[0]) + int(I16[1]))
		EA = str(int(I16[2]) + int(I16[3]))
		write_line01(tableline01, ER, EA, output01)
		return True
	else:
		write_line01(tableline01, '0', '0', output01)
		return False

def write10(line10, tableline10, output10):
	if line10[0] == tableline10[0] and line10[1] == tableline10[1]:
		I16 = line10[7].split(';')[1].split('=')[1].split(',')
		CR = str(int(I16[0]) + int(I16[1]))
		CA = str(int(I16[2]) + int(I16[3]))
		write_line10(tableline10, CR, CA, output10)
		return True
	else:
		write_line10(tableline10, '0', '0', output10)
		return False

def write_line10(tableline, R, A, output):
	output.write(tableline[0] + '\t' + tableline[1] + '\t' + tableline[2] + '\t' + tableline[3] + '\t' + tableline[4] + '\t' + tableline[5] + '\t' + tableline[6] + '\t' + tableline[7] + '\t' + tableline[8] + '\t' + R + '\t' + A + '\t' + tableline[11] + '\t' + tableline[12] + '\n')

def write_line01(tableline, R, A, output):
	output.write(tableline[0] + '\t' + tableline[1] + '\t' + tableline[2] + '\t' + tableline[3] + '\t' + tableline[4] + '\t' + tableline[5] + '\t' + tableline[6] + '\t' + R + '\t' + A + '\t' + tableline[9] + '\t' + tableline[10] + '\t' + tableline[11] + '\t' + tableline[12] + '\n')

def main():
	pile01 = open(sys.argv[1], 'r')
	pile10 = open(sys.argv[2], 'r')
	input10 = open(sys.argv[4], 'r')
	input01 = open(sys.argv[3], 'r')
	output10 = open(sys.argv[6],'w')
	output01 = open(sys.argv[5],'w')
	
	line01 = pile01.readline()
	while line01[0] == '#':
		line01 = pile01.readline()
	line01 = line01.split()

	line10 = pile10.readline()
	while line10[0] == '#':
		line10 = pile10.readline()
	line10 = line10.split()
	
	tableline01 = input01.readline().split()
	tableline10 = input10.readline().split()

	while tableline01 and line01:
		if write01(line01, tableline01, output01):
			line01 = pile01.readline().split()
		tableline01 = input01.readline().split()
	else:
		while tableline01:
			write_line01(tableline01, '0', '0', output01)
			tableline01 = input01.readline().split()

	while tableline10 and line10:
		if write10(line10, tableline10, output10):
			line10 = pile10.readline().split()
		tableline10 = input10.readline().split()
	else:
		while tableline10:
			write_line10(tableline10, '0', '0', output10)
			tableline10 = input10.readline().split()

main()
		
		
		
