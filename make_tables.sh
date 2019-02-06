#!/bin/bash
source ./Config.cfg
FA=$6
EXPNAME=$1
CTRLNAME=$2
VCF=$3
VCFctrl=$4
OUT=$5

$python3 make_table_single.py $VCF $VCFctrl "$OUT/${EXPNAME}_table_11.txt" "$OUT/${EXPNAME}_table_01.txt" "$OUT/${EXPNAME}_table_10.txt"

if [ $? != 0 ]; then
    echo "Failed to make table from vcf"
    exit 1
fi

cat "$OUT/${EXPNAME}_table_01.txt" "$OUT/${EXPNAME}_table_10.txt" "$OUT/${EXPNAME}_table_11.txt" | bedtools sort -i > "$OUT/${EXPNAME}_table_pre.txt"

if [ $? != 0 ]; then
    echo "Failed to merge tables"
    exit 1
fi

$python3 filter_table.py "$OUT/${EXPNAME}_table_pre.txt" "$OUT/${EXPNAME}_table.txt"

if [ $? != 0 ]; then
    echo "Failed to filter homozigous SNPs"
    exit 1
fi

rm "$OUT/${EXPNAME}_table_pre.txt"
rm "$OUT/${EXPNAME}_table_10.txt"
rm "$OUT/${EXPNAME}_table_11.txt"
rm "$OUT/${EXPNAME}_table_01.txt"

exit 0
