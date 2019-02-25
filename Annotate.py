import sys

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
	
def add_caller(caller, infile, outfile, gem=False):
	input = open(infile, "r")
	output = open(outfile, "w")
		
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
	while in_line:
		Write(in_line, '0', output)
		in_line = input.readline().split()
	input.close()
	output.close()
	
def add_zeros(infile, outfile):
	input = open(infile, "r")
	output = open(outfile, "w")
	for line in input:
		output.write(line[:-1] + '\t' + '0' + '\n')
	output.close()
	output.close()

if __name__ == "__main__":
	o = sys.argv[10]
	i = sys.argv[1]
	
	withmacs = sys.argv[6]
	withsissrs = sys.argv[7]
	withcpics = sys.argv[8]
	withgem = sys.argv[9]
	
	if withmacs == "true":
		macs = open(sys.argv[2], "r")
		add_caller(macs, i, o+".m.txt")
	else:
		add_zeros(i, o+".m.txt")

	if withsissrs ==  "true":
		sissrs = open(sys.argv[3], "r")
		add_caller(sissrs, o+".m.txt", o+".s.txt")
	else:
		add_zeros(o+".m.txt", o+".s.txt")
	
	if withcpics == "true":
		cpics = open(sys.argv[4], "r")
		add_caller(cpics, o+".s.txt", o+".c.txt")
	else:
		add_zeros(o+".s.txt", o+".c.txt")
	
	if withgem == "true":
		gem = open(sys.argv[5], "r")
		add_caller(gem, o+".c.txt", o, gem=True)
	else:
		add_zeros(o+".c.txt", o)
