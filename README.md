#PEAKCALLING USAGE EXAMPLE:

	bash PEAKcalling.sh \
		-macs /path/to/peaks/macs/PEAKS000000.interval \
		-gem /path/to/peaks/gem/PEAKS000000.interval \
		-sissrs /path/to/peaks/sissrs/PEAKS000000.interval \
		-cpics /path/to/peaks/cpics/PEAKS000000.interval \
		-Out /output_path/PEAKS000000.bed
		
Создаст файл /output_path_to_peaks/PEAKS000000.bed
требуются данные всех 4 коллеров


#CREATE_REFERENCE USAGE EXAMPLE:

    bash create_reference.sh \
        -RefFolder /reference/directory
        -RefGenome /path/to/reference/genome.fasta
        
Создаст normalized референсный геном, индекс и dict в папке /reference/directory

#SNPCALLING USAGE EXAMPLE:

	bash SNPcalling.sh \
		-Exp /path/to/experiment/alignment/sorted/ALIGNS000000.bam  \
		-Ctrl /path/to/control/alignment/sorted/ALIGNS000001.bam \
		-VCF /path/to/dbsnp-vcf/common_all_20180418.vcf \
		-Ref /reference/directory \
		-Peaks /output_path_to_peaks/PEAKS000000.bed \
		-Out /output/folder/name/for/ALIGNS000000_SNPs \
		-WG (optional, whole-genome SNP-calling in ctrl)
		
Создаст сводную таблицу ALIGNS000000.table и несколько vcf файлов с дополнительной информацией
