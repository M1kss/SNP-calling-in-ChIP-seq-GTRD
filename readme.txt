PEAKCALLING USAGE MESSAGE:
	bash PEAKcalling.sh \
		-macs name.intervals \
		-gem name.intervals \
		-sissrs name.intervals \
		-cpics name.intervals \
		-Out outputdir
#создает в outputdir файл name.bed
#предполагается что названия эксперементов одинаковы для любого caller-a (macs sissrs и т.д)
#требуются данные всех 4 коллеров

PEAKCALLING USAGE EXAMPLE:
	bash PEAKcalling.sh \
		-macs /home/sashok/Documents/ASB/peaks/macs/PEAKSxxxxxx.interval \
		-gem /home/sashok/Documents/ASB/peaks/gem/PEAKSxxxxxx.interval \
		-sissrs /home/sashok/Documents/ASB/peaks/sissrs/PEAKSxxxxxx.interval \
		-cpics /home/sashok/Documents/ASB/peaks/cpics/PEAKSxxxxxx.interval \
		-Out /home/sashok/Documents/ASB/peaks
#создаст файл /home/sashok/Documents/ASB/peaks/PEAKSxxxxxx.bed

SNPCALLING USAGE MESSAGE:
	bash SNPcalling.sh \
		-Exp Exp.bam \
		-Ctrl Ctrl.bam \
		-VCF DB_SNP.vcf \
		-Ref Ref_genome.fasta \
		-Peaks ChipSeq_peaks.bed \
		-Out Path_to_save_result \
		-WG (optional)

SNPCALLING USAGE EXAMPLE:
	bash SNPcalling.sh \
		-Exp /home/sashok/Documents/ASB/sorted/ALIGNSxxxxxx.bam  \
		-Ctrl /home/sashok/Documents/ASB/sorted/ALIGNSxxxxxxctrl.bam \
		-VCF /home/sashok/Documents/ASB/Reference/common_all_20180418.vcf \
		-Ref /home/sashok/Documents/ASB/Reference \
		-Peaks /home/sashok/Documents/ASB/peaks/PEAKSxxxxxx.bed \
		-Out /home/sashok/Documents/ASB/ALIGNSxxxxxx \
		-WG (optional whole-genom SNP-calling in ctrl)
