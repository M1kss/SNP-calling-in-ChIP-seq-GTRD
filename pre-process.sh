#!/bin/bash


VCF=$5
FA=$6
FD=$7
BAMNAME=$1
BAMPATH=$2
BED=$3
OUT=$4
WG=$8

source ./Config.cfg

echo "$BAMPATH$BAMNAME.bai"
if [ ! -f $BAMPATH$BAMNAME.bai ]; then
	echo "Index file for $BAMNAME not found, indexing.."
	samtools index "$BAMPATH/$BAMNAME.bam"
fi
	
echo "Cutting bam.."
samtools view -b "$BAMPATH/$BAMNAME.bam" \
	chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 \
	chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY > "$OUT/${BAMNAME}_chop.bam"

java $JavaParameters -jar $PICARD \
	AddOrReplaceReadGroups \
	I="$OUT/${BAMNAME}_chop.bam" \
	O="$OUT/${BAMNAME}_formated.bam" \
	RGID=1 \
	RGLB=lib1 \
	RGPL=illumina \
	RGPU=unit1 \
	RGSM=20

java $JavaParameters -jar $PICARD \
	MarkDuplicates \
	I="$OUT/${BAMNAME}_formated.bam" \
	O="$OUT/${BAMNAME}_ready.bam" \
	REMOVE_DUPLICATES=true \
	M="$OUT/${BAMNAME}_metrics.txt"



java $JavaParameters -jar $GATK \
	BaseRecalibrator \
	-R $FA \
	-I "$OUT/${BAMNAME}_ready.bam" \
	-known-sites $VCF \
	-O "$OUT/${BAMNAME}.table"

java $JavaParameters -jar $GATK \
	ApplyBQSR \
	-R $FA \
	-I "$OUT/${BAMNAME}_ready.bam" \
	--bqsr-recal-file "$OUT/${BAMNAME}.table" \
	-O "$OUT/${BAMNAME}_final.bam"

java $JavaParameters -jar $PICARD \
	BedToIntervalList \
	I=$BED \
	O="$OUT/${BAMNAME}_Peaks.interval_list" \
	SD=$FD

if $WG; then
		java $JavaParameters -jar $GATK \
		HaplotypeCaller \
		-R $FA \
		-I "$OUT/${BAMNAME}_final.bam" \
		--dbsnp $VCF \
		-O "$OUT/${BAMNAME}.vcf" 
	else
		java $JavaParameters -jar $GATK \
		HaplotypeCaller \
		-R $FA \
		-I "$OUT/${BAMNAME}_final.bam" \
		--dbsnp $VCF \
		-O "$OUT/${BAMNAME}.vcf" \
		-L "$OUT/${BAMNAME}_Peaks.interval_list"
fi

rm "$OUT/${BAMNAME}_formated.bam"
rm "$OUT/${BAMNAME}_ready.bam"
rm "$OUT/${BAMNAME}_metrics.txt"
rm "$OUT/${BAMNAME}_chop.bam"
rm "$OUT/${BAMNAME}.table"
rm "$OUT/${BAMNAME}_Peaks.interval_list"
rm "$OUT/${BAMNAME}_ready.bam.bai"

exit 0
