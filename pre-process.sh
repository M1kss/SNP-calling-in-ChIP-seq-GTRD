#!/bin/bash


VCF=$4
FA=$5
FD=$6
BAMNAME=$1
BAMPATH=$2
OUT=$3
WG=$7

source ./Config.cfg

if [ ! -f $BAMPATH$BAMNAME.bam.bai ]; then
	echo "Index file for $BAMNAME not found, indexing.."
	samtools index "$BAMPATH/$BAMNAME.bam"
	if [ $? != 0 ]; then
        echo "Failed to index bam"
        exit 1
    fi
fi
	
echo "Cutting bam.."
samtools view -b "$BAMPATH/$BAMNAME.bam" \
	chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 \
	chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY > "$OUT/${BAMNAME}_chop.bam"

if [ $? != 0 ]; then
    echo "Failed to cut bam"
    exit 1
fi

$Java $JavaParameters -jar $PICARD \
	AddOrReplaceReadGroups \
	I="$OUT/${BAMNAME}_chop.bam" \
	O="$OUT/${BAMNAME}_formated.bam" \
	RGID=1 \
	RGLB=lib1 \
	RGPL=seq1 \
	RGPU=unit1 \
	RGSM=20

if [ $? != 0 ]; then
    echo "Failed to picard.AddOrReplaceReadGroups"
    exit 1
fi

$Java $JavaParameters -jar $PICARD \
	MarkDuplicates \
	I="$OUT/${BAMNAME}_formated.bam" \
	O="$OUT/${BAMNAME}_ready.bam" \
	REMOVE_DUPLICATES=true \
	M="$OUT/${BAMNAME}_metrics.txt"

if [ $? != 0 ]; then
    echo "Failed to picard.MarkDplicates"
    exit 1
fi

$Java $JavaParameters -jar $GATK \
	BaseRecalibrator \
	-R $FA \
	-I "$OUT/${BAMNAME}_ready.bam" \
	-known-sites $VCF \
	-O "$OUT/${BAMNAME}.table"

if [ $? != 0 ]; then
    echo "Failed to make base recalibration"
    exit 1
fi

$Java $JavaParameters -jar $GATK \
	ApplyBQSR \
	-R $FA \
	-I "$OUT/${BAMNAME}_ready.bam" \
	--bqsr-recal-file "$OUT/${BAMNAME}.table" \
	-O "$OUT/${BAMNAME}_final.bam"

if [ $? != 0 ]; then
    echo "Failed to apply BSQR"
    exit 1
fi

if $WG; then
		$Java $JavaParameters -jar $GATK \
		HaplotypeCaller \
		-R $FA \
		-I "$OUT/${BAMNAME}_final.bam" \
		--dbsnp $VCF \
		-O "$OUT/${BAMNAME}.vcf" 
	else
		echo "cant be done"
fi

if [ $? != 0 ]; then
    echo "Failed gatk.HaplotypeCaller"
    exit 1
fi

rm "$OUT/${BAMNAME}_metrics.txt"
rm "$OUT/${BAMNAME}.table"


if [ -f $OUT/${BAMNAME}_ready.bam.bai ]; then
    rm "$OUT/${BAMNAME}_ready.bam.bai"
fi

exit 0
