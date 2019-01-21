import sys
import pandas as pd

#def inside(line, table):
#	for el in table:
#		B = el.split()
#		if B[0] != "#CHROM":
#			if "chr" + B[0] == line[0]:
#				if ((int(line[1])>B[1]) and (int(line[1])<B[2])):
#					return True
#	return False

#def insidegem(line, table):
#	for el in table:
#		B = el.split()
#		if B[0] != "#CHROM":
#			if "chr" + B[0] == line[0]:
#				if (int(line[1])>int(B[1])-150) and (int(line[1])<int(B[1])+150):
#					return True
#	return False

if __name__ == "__main__":
	output = open(sys.argv[10],"w")
	
	withmacs = sys.argv[6]
	withsissrs = sys.argv[7]
	withcpics = sys.argv[8]
	withgem = sys.argv[9]

	def Write(line, num, output):
		output.write('\t'.join(line) + '\t' + num + '\n')
	
	def less(A, B):
		if A[0] < B[0]:
			return True
		elif A[0] == B[0]:
			return A[1] < B[1]
		else:
			return False
	
	def write_peak(in_line, peak_line, output, gem=False):
		chr = in_line[0]
		chr_p = "chr" + peak_line[0]
		pos = int(in_line[1])
		start = int(peak_line[1])
		end = int(peak_line[2])
		
		if gem:
			start = start - 150
			end = end + 150
		
		if less((chr, pos), (chr_p, end)):
			if not less((chr, pos), (chr_p, start)):
				Write(in_line, '1', output)
			else:
				Write(in_line, '0', output)
			return True
		else:
			return False
	
	def add_caller(caller, output, gem=False):
		input = open(sys.argv[1], "r")
		
		in_line = input.readline().split()
		
		peak_line = caller.readline()
		while peak_line[0] == "#":
			peak_line = caller.readline()
		peak_line = peak_line.split()
		
		while in_line and peak_line:
			if not write_peak(in_line, peak_line, output, gem):
				peak_line = caller.readline().split()
			else:
				in_line = input.readline().split()
		while write_peak(in_line, peak_line, output, gem):
			in_line = input.readline().split()
		while in_line:
			Write(in_line, '0', output)
	
	def add_zeros(output):
		for line in output:
			output.write(line[:-1] + '\t' + '0' + '\n')
	
	if withmacs:
		macs = open(sys.argv[2], "r")
		add_caller(macs, output)
	else:
		add_zeros(output)

	if withsissrs:
		sissrs = open(sys.argv[3], "r")
		add_caller(sissrs, output)
	else:
		add_zeros(output)
	
	if withcpics:
		cpics = open(sys.argv[4], "r")
		add_caller(cpics, output)
	else:
		add_zeros(output)
	
	if withgem:
		gem = open(sys.argv[5], "r")
		add_caller(gem, output, gem=True)
	else:
		add_zeros(output)
