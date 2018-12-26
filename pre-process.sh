#!/bin/bash



REFERENCE=$5
VCF="$REFERENCE/$6"
FA="$REFERENCE/$7"
FD="$REFERENCE/$8"
BAMNAME=$1
BAMPATH=$2
BED=$3
OUT=$4

source ./Config.cfg


java $MaxMemory -jar $PICARD \
	SortSam \
	SO=coordinate \
	I="$BAMPATH/$BAMNAME.bam" \
	O="$OUT/$1_sorted.bam"

java $MaxMemory -jar $PICARD \
	AddOrReplaceReadGroups \
	I="$OUT/$1_sorted.bam" \
	O="$OUT/$1_formated.bam" \
	RGID=1 \
	RGLB=lib1 \
	RGPL=illumina \
	RGPU=unit1 \
	RGSM=20

java $MaxMemory -jar $PICARD \
	MarkDuplicates \
	I="$OUT/$1_formated.bam" \
	O="$OUT/$1_ready.bam" \
	REMOVE_DUPLICATES=true \
	M="$OUT/$1_metrics.txt"

samtools index "$OUT/$1_ready.bam"

samtools view -b "$OUT/$1_ready.bam" \
	chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 \
	chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY > "$OUT/$1_chop.bam"

java $MaxMemory -jar $GATK \
	BaseRecalibrator \
	-R $FA \
	-I "$OUT/$1_chop.bam" \
	-known-sites $VCF \
	-O "$OUT/$1.table"

java $MaxMemory -jar $GATK \
	ApplyBQSR \
	-R $FA \
	-I "$OUT/$1_chop.bam" \
	--bqsr-recal-file "$OUT/$1.table" \
	-O "$OUT/$1_final.bam"

java $MaxMemory -jar $PICARD \
	BedToIntervalList \
	I=$BED \
	O="$OUT/$1_Peaks.interval_list" \
	SD=$FD

java $MaxMemory -jar $GATK \
	HaplotypeCaller \
	-R $FA \
	-I "$OUT/$1_final.bam" \
	--dbsnp $VCF \
	-L "$OUT/$1_Peaks.interval_list" \
	-O "$OUT/$1.vcf"


rm "$OUT/$1_sorted.bam"
rm "$OUT/$1_formated.bam"
rm "$OUT/$1_ready.bam"
rm "$OUT/$1_metrics.txt"
rm "$OUT/$1_chop.bam"
rm "$OUT/$1.table"
rm "$OUT/$1_Peaks.interval_list"
rm "$OUT/$1_ready.bam.bai"

exit 0
