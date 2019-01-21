# USAGE EXAMPLES:

## CREATE_REFERENCE

    bash create_reference.sh \
        -RefFolder /reference/directory \
        -RefGenome /path/to/reference/genome.fasta    #(hg38)
        
Создаст normalized референсный геном, индекс и dict в папке /reference/directory/

## SNPCALLING

	bash SNPcalling.sh \
		-Exp /path/to/experiment/alignment/sorted/ALIGNS000000.bam  \
		-Ctrl /path/to/control/alignment/sorted/ALIGNS000001.bam \ #(optional)
		-VCF /path/to/dbsnp-vcf/common_all_20180418.vcf \
		-Ref /reference/directory \
		-macs /path/to/peaks/macs/PEAKS000000.interval \ #(optional, at least one peak caller data must be presented)
		-gem /path/to/peaks/gem/PEAKS000000.interval \ #(optional)
		-sissrs /path/to/peaks/sissrs/PEAKS000000.interval \ #(optional)
		-cpics /path/to/peaks/cpics/PEAKS000000.interval \ #(optional)
		-Out /output/folder/name/for/ALIGNS000000_SNPs \     #(it must exist!!)
		-WGC (optional, whole-genome SNP-calling in ctrl)  \    #(~2hrs for one dataset)
		-WGE (optional, whole-genome SNP-calling in exp)  #(~2hrs for one dataset)
		
Создаст сводную таблицу ALIGNS000000_table_annotated.txt и несколько vcf файлов с дополнительной информацией в директории /output/folder/name/for/ALIGNS000000_SNPs/ (которую нужно предварительно создать, если её нет, название не имеет значения)

# INSTALLATION INSTRUCTIONS:

1. python3
	python-numpy
	python-matplotlib
2. python2
3. samtools
4. bedtools
5. bcftools
6. java 8 (не выше и не ниже!)
7. picard (https://github.com/broadinstitute/picard/releases/dow..)
8. GATK (https://github.com/broadinstitute/gatk/releases/downl..)
9. В файле Config.cfg указать путь куда скачан picard.jar и распакован gatk-package-4.0.x.0-local.jar, в JavaParameters = "" указать через пробел параметры и опции запуска java (по умолчанию оставить -Xmx12G)

### Для всех датасетов с одним и тем же референсным геномом:

10. Запустить create_reference.sh по образцу выше, чтобы в заранее созданной директории -RefFolder создать необходимые файлы.

### Для каждого датасета:

11. Запустить SNPcalling.sh с параметрами:

	11.1 При наличии контрольного эксперимента

		bash SNPcalling.sh \
		    	-WGC \
			-WGE \
			-Exp /path/to/experiment/alignment/sorted/ALIGNS000000.bam  \    #(путь к выравниванию эксперимента)
			-Ctrl /path/to/control/alignment/sorted/ALIGNS000001.bam \    #(путь к выравниванию контрольного эксперимента)
			-VCF /path/to/dbsnp-vcf/common_all_20180418.vcf \    #(путь к последнему vcf dbsnp, например, ftp://ftp.ncbi.nih.gov/snp/pre_build152/organisms/human_9606_b151_GRCh38p7/VCF/GATK/00-common_all.vcf.gz)
			-Ref /reference/directory \    #(из пункта 10)
			-macs /path/to/peaks/macs/PEAKS000000.interval \
			-gem /path/to/peaks/gem/PEAKS000000.interval \
			-sissrs /path/to/peaks/sissrs/PEAKS000000.interval \
			-cpics /path/to/peaks/cpics/PEAKS000000.interval \
			-Out /output/folder/name/for/ALIGNS000000_SNPs \     #(it must exist!! Директория для записи результатов)
	
	11.2 В отсутствии контрольного эксперимента

		bash SNPcalling.sh \
			-WGE \
			-Exp /path/to/experiment/alignment/sorted/ALIGNS000000.bam  \    #(путь к выравниванию эксперимента)
			-VCF /path/to/dbsnp-vcf/common_all_20180418.vcf \    #(путь к последнему vcf dbsnp, например, ftp://ftp.ncbi.nih.gov/snp/pre_build152/organisms/human_9606_b151_GRCh38p7/VCF/GATK/00-common_all.vcf.gz)
			-Ref /reference/directory \    #(из пункта 10)
			-macs /path/to/peaks/macs/PEAKS000000.interval \
			-gem /path/to/peaks/gem/PEAKS000000.interval \
			-sissrs /path/to/peaks/sissrs/PEAKS000000.interval \
			-cpics /path/to/peaks/cpics/PEAKS000000.interval \
			-Out /output/folder/name/for/ALIGNS000000_SNPs \     #(it must exist!! Директория для записи результатов)

# Output format:
Основной файл: ALIGNS039504_table.txt, формат следующий:

CHR POS ID REF ALT QUAL_EXP QUAL_CTRL EXP_REF EXP_ALT CTRL_REF CTRL_ALT IN_EXP IN_CTRL IN_MACS IN_SISSRS IN_CPICS IN_GEM

Первые 5 полей аналогичны vcf

QUAL_EXP, QUAL_CTRL - GATK QUAL

EXP_REF, CTRL_ALT - число ридов, выровненных в опыте на реф/альт аллель

CTRL_REF, CTRL_ALT - то же, для контроля

IN_EXP, IN_ALT - 0 или 1 - отсутствие или присутствие соответственно в опыте или контроле

IN_MACS, IN_SISSRS, IN_CPICS, IN_GEM - 0 или 1 - отсутствие или присутствие в пиках соответствующих коллеров

Дополнительные файлы: original VCF-s and indexing
