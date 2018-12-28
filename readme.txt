USAGE MESSAGE:
	bash SNPcalling.sh \
		-Exp Exp.bam \
		-Ctrl Ctrl.bam \
		-VCF DB_SNP.vcf \
		-Ref Ref_genome.fasta \
		-Peaks ChipSeq_peaks.bed \
		-Out Path_to_save_result
		-WG (optional)

USAGE EXAMPLE:
	bash SNPcalling.sh \
		-Exp /home/sashok/Documents/ASB/sorted/ALIGNSxxxxxx.bam  \
		-Ctrl /home/sashok/Documents/ASB/sorted/ALIGNSxxxxxxctrl.bam 
		-VCF /home/sashok/Documents/ASB/Reference/common_all_20180418.vcf \
		-Ref /home/sashok/Documents/ASB/Reference/hg38-norm.fasta 
		-Peaks /home/sashok/Documents/ASB/peaks/PEAKSxxxxxx.bed \
		-Out /home/sashok/Documents/ASB/ALIGNSxxxxxx \
		-WG (optional whole-genom SNP-calling in ctrl)
