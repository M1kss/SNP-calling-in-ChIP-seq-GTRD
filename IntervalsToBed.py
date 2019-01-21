
import sys

if __name__ == "__main__":
	filepath = sys.argv[1]
	f = open(filepath, 'r')
	caller = sys.argv[2]
	name = sys.argv[3]
	Data = ''
	outfilepath = sys.argv[4]
	if outfilepath[-1] != '/':
		outfilepath += '/'
	out = open(outfilepath + name + '.' + caller + '.bed','w')
	if caller == 'gem':
		for line in f:
			B = line.split()
			if B[0] == '#CHROM':
				start = B[1]
				end = B[2]
			else:
				start = int(B[1]) - 150
				end = int(B[2]) + 150
			Data += B[0] + '	' + str(start) + '	' + str(end) + '\n'
		out.write(Data)
	else:
		for line in f:
			B = line.split()
			Data += B[0] + '	' + B[1] + '	' + B[2] + '\n'
		out.write(Data)
	f.close()
	out.close()
