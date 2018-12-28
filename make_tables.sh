#!/bin/bash

FA=$6
EXPNAME=$1
CTRLNAME=$2
VCF=$3
VCFctrl=$4
OUT=$5

python3 make_table_refined.py $VCF $VCFctrl "$OUT/${EXPNAME}_table_11.txt" "$OUT/${EXPNAME}_table_01_pre.txt" "$OUT/${EXPNAME}_table_10_pre.txt" "$OUT/${EXPNAME}_bed01.bed" "$OUT/${EXPNAME}_bed10.bed"

bcftools mpileup "$OUT/${CTRLNAME}_final.bam" -A -R "$OUT/${EXPNAME}_bed10.bed" -f $FA -Ov -o "$OUT/${EXPNAME}_pile_10.vcf"

bcftools mpileup "$OUT/${EXPNAME}_final.bam" -A -R "$OUT/${EXPNAME}_bed01.bed" -f $FA -Ov -o "$OUT/${EXPNAME}_pile_01.vcf"

python3 remake_tables.py "$OUT/${EXPNAME}_pile_01.vcf" "$OUT/${EXPNAME}_pile_10.vcf" "$OUT/${EXPNAME}_table_01_pre.txt" "$OUT/${EXPNAME}_table_10_pre.txt" "$OUT/${EXPNAME}_table_01.txt" "$OUT/${EXPNAME}_table_10.txt"

cat "$OUT/${EXPNAME}_table_01.txt" "$OUT/${EXPNAME}_table_10.txt" "$OUT/${EXPNAME}_table_11.txt" | bedtools sort -i > "$OUT/${EXPNAME}_table_pre.txt"

python3 filter_table.py "$OUT/${EXPNAME}_table_pre.txt" "$OUT/${EXPNAME}_table.txt"

rm "$OUT/${EXPNAME}_table_10_pre.txt"
rm "$OUT/${EXPNAME}_table_01_pre.txt"
rm "$OUT/${EXPNAME}_bed01.bed"
rm "$OUT/${EXPNAME}_bed10.bed"
rm "$OUT/${EXPNAME}_table_pre.txt"
rm "$OUT/${EXPNAME}_table_10.txt"
rm "$OUT/${EXPNAME}_table_11.txt"
rm "$OUT/${EXPNAME}_table_01.txt"

exit 0
