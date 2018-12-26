USAGE MESSAGE:
	bash SNPcalling.sh \

		BAM_name (without .bam)\
		Control_bam_name (without .bam) \
		Path_to_bams \
		Path_to_ref_files \
		DB_SNP.vcf \
		Ref_genome.fasta \
		Ref_dictionary.dict \
		ChipSeq_peaks.bed \
		Path_to_save_result


USAGE EXAMPLE:
	bash SNPcalling.sh \
		ALIGNSxxxxxx \
		ALIGNSxxxxxx \
		/home/sashok/Documents/ASB/sorted \
		/home/sashok/Documents/ASB/Reference \
		common_all_20180418.vcf \
		hg38-norm.fasta \
		hg38-norm.dict \
		/home/sashok/Documents/ASB/peaks/PEAKSxxxxxx.bed \
		/home/sashok/Documents/ASB/ALIGNSxxxxxx
