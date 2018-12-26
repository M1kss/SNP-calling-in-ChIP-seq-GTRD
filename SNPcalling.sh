#!/bin/bash

BAMNAME=$1
CTRLNAME=$2
BAMSPATH=$3
REFERENCE=$4
VCF=$5
FA=$6
FD=$7
PEAKS=$8
OUT=$9


bash pre-process.sh $BAMNAME \
	$BAMSPATH \
	$PEAKS \
	$OUT \
	$REFERENCE \
	$VCF \
	$FA \
	$FD
	

wait

bash pre-process-all.sh $CTRLNAME \
	$BAMSPATH \
	$PEAKS \
	$OUT \
	$REFERENCE \
	$VCF \
	$FA \
	$FD

wait

bash make_tables.sh $BAMNAME $CTRLNAME \
	"$OUT/$BAMNAME.vcf" \
	"$OUT/$1ctrl.vcf" \
	$OUT \
	$REFERENCE \
	$FA

exit 0
