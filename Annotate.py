import sys
import pandas as pd

def inside(line, table):
	for el in table:
		B = el.split()
		if B[0] != "#CHROM":
			if "chr" + B[0] == line[0]:
				if ((int(line[1])>B[1]) and (int(line[1])<B[2])):
					return True
	return False

def insidegem(line, table):
	for el in table:
		B = el.split()
		if B[0] != "#CHROM":
			if "chr" + B[0] == line[0]:
				if (int(line[1])>int(B[1])-150) and (int(line[1])<int(B[1])+150):
					return True
	return False

if __name__ == "__main__":
	input = open(sys.argv[1],"r")
	output = open(sys.argv[10],"w")
	macs = sys.argv[2]
	sissrs = sys.argv[3]
	cpics = sys.argv[4]
	gem = sys.argv[5]
	
	withmacs = sys.argv[6]
	withsissrs = sys.argv[7]
	withcpics = sys.argv[8]
	withgem = sys.argv[9]

	for line in input:
		if withmacs:
			if inside(line,macs):
				M ="1"
			else:
				M = "0"
		else:
			M = "0"
		if withsissrs:
			if inside(line,sissrs):
				S = "1"
			else:
				S = "0"
		else:
			S = "0"
		if withcpics:
			if inside(line,cpics):
				C = "1"
			else:
				C = "0"
		else:
			C = "0"
		if withgem:
			if insidegem(line,gem):
				G = "1"
			else:
				G = "0"
		else:
			G = "0"
		
		output.write(line[:-1] + "\t" + M + "\t" + S + "\t" +  C + "\t" + G + "\n")
