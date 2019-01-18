# USAGE EXAMPLES:
### PEAKCALLING

	bash PEAKcalling.sh \
		-macs /path/to/peaks/macs/PEAKS000000.interval \
		-gem /path/to/peaks/gem/PEAKS000000.interval \
		-sissrs /path/to/peaks/sissrs/PEAKS000000.interval \
		-cpics /path/to/peaks/cpics/PEAKS000000.interval \
		-Out /output_path_to_peaks/PEAKS000000.bed     #(/output_path_to_peaks/ must exist!!)
		
Создаст файл /output_path_to_peaks/PEAKS000000.bed
требуются данные всех 4 коллеров


### CREATE_REFERENCE

    bash create_reference.sh \
        -RefFolder /reference/directory
        -RefGenome /path/to/reference/genome.fasta    #(hg38)
        
Создаст normalized референсный геном, индекс и dict в папке /reference/directory/

### SNPCALLING

	bash SNPcalling.sh \
		-Exp /path/to/experiment/alignment/sorted/ALIGNS000000.bam  \
		-Ctrl /path/to/control/alignment/sorted/ALIGNS000001.bam \ #(optional)
		-VCF /path/to/dbsnp-vcf/common_all_20180418.vcf \
		-Ref /reference/directory \
		-Peaks /output_path_to_peaks/PEAKS000000.bed \
		-Out /output/folder/name/for/ALIGNS000000_SNPs \     #(it must exist!!)
		-WGC (optional, whole-genome SNP-calling in ctrl)  \    #(~2hrs for one dataset)
		-WGE (optional, whole-genome SNP-calling in exp)  #(~2hrs for one dataset)
		
Создаст сводную таблицу ALIGNS000000.table и несколько vcf файлов с дополнительной информацией в директории /output/folder/name/for/ALIGNS000000_SNPs/ (которую нужно предварительно создать, если её нет, название не имеет значения)

# INSTALLATION INSTRUCTIONS:

1) python3
	python-numpy
	python-matplotlib
2) python2
3) samtools
4) bedtools
5) bcftools
6) java 8 (не выше и не ниже!)
7) picard (https://github.com/broadinstitute/picard/releases/dow..)
8) GATK (https://github.com/broadinstitute/gatk/releases/downl..)
9) В файле Config.cfg указать путь куда скачан picard.jar и распакован gatk-package-4.0.x.0-local.jar, в JavaParameters = "" указать через пробел параметры и опции запуска java.

Для всех датасетов с одним и тем же референсным геномом:

10) Запустить create_reference.sh по образцу выше, чтобы в директории -RefFolder создать необходимые файлы.

Для каждого датасета:

11) Запустить PEAKcalling.sh по образцу выше, чтобы в директории /output_path_to_peaks создать файл PEAKSхххххх.bed пиков с объедиением пиков четырех пикколеров.
12) Запустить SNPcalling.sh с параметрами:

	-Exp /path/to/experiment/alignment/sorted/ALIGNS000000.bam  \    #(путь к выравниванию эксперимента)
	
	-Ctrl /path/to/control/alignment/sorted/ALIGNS000001.bam \    #(путь к выравниванию контрольного эксперимента)
	# если контрольного эксперимента нет запускать с флагом -WGE
	
	-VCF /path/to/dbsnp-vcf/common_all_20180418.vcf \    #(путь к последнему vcf dbsnp,
	#например, ftp://ftp.ncbi.nih.gov/snp/pre_build152/organisms/human_9606_b151_GRCh38p7/VCF/GATK/00-common_all.vcf.gz)
	
	-Ref /reference/directory \    #(из пункта 10)
	
	-Peaks /output_path_to_peaks/PEAKS000000.bed \    #(из пункта 11)
	
	-Out /output/folder/name/for/ALIGNS000000_SNPs \     #(it must exist!! Директория для записи результатов)
